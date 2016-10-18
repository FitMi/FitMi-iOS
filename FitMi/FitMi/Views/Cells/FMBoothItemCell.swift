//
//  FMBoothItemCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 19/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMBoothItemCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	static let identifier = "FMBoothItemCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMBoothItemCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
