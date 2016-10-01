//
//  UIKitExtention.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

extension UIView {
	
	// Set predefined shadow specifics to a UIView
	// This can be used in storyboard
	var shadow: Int {
		get {
			return 0
		}
		
		set(newShadow) {
			switch newShadow {
				
			// menu button and menu dismiss button
			case 0:
				self.layer.shadowRadius = 1
				self.layer.shadowOffset = CGSize.zero
				self.layer.shadowOpacity = 0.1
			default:
				print("shadowType not defined.")
			}

		}
	}
	
	var shadowColor: Int {
		get {
			return 0
		}
		
		set(newShadowColor) {
			switch newShadowColor {
			case 0:
				self.layer.shadowColor = UIColor.black.cgColor
			case 1:
				self.layer.shadowColor = UIColor.white.cgColor
			default:
				print("shadowColor not defined")
			}
		}
	}
}

extension UIColor {
	static var primaryColor: UIColor {
		get {
			return UIColor(red: 68/255.0, green: 84/255.0, blue: 100/255.0, alpha: 1)
		}
	}
	
	static var secondaryColor: UIColor {
		get {
			return UIColor(red: 253/255.0, green: 252/255.0, blue: 224/255.0, alpha: 1)
		}
	}
}
