//
//  FMStatisticsDetailViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 13/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMStatisticsDetailViewController: FMViewController {
	
	@IBOutlet var tableView: UITableView!
	var refreshControl: UIRefreshControl!
	fileprivate var numberOfStates = 14
	fileprivate var sprite = FMSpriteStatusManager.sharedManager.sprite!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.configureTableView()
		self.registerCells()
	}
	
	private func configureTableView() {
		self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
		self.refreshControl = UIRefreshControl()
		self.tableView.addSubview(self.refreshControl)
		self.refreshControl.addTarget(self, action: #selector(tableDidRefreshed), for: .valueChanged)
	}
	
	func tableDidRefreshed() {
		let newNumberOfStates = numberOfStates + 7
		numberOfStates = min(sprite.states.count, newNumberOfStates)
		Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refresh), userInfo: nil, repeats: false)
	}
	
	func refresh() {
		self.refreshControl.endRefreshing()
		self.tableView.reloadSections([0], with: .automatic)
	}	
	private func registerCells() {
		FMStatsDetailCell.registerCell(tableView: self.tableView, reuseIdentifier: FMStatsDetailCell.identifier)
	}
	
	@IBAction func dismiss() {
		self.dismiss(animated: true, completion: nil)
	}
	
	class func controllerFromStoryboard() -> FMStatisticsDetailViewController {
		let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "FMStatisticsDetailViewController") as! FMStatisticsDetailViewController
		
		return controller
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}

extension FMStatisticsDetailViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return self.numberOfStates
		default:
			return 1
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: FMStatsDetailCell.identifier, for: indexPath)
			cell.selectionStyle = .none
			let index = self.sprite.states.count - (self.numberOfStates - indexPath.row)
			cell.textLabel?.text = "\(self.sprite.states[index].date)"
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: FMStatsDetailCell.identifier, for: indexPath)
			cell.selectionStyle = .none
			return cell
		}
	}
}

