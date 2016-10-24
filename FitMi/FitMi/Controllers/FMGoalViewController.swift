//
//  FMGoalViewController.swift
//  FitMi
//
//  Created by Jiang Sheng on 24/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMGoalViewController: FMViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    class func controllerFromStoryboard() -> FMGoalViewController {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FMGoalViewController") as! FMGoalViewController
        controller.modalTransitionStyle = .coverVertical
        return controller
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
