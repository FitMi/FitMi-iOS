//
//  FMLevelCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 5/11/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMLevelCell: UITableViewCell {

	@IBOutlet var levelLabel: UILabel!
	@IBOutlet var skillsLabel: UILabel!
	@IBOutlet var healthLabel: UILabel!
	@IBOutlet var expLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	static let identifier = "FMLevelCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMLevelCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
