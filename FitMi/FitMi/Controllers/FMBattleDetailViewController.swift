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
	@IBOutlet var resultView: UIView!
	@IBOutlet var resultLabel: UILabel!
	
	@IBOutlet var primaryImageView: UIImageView!
	@IBOutlet var secondaryImageView: UIImageView!
	
	var opponentID = ""
	fileprivate var opponentData: JSON!
	
	@IBOutlet var opponentAvatarImageView: UIImageView!
	@IBOutlet var opponentNameLabel: UILabel!
	@IBOutlet var opponentHealthBar: UIProgressView!
	@IBOutlet var opponentTimeBar: UIProgressView!
	fileprivate var opponentSkills: [FMSkill]!
	fileprivate var opponentHealthMax: Int = 0
	fileprivate var opponentHealth: Int = 0
	fileprivate var opponentCoolDownPerTimeUnit: Float = 0.5
	
	@IBOutlet var selfAvatarImageView: UIImageView!
	@IBOutlet var selfNameLabel: UILabel!
	@IBOutlet var selfHealthBar: UIProgressView!
	@IBOutlet var selfTimeBar: UIProgressView!
	fileprivate var selfSkills: [FMSkill]!
	fileprivate var selfHealthMax: Int = 0
	fileprivate var selfHealth: Int = 0
	fileprivate var selfCoolDownPerTimeUnit: Float = 1
	
	@IBOutlet var skillButton0: UIButton!
	@IBOutlet var skillButton1: UIButton!
	@IBOutlet var skillButton2: UIButton!
	
	fileprivate var moves = [[String: String]]()
	
	fileprivate var gameLoopTimer: Timer!
	
	fileprivate let coolDownTotal: Float = 100
	fileprivate var opponentCoolDown: Float = 0
	fileprivate var selfCoolDown: Float = 0
	fileprivate var skillButtonArray = [UIButton]()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.battleView.alpha = 0
		self.skillButtonArray = [self.skillButton0, self.skillButton1, self.skillButton2]
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
				}, completion: {
					_ in
					self.startGameLoopTimer()
				})
			}
		})
	}
	
	private func configureImageView() {
		self.primaryImageView.animationRepeatCount = 1
		self.secondaryImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
		self.secondaryImageView.animationRepeatCount = 1
	}
	
	fileprivate func startGameLoopTimer() {
		if let timer = self.gameLoopTimer {
			timer.invalidate()
		}
		
		self.gameLoopTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateStatePerTimeFrame), userInfo: nil, repeats: true)
	}
	
	func updateStatePerTimeFrame() {
		//self
		
		if self.selfCoolDown != self.coolDownTotal {
			self.selfCoolDown += self.selfCoolDownPerTimeUnit
			self.selfCoolDown = min(self.coolDownTotal, self.selfCoolDown)
			DispatchQueue.main.async {
				self.selfTimeBar.setProgress(self.selfCoolDown / self.coolDownTotal, animated: false)
			}
		} else if !self.skillButton0.isEnabled {
			DispatchQueue.main.async {
				self.setSkillButtonsEnabled(enabled: true)
			}
		}
		
		//opponent
		if self.opponentCoolDown != self.coolDownTotal {
			self.opponentCoolDown += self.opponentCoolDownPerTimeUnit
			self.opponentCoolDown = min(self.coolDownTotal, self.opponentCoolDown)
			DispatchQueue.main.async {
				self.opponentTimeBar.setProgress(self.opponentCoolDown / self.coolDownTotal, animated: false)
			}
		} else {
			let time = Double(1)
			self.primaryImageView.animationDuration = time
			self.secondaryImageView.animationDuration = time
			self.gameLoopTimer.invalidate()
			DispatchQueue.main.async {
				self.setSkillButtonsEnabled(enabled: false)
			}
			self.friendAttack()
			
			
			DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
				self.updateHealth()
				self.opponentCoolDown = 0
				self.opponentTimeBar.setProgress(0, animated: false)
				
				let result = self.isGameOver()
				if result != 0 {
					self.showResultScreen(isSelfWin: result == 1)
					return
				}
				
				self.setSkillButtonsEnabled(enabled: self.selfTimeBar.progress == 1)
				self.startGameLoopTimer()
			})
		}
	}
	
	fileprivate func showResultScreen(isSelfWin: Bool) {
		self.resultView.isUserInteractionEnabled = true
		
		if isSelfWin {
			self.resultLabel.text = "YOU WIN !"
		} else {
			self.resultLabel.text = "YOU LOSE !"
		}
		
		UIView.animate(withDuration: 0.3, delay: 0.2, options: [], animations: {
			self.resultView.alpha = 0.95
		}, completion: nil)
	}
	
	// 0 means not over
	// -1 means I win
	// 1 means opponent wins
	fileprivate func isGameOver() -> Int {
		if self.selfHealth == 0 {
			return -1
		} else if self.opponentHealth == 0 {
			return 1
		} else {
			return 0
		}
	}
	
	@IBAction func skillButtonDidClick(sender: UIButton) {
		
		self.setSkillButtonsEnabled(enabled: false)
		
		let time = Double(1)
		self.primaryImageView.animationDuration = time
		self.secondaryImageView.animationDuration = time
		self.gameLoopTimer.invalidate()
		
		let skill = self.selfSkills[sender.tag]
		self.strikeWithSkill(skill: skill, fromSelf: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
			self.updateHealth()
			self.selfCoolDown = 0
			self.selfTimeBar.setProgress(0, animated: false)
			
			let result = self.isGameOver()
			if result != 0 {
				self.showResultScreen(isSelfWin: result == 1)
				return
			}
			
			self.startGameLoopTimer()
		})
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
		
		
		
		for i in 0..<3 {
			self.skillButtonArray[i].isHidden = !(i < self.selfSkills.count)
		}
	}
	
	fileprivate func setSkillButtonsEnabled(enabled: Bool) {
		for button in self.skillButtonArray {
			button.isEnabled = enabled
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
		self.moves.append(thisMove)
		
		if fromSelf {
			let newHealth = self.selfHealth + healing
			self.selfHealth = min(newHealth, self.selfHealthMax)
			let selfProgress = Float(self.selfHealth) / Float(self.selfHealthMax)
			self.selfHealthBar.setProgress(selfProgress, animated: true)
			
			
			let newOpponentHealth = self.opponentHealth - damage
			self.opponentHealth = max(newOpponentHealth, 0)
			
			let attackImages = skill.attackSprites()
			let defenceImages = getDefenceSpirtes(attackSkill: skill, defenderAppearance: self.getOpponentAppearance())
			
			self.primaryImageView.animationImages = attackImages
			self.secondaryImageView.animationImages = defenceImages
			self.primaryImageView.superview?.bringSubview(toFront: self.primaryImageView)
		} else {
			let newOpponentHealth = self.opponentHealth + healing
			self.opponentHealth = min(newOpponentHealth, self.opponentHealthMax)
			let opponentProgress = Float(self.opponentHealth) / Float(self.opponentHealthMax)
			self.opponentHealthBar.setProgress(opponentProgress, animated: true)
			
			
			let newHealth = self.selfHealth - damage
			self.selfHealth = max(newHealth, 0)
			
			
			let attackImages = skill.attackSprites()
			let defenceImages = getDefenceSpirtes(attackSkill: skill, defenderAppearance: self.getSelfAppearance())
			
			self.primaryImageView.animationImages = defenceImages
			self.secondaryImageView.animationImages = attackImages
			self.secondaryImageView.superview?.bringSubview(toFront: self.secondaryImageView)
		}
		
		self.primaryImageView.startAnimating()
		self.secondaryImageView.startAnimating()
	}
	
	fileprivate func updateHealth() {
		let opponentProgress = Float(self.opponentHealth) / Float(self.opponentHealthMax)
		self.opponentHealthBar.setProgress(opponentProgress, animated: true)
		
		let selfProgress = Float(self.selfHealth) / Float(self.selfHealthMax)
		self.selfHealthBar.setProgress(selfProgress, animated: true)
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
	
	fileprivate func getSelfAppearance() -> FMAppearance {
		return FMSpriteStatusManager.sharedManager.spriteAppearance()
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
