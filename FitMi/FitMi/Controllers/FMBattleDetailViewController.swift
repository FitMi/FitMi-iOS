//
//  FMBattleDetailViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 21/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class FMBattleDetailViewController: FMViewController {

	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var escapeButton: UIButton!
	@IBOutlet var battleView: UIView!
	
	@IBOutlet var primaryImageView: UIImageView!
	@IBOutlet var secondaryImageView: UIImageView!
	
	
	@IBOutlet var opponentAvatarImageView: UIImageView!
	@IBOutlet var opponentNameLabel: UILabel!
	@IBOutlet var opponentHealthBar: UIProgressView!
	@IBOutlet var opponentTimeBar: UIProgressView!
	fileprivate var opponentHealthMax: Int = 0
	fileprivate var opponentHealth: Int = 0
	
	@IBOutlet var selfAvatarImageView: UIImageView!
	@IBOutlet var selfNameLabel: UILabel!
	@IBOutlet var selfHealthBar: UIProgressView!
	@IBOutlet var selfTimeBar: UIProgressView!
	fileprivate var selfHealthMax: Int = 0
	fileprivate var selfHealth: Int = 0
	
	@IBOutlet var skillButton0: UIButton!
	@IBOutlet var skillButton1: UIButton!
	@IBOutlet var skillButton2: UIButton!
	
	fileprivate var moves: [[String: String]]!
	
	var opponentID = ""
	var opponentSkills: [FMSkill]!
	var selfSkills: [FMSkill]!
	
	fileprivate var opponentData: JSON!
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.battleView.alpha = 0
		self.configureImageView()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.loadOpponentData(completion: {
			data in
			if let json = data {
				self.opponentData = json
				self.refreshView()
				self.activityIndicator.stopAnimating()
				self.battleView.isUserInteractionEnabled = true
				UIView.animate(withDuration: 0.5, animations: {
					self.battleView.alpha = 1
				})
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
					self.strikeWithSkill(skill: self.getOpponentSkills().first!, fromSelf: true)
				})
				
				Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.friendAttack), userInfo: nil, repeats: true)
			}
		})
	}
	
	private func configureImageView() {
		self.primaryImageView.animationDuration = 1
		self.primaryImageView.animationRepeatCount = 3
		
		self.secondaryImageView.animationDuration = 1
		self.secondaryImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
		self.secondaryImageView.animationRepeatCount = 3
	}
	
	@IBAction func skillButtonDidClick(sender: UIButton) {
		let skill = self.selfSkills[sender.tag]
		self.strikeWithSkill(skill: skill, fromSelf: true)
	}
	
	func friendAttack() {
		if self.opponentSkills != nil {
			let rand = Int(arc4random()) % self.opponentSkills.count
			let skill = self.opponentSkills[rand]
			self.strikeWithSkill(skill: skill, fromSelf: false)
		}
	}
	
	fileprivate func loadOpponentData(completion: @escaping ((_ data: JSON?) -> Void)) {
		FMNetworkManager.sharedManager.getUser(userFbId: self.opponentID, completion: {
			error, data in
			completion(data)
		})
	}
	
	fileprivate func refreshView() {
		self.selfSkills = self.getSelfSkills()
		self.selfNameLabel.text = self.getSelfName()
		self.selfHealthMax = self.getSelfHealth()
		self.selfHealth = self.getSelfHealth()
		self.selfHealthBar.setProgress(1, animated: false)
		self.selfAvatarImageView.af_setImage(withURL: URL(string: "http://graph.facebook.com/\(self.getSelfFacebookId())/picture?type=large")!)
		
		self.opponentSkills = self.getOpponentSkills()
		self.opponentNameLabel.text = self.getOpponentName()
		self.opponentHealthMax = self.getOpponentHealth()
		self.opponentHealth = self.getOpponentHealth()
		self.opponentHealthBar.setProgress(1, animated: false)
		self.opponentAvatarImageView.af_setImage(withURL: URL(string: "http://graph.facebook.com/\(self.getOpponentFacebookId())/picture?type=large")!)
		
		
		let array = [self.skillButton0, self.skillButton1, self.skillButton2]
		for i in 0..<3 {
			array[i]?.isHidden = !(i < self.selfSkills.count)
		}
	}
	
	// Move constructor
	// nextResumeTime in ms
	fileprivate func constructMove(attackUserIsSelf: Bool, damage: Int, healing: Int, nextResumeTime: Int) -> [String: String] {
		var thisMove = [String: String]()
		thisMove["damage"] = "\(damage)"
		thisMove["healing"] = "\(healing)"
		thisMove["damage"] = "\(damage)"
		thisMove["nextResumeTime"] = "\(nextResumeTime)"
		
		if attackUserIsSelf {
			thisMove["attackUser"] = self.getSelfFacebookId()
			thisMove["defenceUser"] = self.getOpponentFacebookId()
		} else {
			thisMove["attackUser"] = self.getOpponentFacebookId()
			thisMove["defenceUser"] = self.getSelfFacebookId()
		}
		return thisMove
	}
	
	fileprivate func strikeWithSkill(skill: FMSkill, fromSelf: Bool) {
		let strength = fromSelf ? self.getSelfStrength() : self.getOpponentStrength()
		let stamina = fromSelf ? self.getSelfStamina() : self.getOpponentStamina()
		let agility = fromSelf ? self.getSelfAgility() : self.getOpponentAgility()
		
		let damage = self.getDamage(strength: strength, skill: skill)
		let healing = self.getHealing(stamina: stamina, skill: skill)
		let timeToResume = self.getTimeResume(agility: agility, skill: skill)
		
		let thisMove = self.constructMove(attackUserIsSelf: fromSelf, damage: damage, healing: healing, nextResumeTime: timeToResume)
		
		if fromSelf {
			let newHealth = self.selfHealth + healing
			self.selfHealth = min(newHealth, self.selfHealthMax)
			let selfProgress = Float(self.selfHealth) / Float(self.selfHealthMax)
			self.selfHealthBar.setProgress(selfProgress, animated: true)
			
			
			let newOpponentHealth = self.opponentHealth - damage
			self.opponentHealth = max(newOpponentHealth, 0)
			let opponentProgress = Float(self.opponentHealth) / Float(self.opponentHealthMax)
			self.opponentHealthBar.setProgress(opponentProgress, animated: true)
		} else {
			let newOpponentHealth = self.opponentHealth + healing
			self.opponentHealth = min(newOpponentHealth, self.opponentHealthMax)
			let opponentProgress = Float(self.opponentHealth) / Float(self.opponentHealthMax)
			self.opponentHealthBar.setProgress(opponentProgress, animated: true)
			
			
			let newHealth = self.selfHealth - damage
			self.selfHealth = max(newHealth, 0)
			let selfProgress = Float(self.selfHealth) / Float(self.selfHealthMax)
			self.selfHealthBar.setProgress(selfProgress, animated: true)
		}
		
		print(thisMove)
	}
	
	// Damage, Healing, RandomTime Calculator
	fileprivate func getDamage(strength: Int, skill: FMSkill) -> Int {
		let rand = Double(arc4random() % 100) / 100
		let damage = Double(strength) * (1 + 0.1 * rand) * skill.strengthFactor / 10
		return Int(damage)
	}
	
	fileprivate func getHealing(stamina: Int, skill: FMSkill) -> Int {
		let rand = Double(arc4random() % 100) / 100
		let healing = Double(stamina) * (1 + 0.1 * rand) * skill.staminaFactor / 10
		return Int(healing)
	}
	
	fileprivate func getTimeResume(agility: Int, skill: FMSkill) -> Int {
		let rand = Double(arc4random() % 100) / 100
		let time = Double(agility) * (1 + 0.1 * rand) * skill.agilityFactor / 10
		return Int(time)
	}
	
	// Self accessors
	fileprivate func getSelfName() -> String {
		return FMSpriteStatusManager.sharedManager.sprite.userFacebookName
	}
	
	fileprivate func getSelfHealth() -> Int {
		return FMSpriteStatusManager.sharedManager.currentHP()
	}
	
	fileprivate func getSelfStamina() -> Int {
		return FMSpriteStatusManager.sharedManager.currentStamina()
	}
	
	fileprivate func getSelfStrength() -> Int {
		return FMSpriteStatusManager.sharedManager.currentStrength()
	}
	
	fileprivate func getSelfAgility() -> Int {
		return FMSpriteStatusManager.sharedManager.currentAgility()
	}
	
	fileprivate func getSelfFacebookId() -> String {
		return FMSpriteStatusManager.sharedManager.sprite.userFacebookID
	}
	
	fileprivate func getSelfSkills() -> [FMSkill] {
		let skills = FMSpriteStatusManager.sharedManager.sprite.skills
		var skillArray = [FMSkill]()
		for skill in skills {
			skillArray.append(skill)
		}
		return skillArray
	}
	
	
	// JSON accessors
	
	fileprivate func getOpponentName() -> String {
		return self.opponentData["username"].string!
	}
	
	fileprivate func getOpponentHealth() -> Int {
		return self.opponentData["health"].int!
	}
	
	fileprivate func getOpponentStamina() -> Int {
		return self.opponentData["stamina"].int!
	}
	
	fileprivate func getOpponentStrength() -> Int {
		return self.opponentData["strength"].int!
	}
	
	fileprivate func getOpponentAgility() -> Int {
		return self.opponentData["agility"].int!
	}
	
	fileprivate func getOpponentFacebookId() -> String {
		return self.opponentData["facebookId"].string!
	}
	
	fileprivate func getOpponentSkills() -> [FMSkill] {
		if self.opponentSkills != nil {
			return self.opponentSkills
		}
		
		var array = [FMSkill]()
		
		for idJSON in self.opponentData["skillInUse"].array! {
			if let identifier = idJSON.string {
				let skill = FMDatabaseManager.sharedManager.skill(identifier: identifier)
				array.append(skill)
			}
		}
		
		return array
	}
	
	fileprivate func getOpponentAppearance() -> FMAppearance {
		let anySkill = self.getOpponentSkills().first!
		return anySkill.appearance[0]
	}
	
	fileprivate func getDefenceSpirtes(attackSkill: FMSkill, defenderAppearance: FMAppearance) -> [UIImage] {
		let name = attackSkill.name
		let appearanceID = defenderAppearance.identifier
		let skill = FMDatabaseManager.sharedManager.skill(appearanceIdentifier: appearanceID, name: name)
		return skill.defenceSprites()
	}
}
