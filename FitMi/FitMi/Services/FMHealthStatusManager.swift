//
//  FMHealthStatusManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import HealthKit

class FMHealthStatusManager: NSObject {
	static let sharedManager = FMHealthStatusManager()
	
	private let healthKitStore:HKHealthStore = HKHealthStore()
	
	func authorizeHealthKit(completion: ((_ success:Bool, _ error:NSError?) -> Void)!){
		let readTypes: Set<HKQuantityType> = Set([
			HKObjectType.quantityType(forIdentifier: .stepCount)!,
			HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
			HKObjectType.quantityType(forIdentifier: .flightsClimbed)!
		])
		
		if !HKHealthStore.isHealthDataAvailable() {
			let error = NSError(domain: "com.fitmi.FitMi", code: 2, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available in this device"])
			if (completion != nil) {
				completion!(false, error)
			}
			
			return
		}
		
		self.healthKitStore.requestAuthorization(toShare: nil, read: readTypes, completion: {
			(success, error) -> Void in
			
			if (completion != nil) {
				completion!(success, error as NSError?)
			}
			
		})
		
	}
}
