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
	
	func currentStrength() -> Double {
		return 0
	}
	
	func currentStamina() -> Double {
		return 0
	}
	
	func currentAgility() -> Double {
		return 0
	}
	
	func currentExperience() -> Double {
		return 0
	}
	
	func currentLevel() -> Double {
		return 0
	}
	
	func currentMood() -> Double {
		// TODO: check the time of last data point and calculate current mode
		return 50
	}
	
	func currentHP() -> Double {
		return 0
	}
	
	func updateSpriteStatus(steps: Double, distance: Double, flights: Double, date: Date) {
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
	
	func increaseExperience(increment: Double) {
		
	}
}
