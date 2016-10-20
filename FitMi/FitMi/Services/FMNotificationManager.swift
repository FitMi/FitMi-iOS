//
//  FMNotificationManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 20/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

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
}
