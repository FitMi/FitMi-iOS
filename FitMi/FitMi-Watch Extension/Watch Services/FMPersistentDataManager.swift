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
	fileprivate var lastSyncTimePrivate: Date? {
		set(newValue) {
			if let value = newValue {
				UserDefaults.standard.set("\(value.timeIntervalSince1970)", forKey: CONNECTIVITY_KEY_WATCH_DATA_LAST_SYNC_DATE)
			}
		}
		
		get {
			if let timeStampString = UserDefaults.standard.string(forKey: CONNECTIVITY_KEY_WATCH_DATA_LAST_SYNC_DATE) {
				return Date(timeIntervalSince1970: TimeInterval(timeStampString)!)
			} else {
				return nil
			}
		}
	}
	var lastSyncTime: Date? {
		get {
			return lastSyncTimePrivate
		}
	}
	
	var session: WCSession! {
		didSet {
			if let session = session {
				session.delegate = self
				session.activate()
			}
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
	
	func pushRecordToHostDevice(completion: @escaping ((_ success: Bool) -> Void)) {
		
		// TODO: WWDC Question
		print("Any Message")
		
		if pushRetried > PUSH_RETRY_MAX_COUNT {
			pushRetried = 0
			completion(false)
			return
		}
		
		let record = self.cachedRecords()
		if WCSession.isSupported() {
			if self.session == nil {
				session = WCSession.default()
			}
			
			guard session.activationState == .activated else {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
					self.pushRecordToHostDevice(completion: completion)
				})
				return
			}
			
			session.sendMessage([CONNECTIVITY_KEY_WATCH_DATA: record], replyHandler: {
				response in
				if response["success"] as! Int == 1 {
					self.lastSyncTimePrivate = Date()
					self.pushRetried = 0
					self.recordDidPush()
					completion(true)
				} else {
					completion(false)
				}
			}, errorHandler: {
				error in
				self.pushRetried += 1
				self.pushRecordToHostDevice(completion: completion)
			})
		} else {
			completion(false)
		}
	}
	
	func recordDidPush() {
		print("record pushed")
		UserDefaults.standard.removeObject(forKey: CONNECTIVITY_KEY_WATCH_DATA)
	}
}

extension FMPersistentDataManager: WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Activation Error: \(String(describing: error))")
	}
}
