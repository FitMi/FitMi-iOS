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
	
	// This method will fetch lastest data from DB/HealthKit and then update the current sprite
	// This should only be called when resumed from background or newly started up
	// In-app states update should use other approach due to the mood property
	
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
		
		FMHealthStatusManager.sharedManager.stepsForDate(date: date, completion: {
			error, value in
			DispatchQueue.main.async {
				stepCount = error == nil ? value : 0
				FMDatabaseManager.sharedManager.realmUpdate {
					state.stepCount = stepCount!
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
		
		let goal = Double(FMHealthStatusManager.sharedManager.goalForSteps(date: date))
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
		
		let goal = Double(FMHealthStatusManager.sharedManager.goalForDistance(date: date))
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
		
		let goal = Double(FMHealthStatusManager.sharedManager.goalForFlights(date: date))
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
		let stepCountGoal = Double(manager.goalForSteps(date: date))
		let distanceGoal = Double(manager.goalForDistance(date: date))
		let flightsGoal = Double(manager.goalForFlights(date: date))
		return (Double(stepCount) / stepCountGoal) * (Double(distance) / distanceGoal) * (Double(flights) / flightsGoal)
	}
	
	// -------------- current data getter ---------------
	
	func currentStrength() -> Int {
		return 0
	}
	
	func currentStamina() -> Int {
		return 0
	}
	
	func currentAgility() -> Int {
		return 0
	}
	
	func currentExperience() -> Int {
		return 0
	}
	
	func currentLevel() -> Int {
		return 0
	}
	
	func currentMood() -> Int {
		// TODO: check the time of last data point and calculate current mode
		return 50
	}
	
	func currentHP() -> Int {
		return 0
	}
	
	
	
	
	// -------------- historical data getter ---------------
	
	
	
	
	func historicalStrength(daysBack: Int) -> [Int] {
		return [0]
	}
	
	func historicalStamina(daysBack: Int) -> [Int] {
		return [0]
	}
	
	func historicalAgility(daysBack: Int) -> [Int] {
		return [0]
	}
	
	func historicalExperience(daysBack: Int) -> [Int] {
		return [0]
	}
	
	func historicalLevel(daysBack: Int) -> [Int] {
		return [0]
	}
	
	func historicalMood(daysBack: Int) -> [Int] {
		return [0]
	}
	
	func historicalHP(daysBack: Int) -> [Int] {
		return [0]
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
	
	func increaseExperience(increment: Int) {
		
	}
}
