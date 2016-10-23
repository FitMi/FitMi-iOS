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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	fileprivate func setChartData() {
		let data = RadarChartData()
	}
	
	fileprivate func configureChart() {
		let chart = self.radarChartView!
		
		chart.noDataText = "NO DATA AVAILABLE"
		chart.noDataFont = UIFont(name: "Pokemon Pixel Font", size: 20)
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
