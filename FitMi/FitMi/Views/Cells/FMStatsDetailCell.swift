//
//  FMStatsDetailCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 13/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMStatsDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	static let identifier = "FMStatsDetailCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMStatsDetailCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
