//
//  FMProgressView.swift
//  FitMi
//
//  Created by Jinghan Wang on 17/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMProgressView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	fileprivate var _value: Double = 50
	fileprivate var _maxValue: Double = 100
	
	@IBOutlet var innerView: UIView!
	@IBOutlet var progressConstraint: NSLayoutConstraint!
	
	var maxValue: Double {
		get {
			return self._maxValue
		}
		
		set (newValue) {
			if newValue > 0 {
				_maxValue = newValue
			}
			
			self.updateAppearance()
		}
	}
	
	var value: Double {
		get {
			return _value
		}
		
		set (newValue) {
			if newValue > _maxValue {
				_value = _maxValue
			} else if (newValue < 0) {
				_value = 0
			} else {
				_value = value
			}
			
			self.updateAppearance()
		}
	}
	
	var percentage: Double {
		get {
			return _value / _maxValue
		}
		
		set (newValue) {
			if (newValue > 1) {
				_value = _maxValue
			} else if (newValue < 0) {
				_value = 0
			} else {
				_value = _maxValue * newValue
			}
			
			self.updateAppearance()
		}
	}
	
	fileprivate func updateAppearance() {
		self.progressConstraint.constant = CGFloat(self.percentage)
		self.setNeedsLayout()
	}
	
	static func oneMore() -> FMProgressView {
		let view = Bundle.main.loadNibNamed("FMProgressView", owner: self, options: nil)![0] as! FMProgressView
		return view
	}
}
