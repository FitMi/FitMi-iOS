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
		
		return sprite!
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
}
