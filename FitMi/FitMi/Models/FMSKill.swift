//
//  FMSKill.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import RealmSwift

class FMSKill: Object {
	
	dynamic var name: String = ""
	dynamic var identifier: String = ""
	dynamic var strengthFactor: Double = 1
	dynamic var staminaFactor: Double = 1
	dynamic var agilityFactor: Double = 1
	dynamic var	unlockLevel: Int = 0
	
	dynamic var attackSpriteAtlasCount: Int = 0
	dynamic var defenceSpriteAtlasCount: Int = 0
	
	let appearance = LinkingObjects(fromType: FMAppearance.self, property: "skills")
	
	override static func indexedProperties() -> [String] {
		return ["identifier"]
	}
}
