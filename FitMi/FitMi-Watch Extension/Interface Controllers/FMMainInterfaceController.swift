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
	@IBOutlet var spriteImage: WKInterfaceImage!
	
	@IBOutlet var buttonTitleLabel: WKInterfaceLabel!
	
	fileprivate var exerciseStarted = false
	fileprivate var wasMoving = false
	
	fileprivate var startDate: Date!
	fileprivate var endDate: Date!
	fileprivate var stepCount: Int = 0
	fileprivate var meterCount: Int = 0
	fileprivate var floorCount: Int = 0
	
	fileprivate var pedometer = CMPedometer()
	fileprivate var activityManager = CMMotionActivityManager()
	fileprivate let dataProcessingQueue = OperationQueue()
	
	fileprivate var animatedImageRun: UIImage!
	fileprivate var animatedImageRelax: UIImage!
	
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		animateRelax()
		
		let records = FMPersistentDataManager.shared.cachedRecords()
		print("Exercise Records")
		print(records)
	}
	
	fileprivate func animateRun() {
		self.spriteImage.stopAnimating()
		self.spriteImage.setImageNamed("run")
		self.spriteImage.startAnimatingWithImages(in: NSRange(location: 0, length: 6), duration: 1, repeatCount: 0)
	}
	
	fileprivate func animateRelax() {
		self.spriteImage.stopAnimating()
		self.spriteImage.setImageNamed("relax")
		self.spriteImage.startAnimatingWithImages(in: NSRange(location: 0, length: 2), duration: 0.5, repeatCount: 0)
	}

	@IBAction func showGoalView() {
		
	}
	
	@IBAction func showStatsView() {
		
	}
	
	@IBAction func showRecordsView() {
		self.pushController(withName: "FMRecordListInterfaceController", context: nil)
	}
	
	@IBAction func toggleExercise(sender: WKInterfaceButton) {
		if !exerciseStarted {
			WKInterfaceDevice.current().play(.start)
			resetExerciseData()
			durationTimer.start()
			buttonTitleLabel.setText("END EXERCISE")
			
			self.startMotionUpdates()
		} else {
			endDate = Date()
			WKInterfaceDevice.current().play(.stop)
			durationTimer.stop()
			buttonTitleLabel.setText("START EXERCISE")
			
			endMotionUpdates()
			animateRelax()
			generateExerciseReport()
		}
		exerciseStarted = !exerciseStarted
	}
	
	fileprivate func resetExerciseData() {
		startDate = Date()
		endDate = nil
		durationTimer.setDate(startDate)
		stepCount = 0
		meterCount = 0
		floorCount = 0
		self.updateView()
	}
	
	func generateExerciseReport() {
		print("Start: \(startDate)")
		print("End: \(endDate)")
		print("Steps: \(stepCount)")
		print("Meters: \(meterCount)")
		print("Floors: \(floorCount)")
		print("Duration: \(endDate.timeIntervalSince(startDate))")
		
		if stepCount != 0 || meterCount != 0 || floorCount != 0 {
			FMPersistentDataManager.shared.persistExerciseRecord(startTime: startDate, endTime: endDate, steps: stepCount, meters: meterCount, floors: floorCount)
			if let record = FMPersistentDataManager.shared.cachedRecords().last {
				self.pushController(withName: "FMExerciseReportInterfaceController", context: record)
			}
		}
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
	
	func updateImage(from motionActivity: CMMotionActivity) {
		var isMoving = false
		
		if motionActivity.running {
			isMoving = true
		} else if motionActivity.cycling {
			isMoving = true
		} else if motionActivity.walking {
			isMoving = true
		} else if motionActivity.stationary {
			isMoving = false
		}
		
		if (isMoving != self.wasMoving) {
			isMoving ? animateRun() : animateRelax()
		}
		
		self.wasMoving = isMoving
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
		
		activityManager.startActivityUpdates(to: dataProcessingQueue) {
			data in
			if let activityData: CMMotionActivity = data {
				self.updateImage(from: activityData)
			}
		}
	}
	
	func endMotionUpdates() {
		pedometer.stopUpdates()
		activityManager.stopActivityUpdates()
	}
}
