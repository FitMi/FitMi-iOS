//
//  FMWorkoutHistoryCell.swift
//  FitMi
//
//  Created by Jiang Sheng on 14/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMWorkoutHistoryCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var floorsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    fileprivate static var dateFormatter: DateFormatter!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if FMWorkoutHistoryCell.dateFormatter == nil {
            FMWorkoutHistoryCell.dateFormatter = DateFormatter()
            FMWorkoutHistoryCell.dateFormatter.dateFormat = "YYYY-MM-dd"
        }
    }
    
    func configureCell(withExercise record: FMExerciseRecord) {
        self.dateLabel.text = FMWorkoutHistoryCell.dateFormatter.string(from: record.startTime)
        self.stepsLabel.text = "\(record.steps)"
        self.distanceLabel.text = "\(record.distance)"
        self.floorsLabel.text = "\(record.flights)"
        let total = self.getIntervalSeconds(from: record.startTime, to: record.endTime)
        let hours = total / 3600
        let minutes = total / 60
        let seconds = total % 60
        self.timeLabel.text = "\(hours)h\(minutes)m\(seconds)m"
        self.setNeedsUpdateConstraints()
    }
    
    func getIntervalSeconds(from: Date, to:Date) -> Int {
        return Calendar.current.dateComponents([.second], from: from, to: to).second ?? 0
    }
    
    static let identifier = "FMWorkoutHistoryCell"
    class func registerCell(tableView: UITableView, reuseIdentifier: String) {
        let nib = UINib(nibName: "FMWorkoutHistoryCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}
