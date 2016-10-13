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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.configureTableView()
	}
	
	private func configureTableView() {
		self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
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
