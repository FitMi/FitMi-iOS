//
//  FMSkill.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import RealmSwift

class FMSkill: Object {
	
	dynamic var name: String = ""
	dynamic var identifier: String = ""
	dynamic var descriptionTemplate: String = "@ATTACKER@ attacks @DEFENDER@."
	dynamic var strengthFactor: Double = 1
	dynamic var staminaFactor: Double = 1
	dynamic var agilityFactor: Double = 1
	dynamic var	unlockLevel: Int = 0
	
	dynamic var attackSpriteAtlasCount: Int = 0
	dynamic var defenceSpriteAtlasCount: Int = 0
	dynamic var hitSpriteIndex = 0
	
	let appearance = LinkingObjects(fromType: FMAppearance.self, property: "skills")
	
	func attackSprites() -> [UIImage] {
		var imageNames = [String]()
		for i in 0..<self.attackSpriteAtlasCount {
			imageNames.append(self.attackSpriteName(forIndex: i))
		}
		
		let images = imageNames.map{ return FMLocalStorageManager.sharedManager.getImage(imageName: $0)}
		
		return images as! [UIImage]
	}
	
	func attackSpriteUrls() -> [String] {
		var urls = [String]()
		for i in 0..<self.attackSpriteAtlasCount {
			urls.append("\(SPRITE_IMAGE_BASE_URL)\(self.attackSpriteName(forIndex: i))")
		}
		return urls
	}
	
	func attackSpriteName(forIndex i: Int) -> String {
		return "attack-\(self.identifier)-@\(i).png"
	}
	
	func defenceSprites() -> [UIImage] {
		var imageNames = [String]()
		for i in 0..<self.defenceSpriteAtlasCount {
			imageNames.append(self.defenceSpriteName(forIndex: i))
		}
		
		let images = imageNames.map{ return FMLocalStorageManager.sharedManager.getImage(imageName: $0)}
		
		return images as! [UIImage]
	}
	
	func defenceSpriteUrls() -> [String] {
		var urls = [String]()
		for i in 0..<self.defenceSpriteAtlasCount {
			urls.append("\(SPRITE_IMAGE_BASE_URL)\(self.defenceSpriteName(forIndex: i))")
		}
		return urls
	}
	
	func defenceSpriteName(forIndex i: Int) -> String {
		return "defence-\(self.identifier)-@\(i).png"
	}
	
	override static func indexedProperties() -> [String] {
		return ["identifier"]
	}
}
