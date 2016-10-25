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
	}
	
	@IBAction func metersButtonDidClick(sender: UIButton) {
		meters = (sender.tag % 10 + 1) * 2500
		
		for i in 0..<6 {
			if let button = self.view.viewWithTag(i + 10) as? UIButton {
				button.isSelected = false
			}
		}
		
		sender.isSelected = true
	}
	
	@IBAction func floorsButtonDidClick(sender: UIButton) {
		floors = (sender.tag % 10 + 1) * 5
		
		for i in 0..<6 {
			if let button = self.view.viewWithTag(i + 20) as? UIButton {
				button.isSelected = false
			}
		}
		
		sender.isSelected = true
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
