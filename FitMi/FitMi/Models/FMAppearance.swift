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
	
	dynamic var name: String = ""
	dynamic var identifier: String = ""
	dynamic var lastUpdateTime: Date = Date()
	dynamic var unlockLevel: Int = 0
	
	let skills = List<FMSkill>()
	let actions = List<FMAction>()
	
	override static func indexedProperties() -> [String] {
		return ["identifier"]
	}
}
