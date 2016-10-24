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
	@IBOutlet var radarChartCaption: UILabel!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureChart()
		self.setChartData()
		
		self.configureViewAppearance()
    }
	
	fileprivate func configureViewAppearance() {
		do {
			let layer = radarChartCaption.superview!.layer
			layer.borderWidth = 5
			layer.borderColor = UIColor.primaryColor.cgColor
		}
		
		do {
			let layer = radarChartView.superview!.layer
			layer.borderWidth = 5
			layer.borderColor = UIColor.primaryColor.cgColor
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	fileprivate func setChartData() {
		var dataEntries = [RadarChartDataEntry]()
		
		let manager = FMSpriteStatusManager.sharedManager
		
		
		let levelEntry = RadarChartDataEntry(value: Double(manager.currentLevel() * 25))
		levelEntry.data = "LEVEL" as AnyObject?
		dataEntries.append(levelEntry)
		
		let healthEntry = RadarChartDataEntry(value: Double(manager.currentHP()))
		healthEntry.data = "HEALTH" as AnyObject?
		dataEntries.append(healthEntry)
		
		let strengthEntry = RadarChartDataEntry(value: Double(manager.currentStrength()))
		strengthEntry.data = "STRENGTH" as AnyObject?
		dataEntries.append(strengthEntry)
		
		let staminaEntry = RadarChartDataEntry(value: Double(manager.currentStamina()))
		staminaEntry.data = "STAMINA" as AnyObject?
		dataEntries.append(staminaEntry)
		
		let agilityEntry = RadarChartDataEntry(value: Double(manager.currentAgility()))
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
		
		chart.delegate = self
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
			return "\(Int(value/25))"
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

extension FMSpriteStatsViewController: ChartViewDelegate {
	func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
		let key = entry.data as! String
		switch key {
		case "LEVEL":
			self.radarChartCaption.text = "Higher levels give you higher health limits and more skill slots during battles. \n\nYou can level up when getting enough experience from exercises."
			
		case "HEALTH":
			self.radarChartCaption.text = "Higher health makes you less easier to lose a battle. \n\nHealth depends on how much you accomplish your exercise goals in the past 7 days."
			
		case "STRENGTH":
			self.radarChartCaption.text = "Strength determines the damage of your moves to your opponent during battles. \n\nStrength is calculated from the accumulated steps you have walked."
			
		case "STAMINA":
			self.radarChartCaption.text = "Stamina determines how much you can recover your health when using certain skills in a battle. \n\nStamina is calculated from the accumulated distance you have walked."
			
		case "AGILITY":
			self.radarChartCaption.text = "Agility determines how fast you can cool down after using a skill. \n\nAgility is calculated from the accumulated floors you have climbed."
			
		default:
			self.radarChartCaption.text = "Click any of the value above to view an explanation."
		}
	}
}
