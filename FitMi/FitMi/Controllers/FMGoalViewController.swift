//
//  FMGoalViewController.swift
//  FitMi
//
//  Created by Jiang Sheng on 24/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMGoalViewController: FMViewController {

    @IBOutlet var stepProgressView: UIProgressView!
    @IBOutlet var stepProgressLabel: UILabel!
    @IBOutlet var distanceProgressView: UIProgressView!
    @IBOutlet var distanceProgressLabel: UILabel!
    @IBOutlet var flightProgressView: UIProgressView!
    @IBOutlet var flightProgressLabel: UILabel!

    var currentState = FMSpriteState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayGoalDisplay()
    }
    
    func displayGoalDisplay() {
        let distance = self.currentState.distance
        let distanceGoal = self.currentState.distanceGoal
        let step = self.currentState.stepCount
        let stepGoal = self.currentState.stepGoal
        let flight = self.currentState.flightsClimbed
        let flightGoal = self.currentState.flightsGoal
        
        let distanceProgress = Float(distance) / Float(distanceGoal)
        self.distanceProgressView.setProgress(distanceProgress, animated: true)
        self.distanceProgressLabel.text = "\(distance) / \(distanceGoal)"
        
        let stepProgress = Float(step) / Float(stepGoal)
        self.stepProgressView.setProgress(stepProgress, animated: true)
        self.stepProgressLabel.text = "\(step) / \(stepGoal)"
        
        let flightProgress = Float(flight) / Float(flightGoal)
        self.flightProgressView.setProgress(flightProgress, animated: true)
        self.flightProgressLabel.text = "\(flight) / \(flightGoal)"
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
