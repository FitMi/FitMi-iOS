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
						self.sprite.skillSlotCount = FMSpriteLevelManager.sharedManager.skillSlotCountForLevel(level: state.level)
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
		let level = FMSpriteLevelManager.sharedManager.levelForExp(exp: exp)
		FMDatabaseManager.sharedManager.realmUpdate {
			state.experience = exp
			state.level = level
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
		let lastState = self.sprite.states.last
		return lastState == nil ? 0 : lastState!.strength
	}
	
	func currentStamina() -> Int {
		let lastState = self.sprite.states.last
		return lastState == nil ? 0 : lastState!.stamina
	}
	
	func currentAgility() -> Int {
		let lastState = self.sprite.states.last
		return lastState == nil ? 0 : lastState!.agility
	}
	
	func currentExperience() -> Int {
		let lastState = self.sprite.states.last
		return lastState == nil ? 0 : lastState!.experience
	}
	
	func currentLevel() -> Int {
		let lastState = self.sprite.states.last
		return lastState == nil ? 0 : lastState!.level
	}
	
	func currentMood() -> Int {
		// TODO: check the time of last data point and calculate current mode
		return self.sprite.mood
	}
	
	func currentHP() -> Int {
		let lastState = self.sprite.states.last
		return lastState == nil ? 0 : lastState!.health
	}
	
	// -------------- data setter ---------------
	
	
	func updateAppearance(appearance: FMAppearance) {
		let newIdentifier = appearance.identifier
		var newSkills = [FMSkill]()
		var newActions = [FMAction]()
		
		FMDatabaseManager.sharedManager.realmUpdate {
			self.sprite.appearanceIdentifier = newIdentifier
		}
		
		let manager = FMDatabaseManager.sharedManager
		
		for skill in self.sprite.skills {
			let newSkill = manager.skill(appearanceIdentifier: newIdentifier, name: skill.name)
			newSkills.append(newSkill)
		}
		
		for action in self.sprite.actions {
			let newAction = manager.action(appearanceIdentifier: newIdentifier, name: action.name)
			newActions.append(newAction)
		}
		
		let runAction = manager.action(appearanceIdentifier: newIdentifier, name: self.sprite.runAction.name)
		let sleepAction = manager.action(appearanceIdentifier: newIdentifier, name: self.sprite.sleepAction.name)
		let tiredAction = manager.action(appearanceIdentifier: newIdentifier, name: self.sprite.tiredAction.name)
		let relaxAction = manager.action(appearanceIdentifier: newIdentifier, name: self.sprite.relaxAction.name)
		let touchAction = manager.action(appearanceIdentifier: newIdentifier, name: self.sprite.touchAction.name)
		let wakeAction = manager.action(appearanceIdentifier: newIdentifier, name: self.sprite.wakeAction.name)
		
		
		FMDatabaseManager.sharedManager.realmUpdate {
			self.sprite.skills.removeAll()
			self.sprite.skills.append(objectsIn: newSkills)
			self.sprite.actions.removeAll()
			self.sprite.actions.append(objectsIn: newActions)
			
			self.sprite.runAction = runAction
			self.sprite.sleepAction = sleepAction
			self.sprite.tiredAction = tiredAction
			self.sprite.relaxAction = relaxAction
			self.sprite.touchAction = touchAction
			self.sprite.wakeAction = wakeAction
		}
	}
	
	func updateAction(action: FMAction) {
		FMDatabaseManager.sharedManager.realmUpdate {
			switch action.type {
			case "Run":
				self.sprite.runAction = action
			case "Relax":
				self.sprite.relaxAction = action
			case "Sleep":
				self.sprite.sleepAction = action
			case "Wake":
				self.sprite.wakeAction = action
			case "Touch":
				self.sprite.touchAction = action
			case "Tired":
				self.sprite.tiredAction = action
			default:
				print("unsupported action type")
			}
		}
	}
	
	func useSkill(skill: FMSkill) {
		if self.sprite.skillsInUse.contains(skill) {
			return
		} else if self.sprite.skillsInUse.count >= self.sprite.skillSlotCount {
			return
		}
		
		FMDatabaseManager.sharedManager.realmUpdate {
			self.sprite.skillsInUse.append(skill)
		}
	}
	
	func unuseSkill(skill: FMSkill) {
		FMDatabaseManager.sharedManager.realmUpdate {
			if let index = self.sprite.skillsInUse.index(of: skill) {
				self.sprite.skillsInUse.remove(objectAtIndex: index)
			}
		}
	}
	
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
    
    func pushSpriteStatusToRemote(completion: @escaping (_ error: Error?, _ success: Bool) -> Void) {
        let sprite = self.sprite!
        let skillInUse = sprite.skillsInUse
        var skills: [String] = []
        for skill in skillInUse {
            skills.append(skill.identifier)
        }
        let data = [
            "newData": [
                "spritename": sprite.name,
                "strength": sprite.states.last?.strength as Int!,
                "stamina": sprite.states.last?.stamina as Int!,
                "agility": sprite.states.last?.agility as Int!,
                "health" : sprite.states.last?.health as Int!,
                "healthLimit" : sprite.states.last?.health as Int!,
                "level": sprite.states.last?.level as Int!,
                "skillInUse": skills,
                "appearance": sprite.appearanceIdentifier
            ]
        ];
        FMNetworkManager.sharedManager.updateUser(newData: data, completion: completion)
    }
}
