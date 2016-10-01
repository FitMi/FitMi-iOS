//
//  FMStatisticsViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMStatisticsViewController: FMViewController {

	private static var defaultController: FMStatisticsViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if FMStatisticsViewController.defaultController == nil {
			FMStatisticsViewController.defaultController = self
		}
		
		// Do any additional setup after loading the view.
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		FMHealthStatusManager.sharedManager.authorizeHealthKit {
			(authorized,  error) -> Void in
			if authorized {
				FMHealthStatusManager.sharedManager.quantity(daysBack: 3, type: .distanceWalkingRunning, completion: {
					error, dates, values in
					if error == nil {
						for i in 0..<dates.count {
							print("Distance: \(dates[i]) --- \(values[i]) m")
						}
					} else {
						print(error)
					}
				})
				
				FMHealthStatusManager.sharedManager.quantity(daysBack: 3, type: .stepCount, completion: {
					error, dates, values in
					if error == nil {
						for i in 0..<dates.count {
							print("Steps: \(dates[i]) --- \(values[i])")
						}
					} else {
						print(error)
					}
				})
				
				FMHealthStatusManager.sharedManager.quantity(daysBack: 3, type: .flightsClimbed, completion: {
					error, dates, values in
					if error == nil {
						for i in 0..<dates.count {
							print("Flights: \(dates[i]) --- \(values[i])")
						}
					} else {
						print(error)
					}
				})
			} else {
				print("HealthKit authorization denied!")
				if error != nil {
					print("\(error)")
				}
			}
		}
	}
	
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	class func getDefaultController() -> FMStatisticsViewController {
		if FMStatisticsViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMStatisticsViewController") as! FMStatisticsViewController
			FMStatisticsViewController.defaultController = controller
		}
		
		return FMStatisticsViewController.defaultController!
	}
}
