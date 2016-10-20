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
				self.layer.shadowOpacity = 0.2
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
			return UIColor(red: 66/255.0, green: 215/255.0, blue: 205/255.0, alpha: 1)
		}
	}
	
	static var secondaryColor: UIColor {
		get {
			return UIColor(red: 255/255.0, green: 251/255.0, blue: 233/255.0, alpha: 1)
		}
	}
	
	static var activeColor: UIColor {
		get {
			return UIColor(red:0.29412, green:0.83922, blue:0.80000, alpha:1.00000)
		}
	}
	
	static var darkRed: UIColor {
		get {
			return UIColor(red: 235/255.0, green: 100/255.0, blue: 119/255.0, alpha: 1)
		}
	}
	
	static var darkGreen: UIColor {
		get {
			return UIColor(red: 100/255.0, green: 235/255.0, blue: 147/255.0, alpha: 1)
		}
	}
    
    static var facebookBlue: UIColor {
        get {
            return UIColor(red: 58/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1)
        }
    }
    
    static var logOutRed: UIColor {
        get {
            return UIColor(red: 245/255.0, green: 81/255.0, blue: 83/255.0, alpha: 1)
        }
    }
}

extension UIImage {
	static func fromColor(color: UIColor) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()!
		context.setFillColor(color.cgColor)
		context.fill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
}
