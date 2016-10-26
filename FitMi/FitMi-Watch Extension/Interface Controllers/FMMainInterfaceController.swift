//
//  FMExerciseInterfaceController.swift
//  FitMi
//
//  Created by Jinghan Wang on 27/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import WatchKit
import CoreMotion

class FMMainInterfaceController: WKInterfaceController {
	
	@IBOutlet var durationTimer: WKInterfaceTimer!
	@IBOutlet var stepValueLabel: WKInterfaceLabel!
	@IBOutlet var meterValueLabel: WKInterfaceLabel!
	@IBOutlet var floorValueLabel: WKInterfaceLabel!
	
	@IBOutlet var buttonTitleLabel: WKInterfaceLabel!
	
	fileprivate var exerciseStarted = false
	
	fileprivate var startDate: Date!
	fileprivate var endDate: Date!
	fileprivate var stepCount: Int = 0
	fileprivate var meterCount: Int = 0
	fileprivate var floorCount: Int = 0
	
	fileprivate var pedometer = CMPedometer()
	
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
	}
	
	@IBAction func toggleExercise(sender: WKInterfaceButton) {
		if !exerciseStarted {
			WKInterfaceDevice.current().play(.start)
			startDate = Date()
			durationTimer.setDate(startDate)
			durationTimer.start()
			buttonTitleLabel.setText("END EXERCISE")
			
			self.startMotionUpdates()
		} else {
			endDate = Date()
			WKInterfaceDevice.current().play(.stop)
			durationTimer.stop()
			buttonTitleLabel.setText("START EXERCISE")
			
			self.endMotionUpdates()
			self.generateExerciseReport()
		}
		exerciseStarted = !exerciseStarted
	}
	
	func generateExerciseReport() {
		print(startDate)
		print(endDate)
	}
	
	func updateView(from pedometerData: CMPedometerData) {
		stepCount = Int(pedometerData.numberOfSteps)
		
		if CMPedometer.isDistanceAvailable() {
			meterCount = Int(pedometerData.distance!)
		}
		
		if CMPedometer.isFloorCountingAvailable() {
			floorCount = Int(pedometerData.floorsAscended!)
		}
		
		self.updateView()
	}
	
	func updateView() {
		self.stepValueLabel.setText("\(stepCount)")
		self.meterValueLabel.setText("\(meterCount)")
		self.floorValueLabel.setText("\(floorCount)")
	}
}

extension FMMainInterfaceController {
	func startMotionUpdates() {
		let currentDate = Date()
		pedometer.startUpdates(from: currentDate) {
			(data, error) in
			if error != nil {
				print(error!)
			} else {
				if let motionData: CMPedometerData = data {
					self.updateView(from: motionData)
				}
			}
		}
	}
	
	func endMotionUpdates() {
		pedometer.stopUpdates()
	}
}
