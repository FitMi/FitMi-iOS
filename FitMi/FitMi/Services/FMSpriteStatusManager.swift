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
		var sum = 0.0
		var weights: [Double] = [0.25, 0.2, 0.15, 0.1, 0.1, 0.1, 0.1]
		for i in 0..<weights.count - 1 {
			if i < states.count {
				sum += Double(states[i].strength) * weights[i + 1]
			} else {
				sum += Double(SPRITE_STRENGTH_DEFAULT) * weights[i + 1]
			}
		}
		
		let goal = Double(FMHealthStatusManager.sharedManager.goalForSteps())
		sum += Double(steps)/goal * weights[0] * Double(SPRITE_STRENGTH_DEFAULT)
		return Int(sum)
	}
	
	func staminaForDate(date: Date, distance: Int) -> Int {
		let states = self.sprite.states.filter("date < %@", Calendar.current.startOfDay(for: date)).sorted(byProperty: "date", ascending: false)
		var sum = 0.0
		var weights: [Double] = [0.25, 0.2, 0.15, 0.1, 0.1, 0.1, 0.1]
		for i in 0..<weights.count - 1 {
			if i < states.count {
				sum += Double(states[i].stamina) * weights[i + 1]
			} else {
				sum += Double(SPRITE_STAMINA_DEFAULT) * weights[i + 1]
			}
		}
		
		let goal = Double(FMHealthStatusManager.sharedManager.goalForDistance())
		sum += Double(distance)/goal * weights[0] * Double(SPRITE_STAMINA_DEFAULT)
		return Int(sum)
	}
	
	func agilityForDate(date: Date, flights: Int) -> Int {
		let states = self.sprite.states.filter("date < %@", Calendar.current.startOfDay(for: date)).sorted(byProperty: "date", ascending: false)
		var sum = 0.0
		var weights: [Double] = [0.25, 0.2, 0.15, 0.1, 0.1, 0.1, 0.1]
		for i in 0..<weights.count - 1 {
			if i < states.count {
				sum += Double(states[i].agility) * weights[i + 1]
			} else {
				sum += Double(SPRITE_AGILITY_DEFAULT) * weights[i + 1]
			}
		}
		
		let goal = Double(FMHealthStatusManager.sharedManager.goalForFlights())
		sum += Double(flights)/goal * weights[0] * Double(SPRITE_AGILITY_DEFAULT)
		return Int(sum)
	}
	
	func refreshHealthForState(state: FMSpriteState, stepCount: Int, distance: Int, flights: Int) {
		let states = self.sprite.states.filter("date < %@", Calendar.current.startOfDay(for: state.date)).sorted(byProperty: "date", ascending: false)
		let lastHealth = Double(states.count == 0 ? SPRITE_HEALTH_DEFAULT :states.last!.health)
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

	func increaseExperienceBySteps(steps: Int) {
		// TODO: increase 2 experience for every step
		let firstState = self.sprite.states.first
		FMDatabaseManager.sharedManager.realmUpdate {
			firstState!.experience += (2 * steps)
		}
	}

	func increaseExperienceByGoals(goals: Int) {
		// TODO: increase 250 experience for every finished goal
		let firstState = self.sprite.states.first
		FMDatabaseManager.sharedManager.realmUpdate {
			firstState!.experience += (250 * goals)
		}
	}
}
