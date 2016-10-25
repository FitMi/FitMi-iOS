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

	@IBOutlet var cardView: UIView!
	@IBOutlet var cardViewLayoutY: NSLayoutConstraint!
	
    var currentState = FMSpriteState()
	
	override func loadView() {
		super.loadView()
		self.cardViewLayoutY.constant = UIScreen.main.bounds.height
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.configureGoalView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		self.setCardViewStyle()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.animateCardViewIn()
	}
	
	func configureGoalView() {
		let distance = self.currentState.distance
		let distanceGoal = self.currentState.distanceGoal
		let step = self.currentState.stepCount
		let stepGoal = self.currentState.stepGoal
		let flight = self.currentState.flightsClimbed
		let flightGoal = self.currentState.flightsGoal
		
		self.distanceProgressView.setProgress(0, animated: false)
		self.stepProgressView.setProgress(0, animated: false)
		self.flightProgressView.setProgress(0, animated: false)
		
		self.distanceProgressLabel.text = "\(distance) / \(distanceGoal)   METERS"
		self.stepProgressLabel.text = "\(step) / \(stepGoal)   STEPS"
		self.flightProgressLabel.text = "\(flight) / \(flightGoal)   FLOORS"
	}
	
    func displayGoalDisplay() {
        let distance = self.currentState.distance
        let distanceGoal = self.currentState.distanceGoal
        let step = self.currentState.stepCount
        let stepGoal = self.currentState.stepGoal
        let flight = self.currentState.flightsClimbed
        let flightGoal = self.currentState.flightsGoal
        
        let distanceProgress = Float(distance) / Float(distanceGoal)
        self.distanceProgressLabel.text = "\(distance) / \(distanceGoal)   METERS"
		self.distanceProgressView.setProgress(min(distanceProgress, 1), animated: true)
        
        let stepProgress = Float(step) / Float(stepGoal)
        self.stepProgressLabel.text = "\(step) / \(stepGoal)   STEPS"
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
			self.stepProgressView.setProgress(min(stepProgress, 1), animated: true)
		})
        
        let flightProgress = Float(flight) / Float(flightGoal)
        self.flightProgressLabel.text = "\(flight) / \(flightGoal)   FLOORS"
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
			self.flightProgressView.setProgress(min(flightProgress, 1), animated: true)
		})
		
    }
	
	func setCardViewStyle() {
		let layer = self.cardView.layer
		//		layer.shadowColor = UIColor.black.cgColor
		//		layer.shadowOffset = CGSize.zero
		//		layer.shadowRadius = 20
		//		layer.shadowOpacity = 0.3
		layer.borderWidth = 5
		layer.borderColor = UIColor.primaryColor.cgColor
	}
	
	func animateCardViewIn() {
		self.cardViewLayoutY.constant = UIScreen.main.bounds.height
		self.view.setNeedsLayout()
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
			self.cardViewLayoutY.constant = 0
			self.view.layoutIfNeeded()
		}, completion: {
			_ in
			
			self.displayGoalDisplay()
		})
	}
	
	@IBAction func animateCarViewOut() {
		self.cardViewLayoutY.constant = 0
		self.view.setNeedsLayout()
		self.dismiss(animated: true, completion: nil)
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
			self.cardViewLayoutY.constant = UIScreen.main.bounds.height
			self.view.layoutIfNeeded()
		}, completion: {
			_ in
			
		})
	}
	
    class func controllerFromStoryboard() -> FMGoalViewController {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FMGoalViewController") as! FMGoalViewController
        return controller
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
