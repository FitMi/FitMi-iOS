//
//  FMBattleDetailViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 21/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import SwiftyJSON

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
	
	fileprivate var moves: [[String: String]]!
	
	var opponentID = ""
	var opponentSkills: [FMSkill]!
	
	fileprivate var opponenetData: JSON!
	
	
	
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
				self.opponenetData = json
				self.refreshView()
				self.activityIndicator.stopAnimating()
				self.battleView.isUserInteractionEnabled = true
				UIView.animate(withDuration: 0.5, animations: {
					self.battleView.alpha = 1
				})
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
	
	fileprivate func loadOpponentData(completion: @escaping ((_ data: JSON?) -> Void)) {
		FMNetworkManager.sharedManager.getUser(userFbId: self.opponentID, completion: {
			error, data in
			completion(data)
		})
	}
	
	fileprivate func loadFake() -> JSON {
		let str = "{\"_id\": \"object ID\",\"username\": \"Jason\",\"spritename\": \"sprite name\",\"facebookToken\": \"Facebook access token\",\"facebookId\": \"100003031938297\",\"__v\": 0,\"strength\": 200,\"stamina\": 132,\"agility\": 123,\"health\": 190,\"level\": 14,\"skillInUse\": [\"skill-D4D534EE-297B-42C3-B8CA-77906414B14B\", \"skill-56AC9D4A-BAF2-46EA-A5DD-785799D51FDE\"],\"updatedAt\": \"2016-10-20T15:12:08.240Z\",\"lastCombatTime\": \"2016-10-20T15:12:08.240Z\",\"createdAt\": \"2016-10-20T15:12:08.240Z\"}"
		return JSON.parse(str)
	}
	
	fileprivate func refreshView() {
		self.selfNameLabel.text = self.getSelfName()
		self.selfHealthMax = self.getSelfHealth()
		self.selfHealth = self.getSelfHealth()
		self.selfHealthBar.setProgress(1, animated: false)
		self.selfAvatarImageView.af_setImage(withURL: URL(string: "http://graph.facebook.com/\(self.getSelfFacebookId())/picture?type=large")!)
		
		self.opponentNameLabel.text = self.getOpponentName()
		self.opponentHealthMax = self.getOpponentHealth()
		self.opponentHealth = self.getOpponentHealth()
		self.opponentHealthBar.setProgress(1, animated: false)
		self.opponentAvatarImageView.af_setImage(withURL: URL(string: "http://graph.facebook.com/\(self.getOpponentFacebookId())/picture?type=large")!)
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
		
		print(thisMove)
		
		return thisMove
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
	
	
	// JSON accessors
	
	fileprivate func getOpponentName() -> String {
		return self.opponenetData["username"].string!
	}
	
	fileprivate func getOpponentHealth() -> Int {
		return self.opponenetData["health"].int!
	}
	
	fileprivate func getOpponentStamina() -> Int {
		return self.opponenetData["stamina"].int!
	}
	
	fileprivate func getOpponentStrength() -> Int {
		return self.opponenetData["strength"].int!
	}
	
	fileprivate func getOpponentAgility() -> Int {
		return self.opponenetData["agility"].int!
	}
	
	fileprivate func getOpponentFacebookId() -> String {
		return self.opponenetData["facebookId"].string!
	}
	
	fileprivate func getOpponentSkills() -> [FMSkill] {
		if self.opponentSkills != nil {
			return self.opponentSkills
		}
		
		var array = [FMSkill]()
		
		for idJSON in self.opponenetData["skillInUse"].array! {
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
