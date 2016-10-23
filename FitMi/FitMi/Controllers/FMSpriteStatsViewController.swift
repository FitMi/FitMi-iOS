//
//  FMSpriteStatsViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 24/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import Charts

class FMSpriteStatsViewController: FMViewController {

	@IBOutlet var radarChartView: RadarChartView!
	@IBOutlet var spriteImageView: UIImageView!
	@IBOutlet var skillInUseButton: UIButton!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureChart()
		self.setChartData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	fileprivate func setChartData() {
		var dataEntries = [RadarChartDataEntry]()
		
		let levelEntry = RadarChartDataEntry(value: 280)
		levelEntry.data = "LEVEL" as AnyObject?
		dataEntries.append(levelEntry)
		
		let healthEntry = RadarChartDataEntry(value: 312)
		healthEntry.data = "HEALTH" as AnyObject?
		dataEntries.append(healthEntry)
		
		let strengthEntry = RadarChartDataEntry(value: 245)
		strengthEntry.data = "STRENGTH" as AnyObject?
		dataEntries.append(strengthEntry)
		
		let staminaEntry = RadarChartDataEntry(value: 232)
		staminaEntry.data = "STAMINA" as AnyObject?
		dataEntries.append(staminaEntry)
		
		let agilityEntry = RadarChartDataEntry(value: 322)
		agilityEntry.data = "AGILITY" as AnyObject?
		dataEntries.append(agilityEntry)
		
		let dataSet = RadarChartDataSet(values: dataEntries, label: "")
		dataSet.fillColor = UIColor.primaryColor
		dataSet.lineWidth = 3
		dataSet.drawFilledEnabled = true
		dataSet.drawVerticalHighlightIndicatorEnabled = false
		dataSet.drawHorizontalHighlightIndicatorEnabled = false
		dataSet.valueFont = UIFont(name: "Pixeled", size: 6)!
		dataSet.valueFormatter = self
		dataSet.valueColors = [UIColor.darkGray]
		dataSet.setColor(UIColor.primaryColor)
		
		let data = RadarChartData(dataSet: dataSet)
		
		self.radarChartView.data = data
	}
	
	fileprivate func configureChart() {
		let chart = self.radarChartView!
		chart.backgroundColor = UIColor.clear
		
		chart.noDataText = "NO DATA AVAILABLE"
		chart.noDataFont = UIFont(name: "Pokemon Pixel Font", size: 20)
		
		chart.chartDescription = nil
		chart.drawMarkers = false
		
		chart.legend.enabled = false
		
		chart.xAxis.valueFormatter = self
		chart.xAxis.labelFont = UIFont(name: "Pixeled", size: 8)!
		chart.xAxis.labelPosition = .bothSided
		chart.xAxis.labelTextColor = UIColor.primaryColor
		chart.xAxis.axisMinimum = 0
		chart.xAxis.drawGridLinesEnabled = false
		chart.xAxis.drawAxisLineEnabled = true
		
		chart.yAxis.drawLabelsEnabled = false
		chart.yAxis.setLabelCount(1, force: true)
		chart.yAxis.labelTextColor = UIColor.primaryColor
		chart.yAxis.axisMinimum = 0
		chart.yAxis.drawAxisLineEnabled = true
		chart.yAxis.spaceTop = 0.4
		
		chart.rotationAngle = 190
		chart.innerWebLineWidth = 0.2
		chart.webLineWidth = 0.2
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	class func controllerFromStoryboard() -> FMSpriteStatsViewController {
		let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "FMSpriteStatsViewController") as! FMSpriteStatsViewController
		controller.modalTransitionStyle = .coverVertical
		return controller
	}
}

extension FMSpriteStatsViewController: IValueFormatter, IAxisValueFormatter {
	func stringForValue(_ value: Double,
	                    entry: ChartDataEntry,
	                    dataSetIndex: Int,
	                    viewPortHandler: ViewPortHandler?) -> String {
		let key = entry.data as! String
		if key == "LEVEL" {
			return "\(Int(value/20))"
		}
		return "\(Int(value))"
	}
	
	func stringForValue(_ value: Double,
	                    axis: AxisBase?) -> String {
		switch value {
		case 0:
			return "LEVEL"
		case 1:
			return "HEALTH"
		case 2:
			return "STRENGTH"
		case 3:
			return "STAMINA"
		case 4:
			return "AGILITY"
		default:
			return ""
		}
	}
}
