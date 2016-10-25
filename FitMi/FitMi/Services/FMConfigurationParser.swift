//
//  FMConfigurationParser.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import RealmSwift

protocol FMConfigurationParserDelegate {
	func parserDidReceiveUpdate(newProgress: Int, total: Int)
	func parserDidCompleteWork()
}

class FMConfigurationParser: NSObject {
	
	static let counter = FMAtomicCounter()
	private static var total: Int = 0
	static var delegate: FMConfigurationParserDelegate?
	
	class func refreshConfiguration() {
		
//		let filePath = Bundle.main.path(forResource: "Fitconfig", ofType: "plist")!
//		let dictionary = NSDictionary(contentsOfFile: filePath)!
//		self.total = self.constructDatabaseContent(fromDictionary: dictionary)
		
		FMNetworkManager.sharedManager.checkConfiguratonFileUpdate(completion: {
			error, required, dict in
			if error == nil && required && dict != nil {
				self.total = self.constructDatabaseContent(fromDictionary: dict!)
			} else {
				print("Assets up to date")
				print(error ?? "No error.")
				self.delegate?.parserDidCompleteWork()
			}
		})
	}
	
	
	//Return total number of images that need to be updated
	class func constructDatabaseContent(fromDictionary dict: NSDictionary) -> Int{
		var total = 0
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
				appearance.descriptionText = this["Description"] as! String
				
				let skills = this["Skills"] as! NSArray
				for s in skills {
					let skillDict = s as! NSDictionary
					
					let skill = FMSkill()
					skill.name = skillDict["DisplayName"] as! String
					skill.identifier = skillDict["Identifier"] as! String
					skill.unlockLevel = Int(skillDict["UnlockLevel"] as! NSNumber)
					skill.strengthFactor = Double(skillDict["StrengthFactor"] as! NSNumber)
					skill.staminaFactor = Double(skillDict["StaminaFactor"] as! NSNumber)
					skill.agilityFactor = Double(skillDict["AgilityFactor"] as! NSNumber)
					skill.attackSpriteAtlasCount = Int(skillDict["AttackSpriteAtlasCount"] as! NSNumber)
					skill.defenceSpriteAtlasCount = Int(skillDict["DefenceSpriteAtlasCount"] as! NSNumber)
					skill.hitSpriteIndex = Int(skillDict["HitSpriteIndex"] as! NSNumber)
					skill.descriptionTemplate = skillDict["DescriptionTemplate"] as! String
					skill.descriptionText = skillDict["Description"] as! String
					
					total += 1
					total += skill.attackSpriteAtlasCount
					total += skill.defenceSpriteAtlasCount
					
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
					action.descriptionText = actionDict["Description"] as! String
					
					total += action.spriteAtlasCount
					
					appearance.actions.append(action)
					
					self.downloadSprites(forAction: action)
				}
				
				FMDatabaseManager.sharedManager.realmUpdate {
					realm.add(appearance)
				}
			}
		}
		
		return total
	}
	
	class func removeAppearance(appearance: FMAppearance) {
		// TODO: remove images files in documents folder
		
		let realm = try! Realm()
		
		FMDatabaseManager.sharedManager.realmUpdate{
			realm.delete(appearance.skills)
			realm.delete(appearance.actions)
			realm.delete(appearance)
		}
	}
	
	class func downloadSprites(forSkill skill: FMSkill) {
		print("Downloading sprites for skill: \(skill.name)")
		let networkManager = FMNetworkManager.sharedManager
		let localStorageManager = FMLocalStorageManager.sharedManager
		
		let url = skill.iconUrl()
		networkManager.downloadImageFromUrl(urlString: url, completion: {
			error, optionalImage in
			
			if let image = optionalImage {
				let name = url.lastPathComponent()!
				let data = UIImagePNGRepresentation(image)!
				if localStorageManager.saveImage(imageData: data, imageName: name) {
					self.updateProgress(self.counter.incrementAndGet())
				}
			} else {
				print(error ?? "No error")
			}
		})
		
		for url in skill.attackSpriteUrls() {
			networkManager.downloadImageFromUrl(urlString: url, completion: {
				error, optionalImage in
			
				if let image = optionalImage {
					let name = url.lastPathComponent()!
					let data = UIImagePNGRepresentation(image)!
					if localStorageManager.saveImage(imageData: data, imageName: name) {
						self.updateProgress(self.counter.incrementAndGet())
					}
				} else {
					print(error ?? "No error")
				}
			})
		}
		
		for url in skill.defenceSpriteUrls() {
			networkManager.downloadImageFromUrl(urlString: url, completion: {
				error, optionalImage in
				
				if let image = optionalImage {
					let name = url.lastPathComponent()!
					let data = UIImagePNGRepresentation(image)!
					if localStorageManager.saveImage(imageData: data, imageName: name) {
						self.updateProgress(self.counter.incrementAndGet())
					}
				} else {
					print(error ?? "No error")
				}
			})
		}
	}
	
	class func downloadSprites(forAction action: FMAction) {
		print("Downloading sprites for action: \(action.name)")
		let networkManager = FMNetworkManager.sharedManager
		let localStorageManager = FMLocalStorageManager.sharedManager
		
		for url in action.spriteUrls() {
			networkManager.downloadImageFromUrl(urlString: url, completion: {
				error, optionalImage in
				
				if let image = optionalImage {
					let name = url.lastPathComponent()!
					let data = UIImagePNGRepresentation(image)!
					if localStorageManager.saveImage(imageData: data, imageName: name) {
						self.updateProgress(self.counter.incrementAndGet())
					}
				} else {
					print(error ?? "No error")
				}
			})
		}
	}
	
	class func updateProgress(_ number: Int) {
		self.delegate?.parserDidReceiveUpdate(newProgress: number, total: self.total)
		if number == self.total {
			self.delegate?.parserDidCompleteWork()
		}
	}
}
