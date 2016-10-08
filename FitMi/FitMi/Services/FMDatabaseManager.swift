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
	private let realm = try! Realm()
	
	func getCurrentSprite() -> FMSprite {
		var sprite = realm.objects(FMSprite.self).first
		if sprite == nil {
			sprite = FMSprite()
			sprite?.type = "CAT"
			try! realm.write {
				realm.add(sprite!)
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
}
