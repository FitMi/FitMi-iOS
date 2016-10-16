//
//  FMLocalStorageManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMLocalStorageManager: NSObject {
	static var sharedManager = FMLocalStorageManager()
	
	// IMPORTANT: All imageName in this context must include an extension name
	
	func saveImage(imageData: Data, imageName: String) -> Bool {
		let imagePath = self.imagePath(forName: imageName)
		let imageDirPath = self.imageDirectoryPath()
		
		let fileManager = FileManager.default
		if !fileManager.fileExists(atPath: imageDirPath) {
			try! fileManager.createDirectory(atPath: imageDirPath, withIntermediateDirectories: false, attributes: nil)
		}
		
		if fileManager.fileExists(atPath: imagePath) {
			try! fileManager.removeItem(atPath: imagePath)
		}
		
		let success = fileManager.createFile(atPath: imagePath, contents: imageData, attributes: nil)
		
		return success
	}
	
	func getImage(imageName: String) -> UIImage? {
		let imagePath = self.imagePath(forName: imageName)
		print(imagePath)
		return UIImage(contentsOfFile: imagePath)
	}
	
	func imageDirectoryPath() -> String {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let dir = paths[0].appending("/sprites/")
		return dir
	}
	
	func imagePath(forName name: String) -> String {
		let dir = self.imageDirectoryPath()
		let imagePath = dir.appending(name)
		return imagePath
	}
}
