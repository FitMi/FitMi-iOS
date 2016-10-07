//
//  FMChartTableViewCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 8/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import Charts

class FMChartTableViewCell: UITableViewCell {

	static let identifier = "FMChartTableViewCell"
	
	@IBOutlet var cardView: UIView!
	@IBOutlet var chartView: BarChartView!
	
	private var dates = [Date]()
	private var values = [Int]()
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.setCardViewStyle()
		self.configureChartView()
		self.setChartData(values: [1, 4, 3, 5, 3, 6, 2], dates: [Date(), Date(), Date(), Date(), Date(), Date(), Date()])
    }
	
	func setCardViewStyle() {
		let layer = self.cardView.layer
		layer.cornerRadius = 10
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize.zero
		layer.shadowRadius = 3
		layer.shadowOpacity = 0.1
	}
	
	func setChartData(values: [Int], dates: [Date]) {
		self.dates = dates
		self.values = values
		var dataEntries = [ChartDataEntry]()
		for i in 0..<dates.count {
			let dataEntry = BarChartDataEntry(x: Double(i), yValues: [Double(values[i])], label: "\(dates[i])")
			dataEntries.append(dataEntry)
		}
		
		
		let dataSet = BarChartDataSet(values: dataEntries, label: "")
		dataSet.colors = ChartColorTemplates.joyful()
		let data = BarChartData(dataSet: dataSet)
		data.barWidth = 0.1
		chartView.data = data
	}
	
	func configureChartView() {
		chartView.noDataTextColor = UIColor.white
		chartView.noDataText = "NO DATA AVAILABLE"
		chartView.chartDescription = nil
		chartView.dragEnabled = false
		chartView.setScaleEnabled(false)
		chartView.pinchZoomEnabled = false
		chartView.doubleTapToZoomEnabled = false
		chartView.drawGridBackgroundEnabled = false
		chartView.drawBordersEnabled = false
		chartView.xAxis.labelPosition = .bottom
		chartView.xAxis.drawGridLinesEnabled = false
		chartView.xAxis.drawAxisLineEnabled = false
		chartView.xAxis.axisMinimum = -0.05
		chartView.xAxis.axisMaximum = 6.05
		chartView.leftAxis.drawGridLinesEnabled = false
		chartView.leftAxis.drawLabelsEnabled = false
		chartView.leftAxis.drawAxisLineEnabled = false
		chartView.rightAxis.drawGridLinesEnabled = false
		chartView.rightAxis.drawLabelsEnabled = false
		chartView.rightAxis.drawAxisLineEnabled = false
		chartView.drawMarkers = false
		chartView.legend.enabled = false
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMChartTableViewCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
    
}
