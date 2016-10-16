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
	
	dynamic var name: String = "Default"
	dynamic var strengthFactor: Double = 1
	dynamic var staminaFactor: Double = 1
	dynamic var agilityFactor: Double = 1
	dynamic var	unlockLevel: Int = 0
	
	dynamic var attackSpriteAtlasName: String = ""
	dynamic var defenseSpriteAtlasName: String = ""
	
	let appearance = LinkingObjects(fromType: FMAppearance.self, property: "skills")
	
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
