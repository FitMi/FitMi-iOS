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
	dynamic var health: Int = 100
	dynamic var strength: Int = 200
	dynamic var stamina: Int = 100
	dynamic var agility: Int = 100
	dynamic var date: Date = Date()
	dynamic var level: Int = 0
	dynamic var experience: Int = 0
	let sprite = LinkingObjects(fromType: FMSprite.self, property: "states")
	
	override static func indexedProperties() -> [String] {
		return ["date"]
	}
}
