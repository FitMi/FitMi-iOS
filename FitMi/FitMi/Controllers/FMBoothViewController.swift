//
//  FMBoothViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 18/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import RealmSwift

class FMBoothViewController: FMViewController {

	@IBOutlet var primaryImageView: UIImageView!
	@IBOutlet var secondaryImageView: UIImageView!
	
	@IBOutlet var tableView: UITableView!
	
	fileprivate var segmentButtons: [UIButton] = []
	@IBOutlet var segmentButton0: UIButton!
	@IBOutlet var segmentButton1: UIButton!
	@IBOutlet var segmentButton2: UIButton!
	fileprivate var currentSelectedSegmentIndex = 0
	
	fileprivate var appearances: Results<FMAppearance>!
	fileprivate var skills: Results<FMSkill>!
	fileprivate var actions: Results<FMAction>!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let highlightedImage = UIImage.fromColor(color: UIColor.darkGray)
		let selectedImage = UIImage.fromColor(color: UIColor.gray)
		let normalImage = UIImage.fromColor(color: UIColor.lightGray)
		
		segmentButtons = [self.segmentButton0, self.segmentButton1, self.segmentButton2]
		
		for (index, button) in segmentButtons.enumerated() {
			button.setBackgroundImage(normalImage, for: .normal)
			button.setBackgroundImage(highlightedImage, for: .highlighted)
			button.setBackgroundImage(selectedImage, for: .selected)
			button.tag = index
		}
		
        self.selectSegment(at: 0)
		
		self.configureTableView()
		self.registerCells()
    }
	
	private func registerCells() {
		FMLabelCell.registerCell(tableView: self.tableView, reuseIdentifier: FMLabelCell.identifier)
	}

	private func configureTableView() {
		self.tableView.estimatedRowHeight = 100
		self.tableView.rowHeight = UITableViewAutomaticDimension
	}
	
	fileprivate func selectSegment(at index: Int) {
		for button in segmentButtons {
			button.isSelected = false
		}
		
		segmentButtons[index].isSelected = true
		self.currentSelectedSegmentIndex = index
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func segmentDidTap(_ sender: UIButton) {
		self.selectSegment(at: sender.tag)
		self.tableView.reloadData()
	}
    

	class func controllerFromStoryboard() -> FMBoothViewController {
		let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "FMBoothViewController") as! FMBoothViewController
		controller.modalTransitionStyle = .crossDissolve
		return controller
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
}

extension FMBoothViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let manager = FMDatabaseManager.sharedManager
		switch self.currentSelectedSegmentIndex {
		case 0:
			self.appearances = manager.appearances()
			return self.appearances.count
			
		case 1:
			self.skills = manager.skills()
			return self.skills.count
			
		case 2:
			self.actions = manager.actions()
			return self.actions.count
			
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FMLabelCell.identifier, for: indexPath) as! FMLabelCell
		
		switch self.currentSelectedSegmentIndex {
		case 0:
			let appearance = self.appearances[indexPath.row]
			cell.titleLabel.text = appearance.name
			cell.contentLabel.text = ""
			
		case 1:
			let skill = self.skills[indexPath.row]
			cell.titleLabel.text = skill.name
			cell.contentLabel.text = ""
			
		case 2:
			let action = self.actions[indexPath.row]
			cell.titleLabel.text = action.name
			cell.contentLabel.text = ""
			
		default:
			print("unsupported index")
		}

		return cell
	}
}

extension FMBoothViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
