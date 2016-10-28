//
//  FMBeatMyselfCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 29/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMBeatMyselfCell: UITableViewCell {

	@IBOutlet var label: UILabel!
	@IBOutlet var cardView: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.setCardViewStyle()
	}
	
	func setCardViewStyle() {
		let layer = self.cardView.layer
		layer.borderWidth = 3
		layer.borderColor = UIColor.black.cgColor
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		
		let animationDuration: TimeInterval = highlighted ? 0.0 : 0.1
		
		UIView.animate(withDuration: animationDuration, animations: {
			if highlighted {
				self.cardView.alpha = 0.2
			} else {
				self.cardView.alpha = 1
			}
		})
	}

	
	static let identifier = "FMBeatMyselfCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMBeatMyselfCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
