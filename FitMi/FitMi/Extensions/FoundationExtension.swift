//
//  FoundationExtension.swift
//  FitMi
//
//  Created by Jinghan Wang on 8/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation

extension Date {
	struct Formatter {
		static let iso8601: DateFormatter = {
			let formatter = DateFormatter()
			formatter.calendar = Calendar(identifier: .iso8601)
			formatter.locale = Locale(identifier: "en_US_POSIX")
			formatter.timeZone = TimeZone(secondsFromGMT: 0)
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
			return formatter
		}()
	}
	
	var iso8601: String {
		return Formatter.iso8601.string(from: self)
	}
	
	var timeStamp: String {
		return "\(Int(self.timeIntervalSince1970 - 1))"
	}
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

extension String {
	func lastPathComponent() -> String? {
		let array = self.characters.split(separator: "/").map(String.init)
		return array.last
	}
}
