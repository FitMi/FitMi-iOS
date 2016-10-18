//
//  FMLabelCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMLabelCell: UITableViewCell {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var contentLabel: UILabel!
	private var isHighlightEnabled = false
	
	var highlightEnabled: Bool {
		set(newValue) {
			if highlightEnabled {
				self.contentLabel.textColor = UIColor.activeColor
			} else {
				self.contentLabel.textColor = UIColor.black
			}
			self.isHighlightEnabled = newValue
		}
		
		get {
			return self.isHighlightEnabled
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		if highlightEnabled {
			self.contentLabel.textColor = UIColor.primaryColor
		} else {
			self.contentLabel.textColor = UIColor.black
		}
		
		self.highlightEnabled = false
        // Initialization code
    }

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		if highlightEnabled {
			let alpha: CGFloat = highlighted ? 0.3 : 1
			self.contentLabel.alpha = alpha
		}
	}
	
	static let identifier = "FMLabelCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMLabelCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
