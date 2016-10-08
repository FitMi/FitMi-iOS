//
//  FMSprite.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import RealmSwift

class FMSprite: Object {
	
	dynamic var identifier: String = ""
	dynamic var name: String = ""
	dynamic var type: String = ""
	dynamic var mode: Int = 100
	dynamic var birthday:Date = Date()
	let states = List<FMSpriteStatus>()
	
	override static func indexedProperties() -> [String] {
		return ["identifier"]
	}

// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
