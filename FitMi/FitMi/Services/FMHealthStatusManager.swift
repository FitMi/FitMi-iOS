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
	
	func steps(daysBack: Int) {
		let calendar = NSCalendar.current
		let interval = NSDateComponents()
		interval.day = 1
		var anchorComponents = calendar.dateComponents(Set([.day, .month, .year]), from: Date())
		anchorComponents.hour = 0
		let anchorDate = calendar.date(from: anchorComponents)
		
		let query = HKStatisticsCollectionQuery(quantityType: HKObjectType.quantityType(forIdentifier: .stepCount)!,
		                                        quantitySamplePredicate: nil,
		                                        options: .cumulativeSum,
		                                        anchorDate: anchorDate!,
		                                        intervalComponents: interval as DateComponents)
		query.initialResultsHandler = {
			query, results, error in
			
			if error != nil {
				print(error)
			} else {
				let endDate = Date()
				let startDate = calendar.date(byAdding: .day, value: -daysBack, to: endDate)
				
				results?.enumerateStatistics(from: startDate!,to: endDate, with: {
					result, stop in
					if let quantity = result.sumQuantity() {
						let date = result.startDate
						let value = Int(quantity.doubleValue(for: HKUnit.count()))
						print("\(date): \(value)")
					}
				})
				
			}
			
		}
		
		self.healthKitStore.execute(query)
		
	}
}
