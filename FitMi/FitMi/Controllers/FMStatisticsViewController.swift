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
	var chartValueArrayHealth = [Int]()
	var chartValueArrayStrength = [Int]()
	var chartValueArrayStamina = [Int]()
	var chartValueArrayAgility = [Int]()
	var chartDateArray = [Date]()
	
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
				FMSpriteStatusManager.sharedManager.refreshSprite {success in
					DispatchQueue.main.async {
						if (success) {
							let sprite = FMSpriteStatusManager.sharedManager.sprite!
							let states = sprite.states.sorted(byProperty: "date", ascending: false)
							for i in 0..<min(states.count, 7) {
								self.chartDateArray.append(states[i].date)
								self.chartValueArrayHealth.append(states[i].health)
								self.chartValueArrayStrength.append(states[i].strength)
								self.chartValueArrayStamina.append(states[i].stamina)
								self.chartValueArrayAgility.append(states[i].agility)
							}
							
							self.tableView.reloadData()
						} else {
							print("sprite not updated")
						}
					}
				}
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
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FMChartTableViewCell.identifier, for: indexPath) as! FMChartTableViewCell
		cell.selectionStyle = .none
		
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				cell.titleLabel.text = "Health".uppercased()
				cell.setChartData(values: self.chartValueArrayHealth, dates: self.chartDateArray)
				
			case 1:
				cell.titleLabel.text = "Strength".uppercased()
				cell.setChartData(values: self.chartValueArrayStrength, dates: self.chartDateArray)
				
			case 2:
				cell.titleLabel.text = "Stamina".uppercased()
				cell.setChartData(values: self.chartValueArrayStamina, dates: self.chartDateArray)
				
			case 3:
				cell.titleLabel.text = "Agility".uppercased()
				cell.setChartData(values: self.chartValueArrayAgility, dates: self.chartDateArray)
				
			default:
				print("unsupported indexpath: \(indexPath)")
			}
		default:
			print("unsupported indexpath: \(indexPath)")
		}
		
		return cell
	}
}
