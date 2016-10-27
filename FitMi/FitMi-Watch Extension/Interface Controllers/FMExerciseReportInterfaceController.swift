//
//  FMExerciseReportInterfaceController.swift
//  FitMi
//
//  Created by Jinghan Wang on 27/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import WatchKit

class FMExerciseReportInterfaceController: WKInterfaceController {
	@IBOutlet var stepLabel: WKInterfaceLabel!
	@IBOutlet var meterLabel: WKInterfaceLabel!
	@IBOutlet var floorLabel: WKInterfaceLabel!
	@IBOutlet var startDateLabel: WKInterfaceLabel!
	@IBOutlet var endDateLabel: WKInterfaceLabel!
	@IBOutlet var durationLabel: WKInterfaceLabel!
	
	override func awake(withContext context: Any?) {
		super.awake(withContext: nil)
		self.loadData(record: context as! [String: String])
	}
	
	fileprivate func loadData(record: [String: String]) {
		stepLabel.setText(record[WatchPersistentDataKey.steps.rawValue])
		meterLabel.setText(record[WatchPersistentDataKey.meters.rawValue])
		floorLabel.setText(record[WatchPersistentDataKey.floors.rawValue])
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "M-d, HH:mm"
		let startTimeStamp = record[WatchPersistentDataKey.startTime.rawValue]!
		let startDate = Date(timeIntervalSince1970: TimeInterval(startTimeStamp)!)
		startDateLabel.setText(dateFormatter.string(from: startDate))
		
		let endTimeStamp = record[WatchPersistentDataKey.endTime.rawValue]!
		let endDate = Date(timeIntervalSince1970: TimeInterval(endTimeStamp)!)
		endDateLabel.setText(dateFormatter.string(from: endDate))
		
		var seconds = Int(endDate.timeIntervalSince(startDate))
		let minutes = seconds / 60
		seconds = seconds % 60
		durationLabel.setText("\(minutes):\(seconds)")
	}
}
