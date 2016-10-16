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
	dynamic var id: String = "randomidrandomid"
	dynamic var strengthFactor: Double = 1
	dynamic var staminaFactor: Double = 1
	dynamic var agilityFactor: Double = 1
	
	dynamic var	appearanceId: String = "appearance-id"
	dynamic var attackSpriteAtlasName: String = ""
	dynamic var defenseSpriteAtlasName: String = ""
	
	
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
