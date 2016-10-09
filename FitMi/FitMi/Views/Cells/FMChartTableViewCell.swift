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
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	
	enum StateDataType {
		case health
		case strength
		case stamina
		case agility
	}
	
	var states = [FMSpriteState?]()
	var type: StateDataType = .health
	var dateFormatter: DateFormatter!
	var labelDateFormatter: DateFormatter!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = UIColor.secondaryColor
		self.setCardViewStyle()
		self.configureChartView()
		
		self.dateFormatter = DateFormatter()
		self.dateFormatter.dateFormat = "MM-dd"
		
		self.labelDateFormatter = DateFormatter()
		self.labelDateFormatter.dateFormat = "dd, MMMM"
    }
	
	func setCardViewStyle() {
		let layer = self.cardView.layer
		layer.borderWidth = 5
		layer.borderColor = UIColor.primaryColor.cgColor
	}
	
	func setChartData(states: [FMSpriteState?], type: StateDataType) {
		self.states = states
		self.type = type
		
		self.dateLabel.text = ""
		if states.count > 1 {
			for i in 0..<states.count - 1 {
				if let value = states[i] {
					self.dateLabel.text = "\(self.labelDateFormatter.string(from: value.date)) - TODAY".uppercased()
					break
				}
			}
		}
		
		var dataEntries = [ChartDataEntry]()
		for i in 0..<states.count {
			var values: [Double]
			switch type {
			case .strength:
				values = [Double(states[i] == nil ? 0 : states[i]!.strength)]
			case .stamina:
				values = [Double(states[i] == nil ? 0 : states[i]!.stamina)]
			case .agility:
				values = [Double(states[i] == nil ? 0 : states[i]!.agility)]
			default:
				values = [Double(states[i] == nil ? 0 : states[i]!.health)]
			}
			let dataEntry = BarChartDataEntry(x: Double(i), yValues: values, label: "")
			dataEntries.append(dataEntry)
		}
		
		
		let dataSet = BarChartDataSet(values: dataEntries, label: "")
		dataSet.colors = ChartColorTemplates.joyful()
		dataSet.valueFont = UIFont(name: "Pixeled", size: 6)!
		dataSet.valueFormatter = self
		let data = BarChartData(dataSet: dataSet)
		data.barWidth = 0.3
		chartView.data = data
		chartView.animate(yAxisDuration: 1, easingOption: .easeInBounce)
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
		chartView.xAxis.axisMinimum = -0.2
		chartView.xAxis.axisMaximum = 6.2
		chartView.xAxis.valueFormatter = self
		chartView.xAxis.labelFont = UIFont(name: "Pixeled", size: 6)!
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

extension FMChartTableViewCell: IAxisValueFormatter, IValueFormatter {
	func stringForValue(_ value: Double,
	                    axis: AxisBase?) -> String {
		let index = Int(value)
		if index < self.states.count {
			if let state = self.states[Int(value)] {
				return self.dateFormatter.string(from: state.date).uppercased()
			} else {
				return "-"
			}
		} else {
			return "-"
		}
	}
	
	func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
		return value == 0 ? "" :"\(Int(value))"
	}
}
