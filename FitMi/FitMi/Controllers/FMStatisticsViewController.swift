//
//  FMStatisticsViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import Charts


class FMStatisticsViewController: FMViewController {

	private static var defaultController: FMStatisticsViewController?
	
	@IBOutlet var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if FMStatisticsViewController.defaultController == nil {
			FMStatisticsViewController.defaultController = self
		}
		
		self.registerCells()
		self.configureTableView()
	}
	
	private func registerCells() {
		FMChartTableViewCell.registerCell(tableView: self.tableView, reuseIdentifier: FMChartTableViewCell.identifier)
	}
	
	private func configureTableView() {
		self.tableView.estimatedRowHeight = 100
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 100, right: 0)
		self.tableView.backgroundColor = UIColor.secondaryColor
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


extension FMStatisticsViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FMChartTableViewCell.identifier, for: indexPath)
		cell.selectionStyle = .none
		return cell
	}
}
