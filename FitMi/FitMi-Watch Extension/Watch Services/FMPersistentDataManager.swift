//
//  FMPersistentDataManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 27/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import WatchKit
import WatchConnectivity

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
		var array = sharedUserDefaults.array(forKey: CONNECTIVITY_KEY_WATCH_DATA) ?? [[String: String]]()
		let thisRecord = [
			WatchPersistentDataKey.startTime.rawValue : "\(startTime.timeIntervalSince1970)",
			WatchPersistentDataKey.endTime.rawValue : "\(endTime.timeIntervalSince1970)",
			WatchPersistentDataKey.steps.rawValue : "\(steps)",
			WatchPersistentDataKey.meters.rawValue : "\(meters)",
			WatchPersistentDataKey.floors.rawValue : "\(floors)",
		]
		
		array.append(thisRecord)
		sharedUserDefaults.set(array, forKey: CONNECTIVITY_KEY_WATCH_DATA)
	}
	
	func cachedRecords() -> [[String: String]] {
		let sharedUserDefaults = UserDefaults.standard
		let array = sharedUserDefaults.array(forKey: CONNECTIVITY_KEY_WATCH_DATA) ?? [[String: String]]()
		return array as! [[String : String]]
	}
	
	func pushRecordToHostDevice() {
		if pushRetried > PUSH_RETRY_MAX_COUNT {
			pushRetried = 0
			return
		}
		
		let record = self.cachedRecords()
		if WCSession.isSupported() {
			session.sendMessage([CONNECTIVITY_KEY_WATCH_DATA: record], replyHandler: {
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
