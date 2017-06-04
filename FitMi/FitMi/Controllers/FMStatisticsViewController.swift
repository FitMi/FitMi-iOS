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
	var states = [FMSpriteState?]()
	
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
		FMMiddleAlignedLabelCell.registerCell(tableView: self.tableView, reuseIdentifier: FMMiddleAlignedLabelCell.identifier)
	}
	
	private func configureTableView() {
		self.tableView.estimatedRowHeight = 100
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 88, right: 0)
		self.tableView.backgroundColor = UIColor.secondaryColor
		
		self.tableView.delaysContentTouches = false
		
		for case let x as UIScrollView in self.tableView.subviews {
			x.delaysContentTouches = false
		}
		
		let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
		headerLabel.font = UIFont(name: "Pixeled", size: 20)
		headerLabel.text = "STATISTICS"
		headerLabel.textAlignment = .center
		self.tableView.tableHeaderView = headerLabel
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		FMHealthStatusManager.sharedManager.authorizeHealthKit {
			(authorized,  error) -> Void in
			if authorized {
				self.refreshSprite()
			} else {
				print("HealthKit authorization denied!")
				if error != nil {
					print(String(describing: error))
				}
			}
		}
	}
	
	private func refreshSprite() {
		FMSpriteStatusManager.sharedManager.refreshSprite {success in
			DispatchQueue.main.async {
				if (success) {
					let sprite = FMSpriteStatusManager.sharedManager.sprite!
					let states = sprite.states.sorted(byProperty: "date", ascending: false)
					self.states = []
					for i in 0..<7 {
						self.states.append(i < states.count ? states[i] : nil)
					}
					self.states.reverse()
					
					self.tableView.reloadData()
				} else {
					print("sprite not updated")
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
	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		self.refreshSprite()
	}
	
	override func didMove(toParentViewController parent: UIViewController?) {
		super.didMove(toParentViewController: parent)
	}
}


extension FMStatisticsViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 3
			
		case 1:
			return 2
			
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var defaultCell: UITableViewCell!
		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: FMChartTableViewCell.identifier, for: indexPath) as! FMChartTableViewCell
			cell.selectionStyle = .none
			switch indexPath.row {
//			case 0:
//				cell.titleLabel.text = "Health".uppercased()
//				cell.setChartData(states: self.states, type: .health)
				
			case 0:
				cell.titleLabel.text = "steps".uppercased()
				cell.setChartData(states: self.states, type: .steps)
				
			case 1:
				cell.titleLabel.text = "meters".uppercased()
				cell.setChartData(states: self.states, type: .distance)
				
			case 2:
				cell.titleLabel.text = "floors".uppercased()
				cell.setChartData(states: self.states, type: .flights)
				
			default:
				print("unsupported indexpath: \(indexPath)")
			}
			
			defaultCell = cell
			
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: FMMiddleAlignedLabelCell.identifier, for: indexPath) as! FMMiddleAlignedLabelCell
			cell.selectionStyle = .none
			
			switch indexPath.row {
			case 0:
				cell.label.text = "ALL HISTORY"
			case 1:
				cell.label.text = "IN-APP WORKOUTS"
			default:
				print("unsupported indexpath: \(indexPath)")
			}
			defaultCell = cell
			
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: FMMiddleAlignedLabelCell.identifier, for: indexPath) as! FMMiddleAlignedLabelCell
			cell.selectionStyle = .none
			defaultCell = cell
		}
		
		return defaultCell
	}
}

extension FMStatisticsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 1:
			switch indexPath.row {
			case 0:
				let controller = FMStatisticsDetailViewController.controllerFromStoryboard()
				UIApplication.shared.keyWindow!.rootViewController!.present(controller, animated: true, completion: {
					
				})
			case 1:
				let controller = FMWorkoutHistoryViewController.getDefaultController()
				UIApplication.shared.keyWindow!.rootViewController!.present(controller, animated: true, completion: {
					
				})
				
			default:
				print(indexPath)
			}
			
		default:
			print(indexPath)
		}
	}
}
