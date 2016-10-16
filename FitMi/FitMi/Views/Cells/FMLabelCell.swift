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
	
	var highlightEnabled: Bool = true
	
    override func awakeFromNib() {
        super.awakeFromNib()
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
