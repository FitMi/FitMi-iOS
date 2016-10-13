//
//  FMOnboardManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 14/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMOnboardManager: NSObject {
	
	static let sharedManager: FMOnboardManager = FMOnboardManager()
	
	fileprivate var onboardStatus: [String: String]!
	
	override init() {
		super.init()
		self.onboardStatus = self.getOnboardStatusDictionary()
	}
	
	fileprivate func getOnboardStatusDictionary() -> [String: String] {
		if let dict = UserDefaults.standard.dictionary(forKey: USER_DEFAULT_KEY_ONBOARD) {
			return dict as! [String : String]
		} else {
			UserDefaults.standard.set([], forKey: USER_DEFAULT_KEY_ONBOARD)
			return [:]
		}
	}
	
	fileprivate func getCurrentVersion() -> String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
	}
	
	fileprivate func updateUserDefault() {
		UserDefaults.standard.set(self.onboardStatus, forKey: USER_DEFAULT_KEY_ONBOARD)
	}
	
	fileprivate func controllerHasVisited(for controller: FMViewController) -> Bool {
		let key = String(describing: type(of: controller))
		let version = self.getCurrentVersion()
		if self.onboardStatus[key] == nil || self.onboardStatus[key]! < version {
			self.onboardStatus[key] = version
			self.updateUserDefault()
			return false
		} else {
			return true
		}
	}
	
	fileprivate func appHasOnboard() -> Bool {
		let version = self.getCurrentVersion()
		if self.onboardStatus["UIApplication"] == nil || self.onboardStatus["UIApplication"]! < version {
			self.onboardStatus["UIApplication"] = version
			self.updateUserDefault()
			return false
		} else {
			return true
		}
	}
}

extension FMViewController {
	var hasVisited: Bool {
		get {
			return FMOnboardManager.sharedManager.controllerHasVisited(for: self)
		}
	}
}

extension UIApplication {
	var hasOnboard: Bool {
		get {
			return FMOnboardManager.sharedManager.appHasOnboard()
		}
	}
}
