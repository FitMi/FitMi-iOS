//
//  FMRecordListInterfaceController.swift
//  FitMi
//
//  Created by Jinghan Wang on 27/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import WatchKit

class FMRecordListInterfaceController: WKInterfaceController {
	@IBOutlet var table: WKInterfaceTable!
	
	fileprivate var records = [[String: String]]()
	
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		self.loadTable()
	}
	
	func loadTable() {
		records = FMPersistentDataManager.shared.cachedRecords()
		
		table.setNumberOfRows(records.count, withRowType: "FMExerciseRecordRowController")
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "M-d, HH:mm"
		
		for (index, record) in records.enumerated() {
			if let row = table.rowController(at: index) as? FMExerciseRecordRowController {
				let date = Date(timeIntervalSince1970: TimeInterval(record[PersistentDataKey.startTime.rawValue]!)!)
				row.titleLabel.setText(dateFormatter.string(from: date))
			}
		}
	}
	
	override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
		self.pushController(withName: "FMExerciseReportInterfaceController", context: records[rowIndex])
	}
	
	@IBAction func syncData() {
		FMPersistentDataManager.shared.pushRecordToHostDevice()
	}
}
