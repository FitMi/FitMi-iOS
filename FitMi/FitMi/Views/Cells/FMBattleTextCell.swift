//
//  FMBattleTextCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 23/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMBattleTextCell: UITableViewCell {

	@IBOutlet var label: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	static let identifier = "FMBattleTextCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMBattleTextCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
	
	func setText(text: String) {
		self.label.text = text
	}
}
