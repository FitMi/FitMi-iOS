//
//  FMPersistentDataManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 27/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

let WatchDataUserDefaultKey = "WatchExerciseData"
enum PersistentDataKey: String {
	case startTime = "PersistentDataKey.startTime"
	case endTime = "PersistentDataKey.endTime"
	case steps = "PersistentDataKey.steps"
	case meters = "PersistentDataKey.meters"
	case floors = "PersistentDataKey.floors"
}

class FMPersistentDataManager: NSObject {
	static var shared = FMPersistentDataManager()
	
	func persistExerciseRecord(startTime: Date, endTime: Date, steps: Int, meters: Int, floors: Int) {
		let sharedUserDefaults = UserDefaults.standard
		var array = sharedUserDefaults.array(forKey: WatchDataUserDefaultKey) ?? [[String: String]]()
		let thisRecord = [
			PersistentDataKey.startTime.rawValue : "\(startTime.timeIntervalSince1970)",
			PersistentDataKey.endTime.rawValue : "\(endTime.timeIntervalSince1970)",
			PersistentDataKey.steps.rawValue : "\(steps)",
			PersistentDataKey.meters.rawValue : "\(meters)",
			PersistentDataKey.floors.rawValue : "\(floors)",
		]
		
		array.append(thisRecord)
		sharedUserDefaults.set(array, forKey: WatchDataUserDefaultKey)
	}
	
	func cachedRecords() -> [[String: String]] {
		let sharedUserDefaults = UserDefaults.standard
		let array = sharedUserDefaults.array(forKey: WatchDataUserDefaultKey) ?? [[String: String]]()
		return array as! [[String : String]]
	}
}
