//
//  FMMiddleAlignedLabelCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 13/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMMiddleAlignedLabelCell: UITableViewCell {

	static let identifier = "FMMiddleAlignedLabelCell"
	
	@IBOutlet var label: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		
		let animationDuration: TimeInterval = 0.2
		
		UIView.animate(withDuration: animationDuration, animations: {
			if highlighted {
				self.label.alpha = 0.2
			} else {
				self.label.alpha = 1
			}
		})
	}
	
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMMiddleAlignedLabelCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
    
}
