//
//  FMFriendListCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 21/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMFriendListCell: UITableViewCell {

	@IBOutlet var levelLabel: UILabel!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var avatarImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		let layer = self.avatarImageView.layer
		layer.borderColor = UIColor.white.cgColor
		layer.borderWidth = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
//		let animationDuration: TimeInterval = highlighted ? 0.0 : 0.1
//		UIView.animate(withDuration: animationDuration, animations: {
//			if highlighted {
//				
//			} else {
//				
//			}
//		})
	}

	
	static let identifier = "FMFriendListCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMFriendListCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
