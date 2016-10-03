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
	
	func createNewSprite() -> FMSprite {
		// TODO: Set correct initial values
		return FMSprite()
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
