//
//  FoundationExtension.swift
//  FitMi
//
//  Created by Jinghan Wang on 8/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation

extension Date {
	
}

extension Calendar {
	func endOfDay(for date: Date) -> Date{
		let components = NSDateComponents()
		components.hour = 23
		components.minute = 59
		components.second = 59
		return self.date(byAdding: components as DateComponents, to: self.startOfDay(for: date))!
	}
	
	func nextDay(from date: Date) -> Date {
		let components = NSDateComponents()
		components.day = 1
		return self.date(byAdding: components as DateComponents, to: date)!
	}
}
