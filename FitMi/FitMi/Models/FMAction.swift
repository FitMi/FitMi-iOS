//
//  FMAction.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import RealmSwift

class FMAction: Object {
	
	dynamic var id: String = "randomidrandomid"
	dynamic var	type: String = "SLEEP"
	dynamic var	appearanceId: String = "appearance-id"
	
	dynamic var spriteAtlasName: String = ""
	
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
