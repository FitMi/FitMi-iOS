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
		self.loadData()
	}
	
	fileprivate func loadData() {
		if let record = FMPersistentDataManager.shared.cachedRecords().last {
			stepLabel.setText(record[PersistentDataKey.steps.rawValue])
			meterLabel.setText(record[PersistentDataKey.meters.rawValue])
			floorLabel.setText(record[PersistentDataKey.floors.rawValue])
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "M-d, hh:mm"
			let startTimeStamp = record[PersistentDataKey.startTime.rawValue]!
			let startDate = Date(timeIntervalSince1970: TimeInterval(startTimeStamp)!)
			startDateLabel.setText(dateFormatter.string(from: startDate))
			
			let endTimeStamp = record[PersistentDataKey.endTime.rawValue]!
			let endDate = Date(timeIntervalSince1970: TimeInterval(endTimeStamp)!)
			endDateLabel.setText(dateFormatter.string(from: endDate))
			
			var seconds = Int(endDate.timeIntervalSince(startDate))
			let minutes = seconds / 60
			seconds = seconds % 60
			durationLabel.setText("\(minutes):\(seconds)")
		}
	}
}
