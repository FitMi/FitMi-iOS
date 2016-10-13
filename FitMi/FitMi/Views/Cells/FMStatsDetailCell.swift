//
//  FMStatsDetailCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 13/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMStatsDetailCell: UITableViewCell {

	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var stepsLabel: UILabel!
	@IBOutlet var distanceLabel: UILabel!
	@IBOutlet var floorsLabel: UILabel!
	
	fileprivate static var dateFormatter: DateFormatter!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		if FMStatsDetailCell.dateFormatter == nil {
			FMStatsDetailCell.dateFormatter = DateFormatter()
			FMStatsDetailCell.dateFormatter.dateFormat = "YYYY-MM-dd"
		}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(withState state: FMSpriteState) {
		self.dateLabel.text = FMStatsDetailCell.dateFormatter.string(from: state.date)
		self.stepsLabel.text = "\(state.stepCount)"
		self.distanceLabel.text = "\(state.distance)"
		self.floorsLabel.text = "\(state.flightsClimbed)"
		self.setNeedsUpdateConstraints()
	}
	
	static let identifier = "FMStatsDetailCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMStatsDetailCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
