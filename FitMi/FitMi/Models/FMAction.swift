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
	
	dynamic var name: String = ""
	dynamic var identifier: String = ""
	dynamic var	type: String = ""
	dynamic var	unlockLevel: Int = 0
	
	dynamic var spriteAtlasCount: Int = 0
	
	let appearance = LinkingObjects(fromType: FMAppearance.self, property: "actions")
	
	override static func indexedProperties() -> [String] {
		return ["identifier"]
	}
}
