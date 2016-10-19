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
	fileprivate var skills: List<FMSkill>!
	fileprivate var actions: List<FMAction>!
	
    override func viewDidLoad() {
		let manager = FMDatabaseManager.sharedManager
		self.appearances = manager.appearances()
		self.skills = manager.skills()
		self.actions = manager.actions()
		
		// call super after loading the data
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
		
		self.configureImageView()
		self.configureTableView()
		self.registerCells()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let appearance = FMSpriteStatusManager.sharedManager.spriteAppearance()
		self.setAnimationForAppearance(appearance: appearance)
	}
	
	private func registerCells() {
		FMBoothItemCell.registerCell(tableView: self.tableView, reuseIdentifier: FMBoothItemCell.identifier)
	}

	private func configureTableView() {
		self.tableView.rowHeight = 50
		self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
	}
	
	private func configureImageView() {
		self.primaryImageView.animationDuration = 1
		self.primaryImageView.animationRepeatCount = 3
		
		self.secondaryImageView.animationDuration = 1
		self.secondaryImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
		self.secondaryImageView.animationRepeatCount = 3
	}
	
	fileprivate func selectSegment(at index: Int) {
		for button in segmentButtons {
			button.isSelected = false
		}
		
		segmentButtons[index].isSelected = true
		self.currentSelectedSegmentIndex = index
	}
	
	fileprivate func setAnimationForSkill(skill: FMSkill) {
		self.primaryImageView.stopAnimating()
		self.secondaryImageView.stopAnimating()
		
		let attackImages = skill.attackSprites()
		self.primaryImageView.image = attackImages.last
		self.primaryImageView.animationImages = attackImages
		
		
		let defenceImages = skill.defenceSprites()
		self.secondaryImageView.image = defenceImages.last
		self.secondaryImageView.animationImages = defenceImages
		
		self.primaryImageView.startAnimating()
		self.secondaryImageView.startAnimating()
	}
	
	fileprivate func setAnimationForAction(action: FMAction) {
		self.primaryImageView.stopAnimating()
		self.secondaryImageView.stopAnimating()
		
		let images = action.sprites()
		self.primaryImageView.animationImages = images
		self.primaryImageView.image = images.last
		
		self.secondaryImageView.image = nil
		
		self.primaryImageView.startAnimating()
	}
	
	fileprivate func setAnimationForAppearance(appearance: FMAppearance) {
		if let action = appearance.actions.filter("name = %@", "Run Default").first {
			self.setAnimationForAction(action: action)
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func segmentDidTap(_ sender: UIButton) {
		self.selectSegment(at: sender.tag)
		self.primaryImageView.stopAnimating()
		self.secondaryImageView.stopAnimating()
		self.primaryImageView.image = nil
		self.secondaryImageView.image = nil
		self.tableView.reloadData()
	}
    

	class func controllerFromStoryboard() -> FMBoothViewController {
		let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "FMBoothViewController") as! FMBoothViewController
		controller.modalTransitionStyle = .coverVertical
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
		switch self.currentSelectedSegmentIndex {
		case 0:
			return self.appearances.count
			
		case 1:
			return self.skills.count
			
		case 2:
			return self.actions.count
			
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FMBoothItemCell.identifier, for: indexPath) as! FMBoothItemCell
		
		switch self.currentSelectedSegmentIndex {
		case 0:
			let appearance = self.appearances[indexPath.row]
			cell.titleLabel.text = appearance.name
			
		case 1:
			let skill = self.skills[indexPath.row]
			cell.titleLabel.text = skill.name
			
		case 2:
			let action = self.actions[indexPath.row]
			cell.titleLabel.text = action.name
			
		default:
			print("unsupported index")
		}

		return cell
	}
}

extension FMBoothViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		switch self.currentSelectedSegmentIndex {
			
		case 0:
			let appearance = self.appearances[indexPath.row]
			self.setAnimationForAppearance(appearance: appearance)
			
		case 1:
			let skill = self.skills[indexPath.row]
			self.setAnimationForSkill(skill: skill)
			
		case 2:
			let action = self.actions[indexPath.row]
			self.setAnimationForAction(action: action)
			
		default:
			print("unsupported indexpath")
		}
	}
}
