//
//  FMNotificationManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 20/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import UserNotifications

class FMNotificationManager: NSObject {
	static var sharedManager = FMNotificationManager()
	
	func showStandardFeedbackMessage(text: String) {
		let view = UIApplication.shared.keyWindow!
		
		let messageView = FMOutlinedLabel(frame: view.bounds)
		messageView.isUserInteractionEnabled = false
		messageView.textAlignment = .center
		messageView.font = UIFont(name: "Pokemon Pixel Font", size: 25)
		messageView.textColor = UIColor.white
		messageView.outlineWidth = 2
		messageView.text = text
		
		view.addSubview(messageView)
		
		var newCenter = messageView.center
		newCenter.y += 150
		
		UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseIn], animations: {
			messageView.center = newCenter
			}, completion: {
				_ in
				messageView.removeFromSuperview()
		})
		
		UIView.animate(withDuration: 1, delay: 1, options: [.curveEaseIn], animations: {
			messageView.alpha = 0
			}, completion: {
				_ in
				messageView.removeFromSuperview()
		})
	}
	
	func showFeedbackMessage(text: String, in view: UIView, offset: CGPoint, borderColor: UIColor, textColor: UIColor) {
		let messageView = FMOutlinedLabel(frame: view.bounds)
		messageView.isUserInteractionEnabled = false
		messageView.textAlignment = .center
		messageView.font = UIFont(name: "Pixeled", size: 20)
		messageView.textColor = textColor
		messageView.outlineColor = borderColor
		messageView.outlineWidth = 2
		messageView.text = text
		
		view.addSubview(messageView)
		
		var newCenter = messageView.center
		newCenter.x = newCenter.x + offset.x
		newCenter.y = newCenter.y + offset.y
		messageView.center = newCenter
		
		newCenter.y += 150
		
		UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn], animations: {
			messageView.center = newCenter
			}, completion: {
				_ in
				messageView.removeFromSuperview()
		})
		
		UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseIn], animations: {
			messageView.alpha = 0
			}, completion: {
				_ in
				messageView.removeFromSuperview()
		})
	}
    
    func scheduleDailyNotification(title: String, body: String) {
		let calendar = Calendar.current
		var nextWeek = calendar.date(byAdding: .day, value: 7, to: Date())!
		nextWeek = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: nextWeek)!
		
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: nextWeek.timeIntervalSinceNow, repeats: true)
            let requestIndentifier = "exerciseReminder"
            let request = UNNotificationRequest(identifier: requestIndentifier,
                                                content: content,
                                                trigger: trigger)
            UNUserNotificationCenter.current().add(request) {
                (error) in
            }
        } else {
            // Fallback on earlier versions
            let notification:UILocalNotification = UILocalNotification()
            notification.alertTitle = title
            notification.alertBody = body
            notification.fireDate = nextWeek
            notification.repeatInterval = NSCalendar.Unit.day
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
}
