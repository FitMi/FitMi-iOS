//
//  FMSpriteStatusManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMSpriteStatusManager: NSObject {
	static let sharedManager = FMSpriteStatusManager()
	let databaseManager = FMDatabaseManager.sharedManager
	var sprite: FMSprite!
	
    override init() {
        super.init()
        DispatchQueue.main.async {
            self.sprite = self.databaseManager.getCurrentSprite()
        }
    }
	
	func spriteAppearance() -> FMAppearance {
		let manager = FMDatabaseManager.sharedManager
		let appearance = manager.appearances().filter("identifier = %@", self.sprite.appearanceIdentifier).first!
		return appearance
	}
	
	// This method will fetch lastest data from DB/HealthKit and then update the current sprite
	var refreshInProgress = false
	func refreshSprite(completion: @escaping ((_ success: Bool)->Void)) {
		if refreshInProgress == true {
			completion(false)
			return
		}
		
		self.refreshInProgress = true
		
		DispatchQueue.main.async {
			self.sprite = self.databaseManager.getCurrentSprite()
			var lastState = self.sprite.states.last
			if self.sprite.states.count == 0 {
				lastState = FMSpriteState()
				self.databaseManager.realmUpdate {
					self.sprite.states.append(lastState!)
				}
			}
			
			var placeholder: ((_ state : FMSpriteState, _ strength : Int, _ stamina : Int, _ agility : Int, _ stepCount: Int, _ distance: Int, _ flight: Int) -> Void)!
			
			let stateCompletion: ((_ state : FMSpriteState, _ strength : Int, _ stamina : Int, _ agility : Int, _ stepCount: Int, _ distance: Int, _ flight: Int) -> Void) = {
				state, strength, stamina, agility, stepCount, distance, flights in
				DispatchQueue.main.async {
					FMDatabaseManager.sharedManager.realmUpdate {
						state.strength = strength
						state.stamina = stamina
						state.agility = agility
						state.stepCount = stepCount
						state.distance = distance
						state.flightsClimbed = flights
					}
					
					self.refreshHealthForState(state: state, stepCount: stepCount, distance: distance, flights: flights)
					self.refreshExperienceForState(state: state, stepCount: stepCount, distance: distance, flights: flights)
					
					if NSCalendar.current.isDateInToday(state.date) {
						self.refreshInProgress = false
						completion(true)
					} else {
						let nextState = FMSpriteState()
						nextState.date = Calendar.current.nextDay(from: state.date)
						FMDatabaseManager.sharedManager.realmUpdate {
							self.sprite.states.append(nextState)
						}
						self.refreshState(state: nextState, completion: placeholder)
					}

				}
			}
			
			placeholder = stateCompletion
			
			self.refreshState(state: lastState!, completion: stateCompletion)
		}
	}
	
	func refreshState(state: FMSpriteState, completion: @escaping ((_ state: FMSpriteState, _ strength: Int, _ stamina: Int, _ agility: Int, _ stepCount: Int, _ distance: Int, _ flight: Int)->Void)) {
		var strength: Int?
		var stamina: Int?
		var agility: Int?
		var stepCount: Int?
		var distance: Int?
		var flights: Int?
		let date = state.date
		let healthStatusManager = FMHealthStatusManager.sharedManager
		
		FMHealthStatusManager.sharedManager.stepsForDate(date: date, completion: {
			error, value in
			DispatchQueue.main.async {
				stepCount = error == nil ? value : 0
				FMDatabaseManager.sharedManager.realmUpdate {
					state.stepCount = stepCount!
					state.stepGoal = healthStatusManager.goalForSteps()
				}
				strength = self.strengthForDate(date: date, steps: stepCount!)
				if strength != nil && stamina != nil && agility != nil {
					completion(state, strength!, stamina!, agility!, stepCount!, distance!, flights!)
				}
			}
		})
		
		FMHealthStatusManager.sharedManager.distanceForDate(date: date, completion: {
			error, value in
			DispatchQueue.main.async {
				distance = error == nil ? value : 0
				FMDatabaseManager.sharedManager.realmUpdate {
					state.distance = distance!
					state.distanceGoal = healthStatusManager.goalForDistance()
				}
				stamina = self.staminaForDate(date: date, distance: distance!)
				if strength != nil && stamina != nil && agility != nil {
					completion(state, strength!, stamina!, agility!, stepCount!, distance!, flights!)
				}
			}
		})
		
		FMHealthStatusManager.sharedManager.flightsForDate(date: date, completion: {
			error, value in
			DispatchQueue.main.async {
				flights = error == nil ? value : 0
				FMDatabaseManager.sharedManager.realmUpdate {
					state.agility = agility!
					state.flightsGoal = healthStatusManager.goalForFlights()
				}
				agility = self.agilityForDate(date: date, flights: flights!)
				if strength != nil && stamina != nil && agility != nil {
					completion(state, strength!, stamina!, agility!, stepCount!, distance!, flights!)
				}
			}
		})
	}
	
	func strengthForDate(date: Date, steps: Int) -> Int {
		let states = self.sprite.states.filter("date < %@", Calendar.current.startOfDay(for: date)).sorted(byProperty: "date", ascending: false)
		let base = states.count > 0 ? states.first!.strength : 100
		let goal = FMHealthStatusManager.sharedManager.goalForSteps()
		let bonus = steps > goal ? (goal / WORKOUT_GOAL_PER_UNIT_BONUS_STEPS) : 0
		return base + steps/1000 + bonus
	}
	
	func staminaForDate(date: Date, distance: Int) -> Int {
		let states = self.sprite.states.filter("date < %@", Calendar.current.startOfDay(for: date)).sorted(byProperty: "date", ascending: false)
		let base = states.count > 0 ? states.first!.stamina : 100
		let goal = FMHealthStatusManager.sharedManager.goalForDistance()
		let bonus = distance > goal ? (goal / WORKOUT_GOAL_PER_UNIT_BONUS_DISTANCE) : 0
		return base + distance/500 + bonus
	}
	
	func agilityForDate(date: Date, flights: Int) -> Int {
		let states = self.sprite.states.filter("date < %@", Calendar.current.startOfDay(for: date)).sorted(byProperty: "date", ascending: false)
		let base = states.count > 0 ? states.first!.agility : 100
		let goal = FMHealthStatusManager.sharedManager.goalForFlights()
		let bonus = flights > goal ? (goal / WORKOUT_GOAL_PER_UNIT_BONUS_FLIGHTS) : 0
		return base + flights + bonus
	}
	
	func refreshHealthForState(state: FMSpriteState, stepCount: Int, distance: Int, flights: Int) {
		let states = self.sprite.states.filter("date < %@", Calendar.current.startOfDay(for: state.date)).sorted(byProperty: "date", ascending: false)
		let lastHealth = Double(states.count == 0 ? SPRITE_HEALTH_DEFAULT :states.first!.health)
		let factor = self.healthFactor(date: state.date, stepCount: stepCount, distance: distance, flights: flights)
		let health = (1 - SPRITE_HEALTH_WEIGHT_TODAY) * lastHealth + SPRITE_HEALTH_WEIGHT_TODAY * lastHealth * factor
		let healthLimit = FMSpriteLevelManager.sharedManager.healthLimitForLevel(level: self.sprite.states.last!.level)

		FMDatabaseManager.sharedManager.realmUpdate {
			state.health = min(healthLimit, Int(health))
		}
	}
	
	func healthFactor(date: Date, stepCount: Int, distance: Int, flights: Int) -> Double{
		let manager = FMHealthStatusManager.sharedManager
		let stepCountGoal = Double(manager.goalForSteps())
		let distanceGoal = Double(manager.goalForDistance())
		let flightsGoal = Double(manager.goalForFlights())
		return (Double(stepCount) / stepCountGoal) * (Double(distance) / distanceGoal) * (Double(flights) / flightsGoal)
	}
	
	func refreshExperienceForState(state: FMSpriteState, stepCount: Int, distance: Int, flights: Int) {
		let states = self.sprite.states.filter("date < %@", Calendar.current.startOfDay(for: state.date)).sorted(byProperty: "date", ascending: false)
		var exp = states.count == 0 ? 0 : states.first!.experience
		
		exp += self.experienceForSteps(steps: stepCount)
		exp += self.experienceForDistance(meters: distance)
		exp += self.experienceForFlights(flights: flights)
		exp += self.experienceForGoals(stepCount: stepCount, distance: distance, flights: flights)
		
		FMDatabaseManager.sharedManager.realmUpdate {
			print(exp)
			state.experience = exp
			state.level = FMSpriteLevelManager.sharedManager.levelForExp(exp: exp)
		}
	}
	
	func experienceForSteps(steps: Int) -> Int{
		return steps / 50
	}
	
	func experienceForDistance(meters: Int) -> Int{
		return meters / 50
	}
	
	func experienceForFlights(flights: Int) -> Int{
		return flights * 20
	}
	
	func experienceForGoals(stepCount: Int, distance: Int, flights: Int) -> Int{
		let healthStatusManager = FMHealthStatusManager.sharedManager
		let stepGoal = healthStatusManager.goalForSteps()
		let distanceGoal = healthStatusManager.goalForDistance()
		let flightGoal = healthStatusManager.goalForFlights()
		
		var exp = 0
		
		if stepCount > stepGoal {
			exp += self.experienceForSteps(steps: stepGoal)
		}
		
		if distance > distanceGoal {
			exp += self.experienceForDistance(meters: distanceGoal)
		}
		
		if flights > flightGoal {
			exp += self.experienceForFlights(flights: flightGoal)
		}
		
		return exp
	}
	
	// -------------- current data getter ---------------
	
	func currentStrength() -> Int {
		let firstState = self.sprite.states.first
		return firstState == nil ? 0 : firstState!.strength
	}
	
	func currentStamina() -> Int {
		let firstState = self.sprite.states.first
		return firstState == nil ? 0 : firstState!.stamina
	}
	
	func currentAgility() -> Int {
		let firstState = self.sprite.states.first
		return firstState == nil ? 0 : firstState!.agility
	}
	
	func currentExperience() -> Int {
		let firstState = self.sprite.states.first
		return firstState == nil ? 0 : firstState!.experience
	}
	
	func currentLevel() -> Int {
		let firstState = self.sprite.states.first
		return firstState == nil ? 0 : firstState!.level
	}
	
	func currentMood() -> Int {
		// TODO: check the time of last data point and calculate current mode
		return self.sprite.mood
	}
	
	func currentHP() -> Int {
		let firstState = self.sprite.states.first
		return firstState == nil ? 0 : firstState!.health
	}
	
	// -------------- data setter ---------------
	
	
	
	
	func updateSpriteStatus(steps: Int, distance: Int, flights: Int, date: Date) {
		// TODO: Check whether data exist for the date
		// If so, replace the old data
		// If not, add in the new data
	}
	
	// Return value indicates whether the operation is successful
	func increaseMood() -> Bool {
		// TODO: check the time of last data point and see whether increase mood is allowed
		// TODO: check whether the mood is full
		return false
	}
}
