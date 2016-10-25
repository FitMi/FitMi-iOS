//
//  FMBoothItemCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 19/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMBoothItemCell: UITableViewCell {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var button: UIButton!
	@IBOutlet var iconImageView: UIImageView!
	
	var object: Any?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		let normalImage = UIImage.fromColor(color: UIColor.activeColor)
		let highlightedImage = UIImage.fromColor(color: UIColor.gray)
		let disabledImage = UIImage.fromColor(color: UIColor.activeColor.withAlphaComponent(0.2))
		
		self.button.setBackgroundImage(normalImage, for: .normal)
		self.button.setBackgroundImage(highlightedImage, for: .highlighted)
		self.button.setBackgroundImage(disabledImage, for: .disabled)
		
		self.button.setTitle("NO SLOT", for: .disabled)
    }
	
	@IBAction func buttonDidClick() {
		let title = self.button.title(for: .normal)
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BOOTH_BUTTON_DID_CLICK_NOTIFICATION"), object: self.object, userInfo:["USING": title == "USING", "BUTTON": self.button])
	}
	
	func setButtonState(inUse: Bool) {
		if inUse {
			let normalImage = UIImage.fromColor(color: UIColor.darkGray)
			self.button.setBackgroundImage(normalImage, for: .normal)
			self.button.setTitle("USING", for: .normal)
		} else {
			let normalImage = UIImage.fromColor(color: UIColor.activeColor)
			self.button.setBackgroundImage(normalImage, for: .normal)
			self.button.setTitle("USE", for: .normal)
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {

		if self.contentView.alpha != 1 {
			return
		}
		
		let animationDuration: TimeInterval = selected ? 0.0 : 0.1
		
		UIView.animate(withDuration: animationDuration, animations: {
			if selected {
				self.contentView.backgroundColor = UIColor.activeColor.withAlphaComponent(0.1)
			} else {
				self.contentView.backgroundColor = self.backgroundColor
			}
		})
    }
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		
		if self.contentView.alpha != 1 {
			return
		}
		
		
		let animationDuration: TimeInterval = highlighted ? 0.0 : 0.1
		
		UIView.animate(withDuration: animationDuration, animations: {
			if highlighted {
				self.contentView.backgroundColor = UIColor.activeColor.withAlphaComponent(0.2)
			} else {
				self.contentView.backgroundColor = self.backgroundColor
			}
		})
	}
	
	static let identifier = "FMBoothItemCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMBoothItemCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
