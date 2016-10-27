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
				let date = Date(timeIntervalSince1970: TimeInterval(record[WatchPersistentDataKey.startTime.rawValue]!)!)
				row.titleLabel.setText(dateFormatter.string(from: date))
			}
		}
	}
	
	override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
		self.pushController(withName: "FMExerciseReportInterfaceController", context: records[rowIndex])
	}
	
	@IBAction func syncData() {
		FMPersistentDataManager.shared.pushRecordToHostDevice(completion: {
			success in
			if success {
				self.records = FMPersistentDataManager.shared.cachedRecords()
				self.table.setNumberOfRows(self.records.count, withRowType: "FMExerciseRecordRowController")
				let action = WKAlertAction(title: "OK", style: .cancel, handler: { _ in })
				self.presentAlert(withTitle: "Sync Succeeded", message: "\nTransferred records will be cleared. Go to FitMi/Statistics on iPhone to view them.", preferredStyle: .alert, actions: [action])
			} else {
				let cancel = WKAlertAction(title: "OK", style: .cancel, handler: { _ in })
				self.presentAlert(withTitle: "Sync Failed", message: "\nMake sure your watch is connected with your iPhone and try again.", preferredStyle: .alert, actions: [cancel])
			}
		})
	}
}
