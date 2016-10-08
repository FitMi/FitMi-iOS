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
	var chartValueArrayStep = [Int]()
	var chartValueArrayDistance = [Int]()
	var chartValueArrayFlights = [Int]()
	var chartDateArrayStep = [Date]()
	var chartDateArrayDistance = [Date]()
	var chartDateArrayFlights = [Date]()
	
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
				FMSpriteStatusManager.sharedManager.refreshSprite {
					print("sprite updated")
					print(FMSpriteStatusManager.sharedManager.sprite)
				}
				
				FMHealthStatusManager.sharedManager.quantity(daysBack: 6, type: .stepCount, completion: {
					error, dates, values in
					if error == nil {
						self.chartValueArrayStep = values
						self.chartDateArrayStep = dates
						DispatchQueue.main.asyncAfter(deadline: .now()) {
							self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
						}
					} else {
						print(error)
					}
				})
				
				
				FMHealthStatusManager.sharedManager.quantity(daysBack: 6, type: .distanceWalkingRunning, completion: {
					error, dates, values in
					if error == nil {
						self.chartValueArrayDistance = values
						self.chartDateArrayDistance = dates
						DispatchQueue.main.asyncAfter(deadline: .now()) {
							self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
						}
					} else {
						print(error)
					}
				})
				
				FMHealthStatusManager.sharedManager.quantity(daysBack: 6, type: .flightsClimbed, completion: {
					error, dates, values in
					if error == nil {
						self.chartValueArrayFlights = values
						self.chartDateArrayFlights = dates
						DispatchQueue.main.asyncAfter(deadline: .now()) {
							self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
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
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FMChartTableViewCell.identifier, for: indexPath) as! FMChartTableViewCell
		cell.selectionStyle = .none
		
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				cell.titleLabel.text = "Steps"
				cell.setChartData(values: self.chartValueArrayStep, dates: self.chartDateArrayStep)
				
			case 1:
				cell.titleLabel.text = "Distance"
				cell.setChartData(values: self.chartValueArrayDistance, dates: self.chartDateArrayDistance)
				
			case 2:
				cell.titleLabel.text = "Flights"
				cell.setChartData(values: self.chartValueArrayFlights, dates: self.chartDateArrayFlights)
				
			default:
				print("unsupported indexpath: \(indexPath)")
			}
		default:
			print("unsupported indexpath: \(indexPath)")
		}
		
		return cell
	}
}
