//
//  FMSpriteLevelManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 9/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMSpriteLevelManager: NSObject {
	static let sharedManager = FMSpriteLevelManager()
	private let levels = [
		[1500, 200],
		[3000, 250],
		[4500, 300],
		[6000, 350],
		[7500, 400],
		[8500, 450],
		[9500, 500],
		[10500, 550],
		[11500, 600],
		[12500, 650],
		[13500, 700],
		[14500, 750],
		[15500, 800],
		[16500, 850],
		[17500, 900],
		[18500, 950],
		[19000, 1000],
		[19500, 1050],
		[20000, 1100],
		[20500, 1150],
		[21000, 1200],
		[21500, 1250],
		[22000, 1300],
	]
	
	
	func healthLimitForLevel(level: Int) -> Int {
		if level < self.levels.count {
			return self.levels[level][1]
		} else {
			return Int.max
		}
	}
	
	func experienceLimitForLevel(level: Int) -> Int {
		if level < self.levels.count {
			return self.levels[level][0]
		} else {
			return Int.max
		}
	}
	
	
}
