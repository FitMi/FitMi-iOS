//
//  FMWatchOnboardManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 29/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMWatchOnboardManager: NSObject {
	class func hasOnboarded() -> Bool {
		let defaults = UserDefaults.standard
		if defaults.bool(forKey: "WATCH_HAS_ONBOARD") {
			return true
		} else {
			defaults.set(true, forKey: "WATCH_HAS_ONBOARD")
			return false
		}
	}
}
