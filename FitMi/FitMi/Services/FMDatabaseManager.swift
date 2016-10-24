//
//  FMDatabaseManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import RealmSwift

class FMDatabaseManager: NSObject {
	static let sharedManager = FMDatabaseManager()
	private var realm: Realm!
	
	override init() {
		super.init()
		DispatchQueue.main.async {
			self.realm = try! Realm()
		}
	}
	
	func getCurrentSprite() -> FMSprite {
		var sprite = realm.objects(FMSprite.self).first
		if sprite == nil {
			sprite = FMSprite()
			try! realm.write {
				realm.add(sprite!)
			}
		}
		
		if sprite!.appearanceIdentifier == "" {
			try! realm.write {
				sprite?.appearanceIdentifier = "appearance-29d2d064-93a8-11e6-ae22-56b6b6499611"
			}
		}
		
		let appearance = self.appearances().filter("identifier = %@", sprite!.appearanceIdentifier).first!
		let level = sprite!.states.last == nil ? 0 : sprite!.states.last!.level
		
		if sprite!.skills.count == 0 {
			let skills = appearance.skills.filter("unlockLevel <= %ld", level)
			
			try! realm.write {
				sprite!.skills.removeAll()
				sprite!.skills.append(objectsIn: skills)
			}
		}
		
		if sprite!.skillSlotCount == 0 {
			try! realm.write {
				sprite!.skillSlotCount = FMSpriteLevelManager.sharedManager.skillSlotCountForLevel(level: level)
			}
		}
		
		if sprite!.actions.count == 0 {
			let actions = appearance.actions.filter("unlockLevel <= %ld", level)
			
			try! realm.write {
				sprite!.actions.append(objectsIn: actions)
			}
		}
		
		if sprite!.skillsInUse.count == 0 {
			let numberOfSkillsAllowed: Int = min(sprite!.skillSlotCount, sprite!.skills.count)
			try! realm.write {
				for i in 0..<numberOfSkillsAllowed {
					sprite!.skillsInUse.append(sprite!.skills[i])
				}
			}
		}
		
		if sprite!.touchAction == nil {
			try! realm.write {
				sprite!.touchAction = sprite!.actions.filter("name = %@", "Basic Touch").first!
			}
		}
		
		if sprite!.sleepAction == nil {
			try! realm.write {
				sprite!.sleepAction = sprite!.actions.filter("name = %@", "Basic Sleep").first!
			}
		}
		
		if sprite!.relaxAction == nil {
			try! realm.write {
				sprite!.relaxAction = sprite!.actions.filter("name = %@", "Basic Relax").first!
			}
		}
		
		if sprite!.wakeAction == nil {
			try! realm.write {
				sprite!.wakeAction = sprite!.actions.filter("name = %@", "Basic Wake").first!
			}
		}
		
		if sprite!.runAction == nil {
			try! realm.write {
				sprite!.runAction = sprite!.actions.filter("name = %@", "Basic Run").first!
			}
		}
		
		if sprite!.tiredAction == nil {
			try! realm.write {
				sprite!.tiredAction = sprite!.actions.filter("name = %@", "Basic Tired").first!
			}
		}
		
		return sprite!
	}
	
	func refreshMySkills() {
		let sprite = FMSpriteStatusManager.sharedManager.sprite
		let appearance = self.appearances().filter("identifier = %@", sprite!.appearanceIdentifier).first!
		let level = sprite!.states.last == nil ? 0 : sprite!.states.last!.level
		let skills = appearance.skills.filter("unlockLevel <= %ld", level)
		try! realm.write {
			sprite!.skills.removeAll()
			sprite!.skills.append(objectsIn: skills)
		}
	}
	
	func realmUpdate(workBlock:@escaping (()-> Void)) {
		DispatchQueue.main.async {
			try! self.realm.write {
				workBlock()
			}
		}
	}
	
	func appearances() -> Results<FMAppearance> {
		return realm.objects(FMAppearance.self)
	}
	
	func skills() -> List<FMSkill> {
		let appearance = FMSpriteStatusManager.sharedManager.spriteAppearance()
		return appearance.skills
	}
	
	func actions() -> List<FMAction> {
		let appearance = FMSpriteStatusManager.sharedManager.spriteAppearance()
		return appearance.actions
	}
	
	func skill(appearanceIdentifier: String, name: String) -> FMSkill {
		let appearance = self.appearances().filter("identifier = %@", appearanceIdentifier).first!
		let skill = appearance.skills.filter("name = %@", name).first!
		return skill
	}
	
	func skill(identifier: String) -> FMSkill {
		let skill = self.realm.objects(FMSkill.self).filter("identifier = %@", identifier).first!
		return skill
	}
	
	func action(appearanceIdentifier: String, name: String) -> FMAction {
		let appearance = self.appearances().filter("identifier = %@", appearanceIdentifier).first!
		let action = appearance.actions.filter("name = %@", name).first!
		return action
	}
}
