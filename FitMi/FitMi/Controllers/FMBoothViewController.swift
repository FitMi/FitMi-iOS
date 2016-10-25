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
	
	@IBOutlet var damageButton: UIButton!
	@IBOutlet var healingButton: UIButton!
	@IBOutlet var speedButton: UIButton!
	@IBOutlet var descriptionLabel: UILabel!
	
	fileprivate var appearances: Results<FMAppearance>!
	fileprivate var skills: List<FMSkill>!
	fileprivate var actions: List<FMAction>!
	
	fileprivate var selectedIndexPath: IndexPath?
	
    override func viewDidLoad() {
		let manager = FMDatabaseManager.sharedManager
		
		manager.refreshMySkills()
		
		self.appearances = manager.appearances()
		self.skills = manager.skills()
		self.actions = manager.actions()
		
		// call super after loading the data
        super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(didReceiveInUseNotification(notification:)), name: NSNotification.Name(rawValue: "BOOTH_BUTTON_DID_CLICK_NOTIFICATION"), object: nil)
		
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
		
        self.segmentDidTap(self.segmentButton0)
		
		self.configureImageView()
		self.configureTableView()
		self.registerCells()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	func didReceiveInUseNotification(notification: Notification) {
		if let object = notification.object {
			let isTitleUsing = notification.userInfo!["USING"] as! Bool
			let button = notification.userInfo!["BUTTON"] as! UIButton
			if let skill = object as? FMSkill {
				self.setAnimationForSkill(skill: skill)
				let sprite = FMSpriteStatusManager.sharedManager.sprite!
				if isTitleUsing {
					if sprite.skillsInUse.count > 1 {
						FMSpriteStatusManager.sharedManager.unuseSkill(skill: skill)
						self.reloadTableView(sender: button)
					} else {
						FMNotificationManager.sharedManager.showStandardFeedbackMessage(text: "At least one skill should be used...")
					}
				} else {
					if sprite.skillSlotCount > sprite.skillsInUse.count {
						FMSpriteStatusManager.sharedManager.useSkill(skill: skill)
						self.reloadTableView(sender: button)
					} else {
						print("Too many skills")
					}
				}
			} else if let action = object as? FMAction {
				self.setAnimationForAction(action: action)
				if !isTitleUsing {
					FMSpriteStatusManager.sharedManager.updateAction(action: action)
				} else {
					FMNotificationManager.sharedManager.showStandardFeedbackMessage(text: "At least one action should be used...")
				}
			} else if let appearance = object as? FMAppearance {
				self.setAnimationForAppearance(appearance: appearance)
				if !isTitleUsing {
					FMSpriteStatusManager.sharedManager.updateAppearance(appearance: appearance)
				} else {
					FMNotificationManager.sharedManager.showStandardFeedbackMessage(text: "At least one appearance should be used...")
				}
			}
		}
	}
	
	private func registerCells() {
		FMBoothItemCell.registerCell(tableView: self.tableView, reuseIdentifier: FMBoothItemCell.identifier)
	}

	private func configureTableView() {
		self.tableView.rowHeight = 50
		self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
		self.tableView.delaysContentTouches = false
		
		for case let x as UIScrollView in self.tableView.subviews {
			x.delaysContentTouches = false
		}
	}
	
	private func configureImageView() {
		self.primaryImageView.animationDuration = 1
		self.primaryImageView.animationRepeatCount = 3
		
		self.secondaryImageView.animationDuration = 1
		self.secondaryImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
		self.secondaryImageView.animationRepeatCount = 3
	}
	
	fileprivate func selectSegment(at index: Int) {
		self.damageButton.superview!.isHidden = index != 1
		self.descriptionLabel.text = ""
		
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
		if let action = appearance.actions.filter("name = %@", "Basic Run").first {
			self.setAnimationForAction(action: action)
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func segmentDidTap(_ sender: UIButton) {
		self.selectSegment(at: sender.tag)
		self.clearImageView()
		self.tableView.reloadData()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.005, execute: {
			let indexPath = IndexPath(row:0, section: 0)
			self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
			self.tableView(self.tableView, didSelectRowAt: indexPath)
		})
	}
	
	func reloadTableView(sender: UIButton) {
		sender.setTitle("WAIT", for: .disabled)
		sender.isEnabled = false
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
			self.tableView.reloadData()
		})
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
	
	@IBAction func postCaption(sender: UIButton) {
		var text = ""
		var title = ""
		
		switch sender.tag {
		case 0:
			title = "Skill Damage"
			text = "[skill damage] * [strength] determines the final damage"
			
		case 1:
			title = "Skill Healing"
			text = "[skill healing] * [stamina] determines the final healing. A negative value means the skill hurts both the enemy and yourself at the same time."
			
		case 2:
			title = "Skill Speed"
			text = "[skill speed] * [agility] determines the cool down for next move"
			
		default:
			print("N.A.")
		}
		
		let controller = UIAlertController(title: title, message: text, preferredStyle: .actionSheet)
		controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		self.present(controller, animated: true, completion: nil)
	}
	
	fileprivate func clearImageView() {
		self.primaryImageView.stopAnimating()
		self.secondaryImageView.stopAnimating()
		self.primaryImageView.image = nil
		self.secondaryImageView.image = nil
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
		cell.button.isHidden = false
		cell.button.isEnabled = true
		cell.iconImageView.isHidden = true
		cell.selectionStyle = .none
		cell.contentView.alpha = 1
		let sprite = FMSpriteStatusManager.sharedManager.sprite!
		
		switch self.currentSelectedSegmentIndex {
		case 0:
			let appearance = self.appearances[indexPath.row]
			cell.titleLabel.text = appearance.name
			let inUse = appearance.identifier == FMSpriteStatusManager.sharedManager.spriteAppearance().identifier
			cell.setButtonState(inUse: inUse)
			cell.object = appearance
			
		case 1:
			let skill = self.skills[indexPath.row]
			cell.iconImageView.isHidden = false
			cell.iconImageView.image = skill.icon()
			cell.object = skill
			if sprite.skills.contains(skill) {
				cell.titleLabel.text = skill.name
				let inUse = sprite.skillsInUse.contains(skill)
				cell.setButtonState(inUse: inUse)
				if !inUse && sprite.skillsInUse.count >= sprite.skillSlotCount {
					cell.button.isEnabled = false
				}
			} else {
				cell.contentView.alpha = 0.3
				cell.titleLabel.text = "\(skill.name)   ( require level \(skill.unlockLevel) )"
				cell.button.isHidden = true
			}
			
		case 2:
			let action = self.actions[indexPath.row]
			cell.object = action
			if sprite.actions.contains(action) {
				cell.titleLabel.text = action.name
				let inUse = sprite.relaxAction.identifier == action.identifier ||
							sprite.wakeAction.identifier == action.identifier ||
							sprite.sleepAction.identifier == action.identifier ||
							sprite.tiredAction.identifier == action.identifier ||
							sprite.touchAction.identifier == action.identifier ||
							sprite.runAction.identifier == action.identifier
				cell.setButtonState(inUse: inUse)
				
			} else {
				cell.contentView.alpha = 0.3
				cell.titleLabel.text = "\(action.name)   ( require level \(action.unlockLevel) )"
				cell.button.isHidden = true
			}
			
		default:
			print("unsupported index")
		}

		return cell
	}
}

extension FMBoothViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath == self.selectedIndexPath {
			cell.setSelected(true, animated: false)
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		self.selectedIndexPath = indexPath
		
		switch self.currentSelectedSegmentIndex {
			
		case 0:
			let appearance = self.appearances[indexPath.row]
			self.setAnimationForAppearance(appearance: appearance)
			self.descriptionLabel.text = appearance.descriptionText
		case 1:
			let skill = self.skills[indexPath.row]
			let sprite = FMSpriteStatusManager.sharedManager.sprite!
			if sprite.skills.contains(skill) {
				self.setAnimationForSkill(skill: skill)
				self.descriptionLabel.text = skill.descriptionText
				self.damageButton.setTitle("DAMAGE: \(skill.strengthFactor)", for: .normal)
				self.healingButton.setTitle("HEALING: \(skill.staminaFactor)", for: .normal)
				self.speedButton.setTitle("SPEED: \(skill.agilityFactor)", for: .normal)
			} else {
//				self.clearImageView()
			}
			
		case 2:
			let action = self.actions[indexPath.row]
			let sprite = FMSpriteStatusManager.sharedManager.sprite!
			if sprite.actions.contains(action) {
				self.descriptionLabel.text = action.descriptionText
				self.setAnimationForAction(action: action)
			} else {
//				self.clearImageView()
			}
			
		default:
			print("unsupported indexpath")
		}
	}
}
