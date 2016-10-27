//
//  FMPersistentDataManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 27/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import WatchKit
import WatchConnectivity

let WatchDataUserDefaultKey = "WatchExerciseData"
let pushRetryMaximumCount = 5
enum PersistentDataKey: String {
	case startTime = "PersistentDataKey.startTime"
	case endTime = "PersistentDataKey.endTime"
	case steps = "PersistentDataKey.steps"
	case meters = "PersistentDataKey.meters"
	case floors = "PersistentDataKey.floors"
}

class FMPersistentDataManager: NSObject {
	static var shared = FMPersistentDataManager()
	fileprivate var pushRetried = 0
	
	var session: WCSession! {
		didSet {
			if let session = session {
				session.delegate = self
				session.activate()
			}
		}
	}
	
	override init() {
		super.init()
		
		if WCSession.isSupported() {
			session = WCSession.default()
		}
	}
	
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
	
	func pushRecordToHostDevice() {
		if pushRetried > pushRetryMaximumCount {
			pushRetried = 0
			return
		}
		
		let record = self.cachedRecords()
		if WCSession.isSupported() {
			session.sendMessage([WatchDataUserDefaultKey: record], replyHandler: {
				response in
				if response["success"] as! Int == 1 {
					self.pushRetried = 0
					self.recordDidPush()
				}
			}, errorHandler: {
				error in
				self.pushRetried += 1
				self.pushRecordToHostDevice()
			})
		}
	}
	
	func recordDidPush() {
		print("record pushed")
	}
}

extension FMPersistentDataManager: WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Activation Error: \(error)")
	}
}
