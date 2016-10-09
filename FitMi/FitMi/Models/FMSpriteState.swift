//
//  FMSpriteStatus.swift
//  FitMi
//
//  Created by Jinghan Wang on 8/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import RealmSwift

class FMSpriteState: Object {
	dynamic var health: Int = SPRITE_HEALTH_DEFAULT
	dynamic var strength: Int = SPRITE_STRENGTH_DEFAULT
	dynamic var stamina: Int = SPRITE_STAMINA_DEFAULT
	dynamic var agility: Int = SPRITE_AGILITY_DEFAULT
	dynamic var stepCount: Int = 0
	dynamic var distance: Int = 0
	dynamic var flightsClimbed: Int = 0
	
	dynamic var date: Date = Date()
	dynamic var level: Int = 0
	dynamic var experience: Int = 0
	let sprite = LinkingObjects(fromType: FMSprite.self, property: "states")
	
	override static func indexedProperties() -> [String] {
		return ["date"]
	}
}
