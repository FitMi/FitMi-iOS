//
//  FMExerciseRecord.swift
//  FitMi
//
//  Created by Jinghan Wang on 11/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import RealmSwift

class FMExerciseRecord: Object {
	dynamic var steps: Int = 0
	dynamic var distance: Int = 0
	dynamic var flights: Int = 0
	dynamic var startTime: Date = Date()
	dynamic var endTime: Date = Date()
	
	let sprite = LinkingObjects(fromType: FMSprite.self, property: "exercises")
}
