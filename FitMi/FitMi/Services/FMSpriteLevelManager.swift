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
		[1500, 200, 1],
		[3000, 250, 1],
		[4500, 300, 1],
		[6000, 350, 1],
		[7500, 400, 2],
		[8500, 450, 2],
		[9500, 500, 2],
		[10500, 550, 2],
		[11500, 600, 2],
		[12500, 650, 2],
		[13500, 700, 2],
		[14500, 750, 2],
		[15500, 800, 3],
		[16500, 850, 3],
		[17500, 900, 3],
		[18500, 950, 3],
		[19000, 1000, 3],
		[19500, 1050, 3],
		[20000, 1100, 3],
		[20500, 1150, 3],
		[21000, 1200, 3],
		[21500, 1250, 3],
		[22000, 1300, 3],
	]

	func skillSlotCountForLevel(level: Int) -> Int {
		if level < self.levels.count {
			return self.levels[level][2]
		} else {
			return self.levels[self.levels.count - 1][2]
		}
	}
	
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
	
	func levelForExp(exp: Int) -> Int {
		var level = 0
		
		for i in 0..<levels.count {
			if exp > experienceLimitForLevel(level: i) {
				level += 1
			} else {
				break
			}
		}
		
		return level
	}
	
}
