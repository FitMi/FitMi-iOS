//
//  FMOutlinedLabel.swift
//  FitMi
//
//  Created by Jinghan Wang on 20/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMOutlinedLabel: UILabel {

	var outlineColor: UIColor = UIColor.black
	var outlineWidth: CGFloat = 2
	
	override func drawText(in rect: CGRect) {
		let shadowOffset = self.shadowOffset
		let color = self.textColor
		
		let context = UIGraphicsGetCurrentContext()
		context?.setLineWidth(self.outlineWidth * 2)
		context?.setLineJoin(.round)
		context?.setTextDrawingMode(.stroke)
		self.textColor = self.outlineColor
		super.drawText(in: rect)
		
		context?.setTextDrawingMode(.fill)
		self.textColor = color
		self.shadowOffset = CGSize.zero
		super.drawText(in: rect)
		
		self.shadowOffset = shadowOffset
	}
	
	var outlineStyle: Int {
		get {
			return 0
		}
		
		set(newValue) {
			switch newValue {
			default:
				self.textColor = UIColor.white
				self.outlineColor = UIColor.black.withAlphaComponent(0.8)
			}
		}
	}

}
