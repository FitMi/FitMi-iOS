//
//  FMGoalSettingViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 25/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMGoalSettingViewController: FMViewController {

	fileprivate var steps = 0
	fileprivate var meters = 0
	fileprivate var floors = 0
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let healthManager = FMHealthStatusManager.sharedManager
		
		let highlightImage = UIImage.fromColor(color: UIColor.activeColor)
		
		let prefs = UserDefaults.standard
		
		let steps = healthManager.goalForSteps()
		let selectedStepGoal = prefs.integer(forKey: GOAL_NEXT_STEPS)
		if let button = self.view.viewWithTag(steps / 5000 - 1 + 30) as? UIButton {
			if selectedStepGoal != 0 {
				if let tmrGoalButton = self.view.viewWithTag(selectedStepGoal / 5000 - 1 + 30) as? UIButton {
					tmrGoalButton.isSelected = true
				}
			} else {
				button.isSelected = true
			}
			button.setBackgroundImage(highlightImage, for: .normal)
		}
		
		let meters = healthManager.goalForDistance()
		let selectedMeterGoal = prefs.integer(forKey: GOAL_NEXT_DISTANCE)
		if let button = self.view.viewWithTag(meters / 2500 - 1 + 10) as? UIButton {
			if selectedMeterGoal != 0 {
				if let tmrGoalButton = self.view.viewWithTag(selectedMeterGoal / 2500 - 1 + 10) as? UIButton {
					tmrGoalButton.isSelected = true
				}
			} else {
				button.isSelected = true
			}
			button.setBackgroundImage(highlightImage, for: .normal)
		}
		
		let floors = healthManager.goalForFlights()
		let selectedFloorGoal = prefs.integer(forKey: GOAL_NEXT_FLIGHTS)
		if let button = self.view.viewWithTag(floors / 5 - 1 + 20) as? UIButton {
			if selectedMeterGoal != 0 {
				if let tmrGoalButton = self.view.viewWithTag(selectedFloorGoal / 5 - 1 + 20) as? UIButton {
					tmrGoalButton.isSelected = true
				}
			} else {
				button.isSelected = true
			}
			button.setBackgroundImage(highlightImage, for: .normal)
		}
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func stepsButtonDidClick(sender: UIButton) {
		steps = (sender.tag % 10 + 1) * 5000
		for i in 0..<6 {
			if let button = self.view.viewWithTag(i + 30) as? UIButton {
				button.isSelected = false
			}
		}
		
		sender.isSelected = true
		UserDefaults.standard.set(steps, forKey: GOAL_NEXT_STEPS)
		UserDefaults.standard.set("\(Date().timeIntervalSince1970)", forKey: GOAL_SET_DATE_STEPS)
	}
	
	@IBAction func metersButtonDidClick(sender: UIButton) {
		meters = (sender.tag % 10 + 1) * 2500
		
		for i in 0..<6 {
			if let button = self.view.viewWithTag(i + 10) as? UIButton {
				button.isSelected = false
			}
		}
		
		sender.isSelected = true
		UserDefaults.standard.set(meters, forKey: GOAL_NEXT_DISTANCE)
		UserDefaults.standard.set("\(Date().timeIntervalSince1970)", forKey: GOAL_SET_DATE_DISTANCE)
	}
	
	@IBAction func floorsButtonDidClick(sender: UIButton) {
		floors = (sender.tag % 10 + 1) * 5
		
		for i in 0..<6 {
			if let button = self.view.viewWithTag(i + 20) as? UIButton {
				button.isSelected = false
			}
		}
		
		sender.isSelected = true
		UserDefaults.standard.set(floors, forKey: GOAL_NEXT_FLIGHTS)
		UserDefaults.standard.set("\(Date().timeIntervalSince1970)", forKey: GOAL_SET_DATE_FLIGHTS)
	}

	class func controllerFromStoryboard() -> FMGoalSettingViewController {
		let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "FMGoalSettingViewController") as! FMGoalSettingViewController
		return controller
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
