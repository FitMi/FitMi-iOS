//
//  FMBoothItemCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 19/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMBoothItemCell: UITableViewCell {

	@IBOutlet var indicatorLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var button: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		let normalImage = UIImage.fromColor(color: UIColor.activeColor)
		let highlightedImage = UIImage.fromColor(color: UIColor.gray)
		
		self.button.setBackgroundImage(normalImage, for: .normal)
		self.button.setBackgroundImage(highlightedImage, for: .highlighted)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		
		if self.contentView.alpha != 1 {
			return
		}
		
		
		let animationDuration: TimeInterval = highlighted ? 0.0 : 0.1
		
		UIView.animate(withDuration: animationDuration, animations: {
			if highlighted {
				self.contentView.backgroundColor = UIColor.secondaryColor
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
