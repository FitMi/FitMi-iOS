//
//  FMLevelViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 5/11/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMLevelViewController: FMViewController {
	
	@IBOutlet var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureTableView()
	}
	
	func registerCells() {
		FMLevelCell.registerCell(tableView: tableView, reuseIdentifier: FMLevelCell.identifier)
	}
	
	func configureTableView() {
		tableView.rowHeight = 40
		registerCells()
	}

	@IBAction func headerButtonDidClick(sender: UIButton) {
		let manager = FMNotificationManager.sharedManager
		switch sender.tag {
		case 0:
			manager.showStandardFeedbackMessage(text: "the level index")
			
		case 1:
			manager.showStandardFeedbackMessage(text: "the number of skill slots you have in battle")
			
		case 2:
			manager.showStandardFeedbackMessage(text: "the upper limit for your Mi's health")
			
		case 3:
			manager.showStandardFeedbackMessage(text: "the experience required for level up")
			
		default:
			print("unsupported tag")
		}
	}
	
}

extension FMLevelViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1000
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FMLevelCell.identifier, for: indexPath) as! FMLevelCell
		
		let manager = FMSpriteLevelManager.sharedManager
		let level = indexPath.row
		
		cell.levelLabel.text = "\(level)"
		cell.skillsLabel.text = "\(manager.skillSlotCountForLevel(level: level))"
		cell.healthLabel.text = "\(manager.healthLimitForLevel(level: level))"
		cell.expLabel.text = "\(manager.experienceLimitForLevel(level: level))"
		
		return cell
	}
}
