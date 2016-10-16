//
//  FMAppearance.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import RealmSwift

class FMAppearance: Object {
	
	dynamic var name: String = "Default"
	dynamic var id: String = "id"
	
	let skills = List<FMSKill>()
	let actions = List<FMAction>()
	
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
