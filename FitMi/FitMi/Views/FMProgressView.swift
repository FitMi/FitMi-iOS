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
	fileprivate var _value: Double = 0
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
			
			self.updateAppearance(duration: 0)
		}
	}
	
	var value: Double {
		get {
			return _value
		}
		
		set (newValue) {
			let oldValue = _value
			if newValue > _maxValue {
				_value = _maxValue
			} else if (newValue < 0) {
				_value = 0
			} else {
				_value = value
			}
			
			self.updateAppearance(duration: (oldValue - _value)/_maxValue)
		}
	}
	
	var percentage: Double {
		get {
			return _value / _maxValue
		}
		
		set (newValue) {
			let oldValue = _value
			if (newValue > 1) {
				_value = _maxValue
			} else if (newValue < 0) {
				_value = 0
			} else {
				_value = _maxValue * newValue
			}
			
			self.updateAppearance(duration: (oldValue - _value)/_maxValue)
		}
	}
	
	fileprivate func updateAppearance(duration: Double) {
		self.setNeedsLayout()
		UIView.animate(withDuration: duration, animations: {
			self.progressConstraint.constant = self.constant()
			self.layoutIfNeeded()
		})
	}
	
	fileprivate func constant() -> CGFloat {
		let fullWidth = self.bounds.width
		let constant = CGFloat(_value / _maxValue) * fullWidth
		return constant
	}
}
