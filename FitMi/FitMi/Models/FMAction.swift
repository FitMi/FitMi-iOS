//
//  FMAction.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import RealmSwift

class FMAction: Object {
	
	dynamic var name: String = ""
	dynamic var descriptionText: String = ""
	dynamic var identifier: String = ""
	dynamic var	type: String = ""
	dynamic var	unlockLevel: Int = 0
	
	dynamic var spriteAtlasCount: Int = 0
	
	let appearance = LinkingObjects(fromType: FMAppearance.self, property: "actions")
	
	override static func indexedProperties() -> [String] {
		return ["identifier"]
	}
	
	func sprites() -> [UIImage] {
		var imageNames = [String]()
		for i in 0..<self.spriteAtlasCount {
			imageNames.append(self.spriteName(forIndex: i))
		}
		
		let images = imageNames.map{ return FMLocalStorageManager.sharedManager.getImage(imageName: $0)}
		
		return images as! [UIImage]
	}
	
	func spriteUrls() -> [String] {
		var urls = [String]()
		for i in 0..<self.spriteAtlasCount {
			urls.append("\(SPRITE_IMAGE_BASE_URL)\(self.spriteName(forIndex: i))")
		}
		return urls
	}
	
	func spriteName(forIndex i: Int) -> String{
		return "sprite-\(self.identifier)-@\(i).png"
	}
}
