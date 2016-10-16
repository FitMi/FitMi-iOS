//
//  FMConfigurationParser.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import RealmSwift

class FMConfigurationParser: NSObject {
	
	class func refreshConfiguration() {
		let filePath = Bundle.main.path(forResource: "Fitconfig", ofType: "plist")!
		let dictionary = NSDictionary(contentsOfFile: filePath)!
		
		self.constructDatabaseContent(fromDictionary: dictionary)
	}
	
	class func constructDatabaseContent(fromDictionary dict: NSDictionary) {
		if let appearances = dict["Appearances"] {
			for a in appearances as! NSArray {
				let this = a as! NSDictionary
				let identifier = this["Identifier"] as! String
				let thisTimeStamp = this["LastUpdate"] as! String
				let thisTime = Date(timeIntervalSince1970: Double(thisTimeStamp)!)
				
				let realm = try! Realm()
				let existing = realm.objects(FMAppearance.self).filter("identifier == \"\(identifier)\"")
				
				
				if existing.count > 0 {
					let appearance = existing.first!
					let lastUpdateTime = appearance.lastUpdateTime
					if thisTime <= lastUpdateTime {
						print("Assets update to date!")
						break
					} else {
						self.removeAppearance(appearance: appearance)
					}
				}
				
				let appearance = FMAppearance()
				//update appearance
				
				let displayName = this["DisplayName"] as! String
				let unlockLevel = this["UnlockLevel"] as! NSNumber
				
				appearance.lastUpdateTime = thisTime
				appearance.identifier = identifier
				appearance.name = displayName
				appearance.unlockLevel = Int(unlockLevel)
				
				let skills = this["Skills"] as! NSArray
				for s in skills {
					let skillDict = s as! NSDictionary
					
					let skill = FMSKill()
					skill.name = skillDict["DisplayName"] as! String
					skill.identifier = skillDict["Identifier"] as! String
					skill.unlockLevel = Int(skillDict["UnlockLevel"] as! NSNumber)
					skill.strengthFactor = Double(skillDict["StrengthFactor"] as! NSNumber)
					skill.staminaFactor = Double(skillDict["StaminaFactor"] as! NSNumber)
					skill.agilityFactor = Double(skillDict["AgilityFactor"] as! NSNumber)
					skill.attackSpriteAtlasCount = Int(skillDict["AttackSpriteAtlasCount"] as! NSNumber)
					skill.defenceSpriteAtlasCount = Int(skillDict["DefenceSpriteAtlasCount"] as! NSNumber)
					
					appearance.skills.append(skill)
					
					self.downloadSprites(forSkill: skill)
				}
				
				let actions = this["Actions"] as! NSArray
				for a in actions {
					let actionDict = a as! NSDictionary
					
					let action = FMAction()
					action.name = actionDict["DisplayName"] as! String
					action.identifier = actionDict["Identifier"] as! String
					action.unlockLevel = Int(actionDict["UnlockLevel"] as! NSNumber)
					action.type = actionDict["Type"] as! String
					action.spriteAtlasCount = Int(actionDict["SpriteAtlasCount"] as! NSNumber)
					
					appearance.actions.append(action)
					
					self.downloadSprites(forAction: action)
				}
				
				FMDatabaseManager.sharedManager.realmUpdate {
					realm.add(appearance)
				}
			}
		}
	}
	
	class func removeAppearance(appearance: FMAppearance) {
		// TODO: remove images files in documents folder
		
		let realm = try! Realm()
		realm.delete(appearance.skills)
		realm.delete(appearance.actions)
		realm.delete(appearance)
	}
	
	class func downloadSprites(forSkill skill: FMSKill) {
		print("Downloading sprites for skill: \(skill.name)")
		
		for url in skill.attackSpriteUrls() {
			print(url)
		}
		
		for url in skill.defenceSpriteUrls() {
			print(url)
		}
	}
	
	class func downloadSprites(forAction action: FMAction) {
		print("Downloading sprites for action: \(action.name)")
		
		for url in action.spriteUrls() {
			print(url)
		}
	}

}
