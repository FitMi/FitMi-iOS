//
//  FMRootViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import BubbleTransition

class FMRootViewController: FMViewController {

	static var defaultController: FMRootViewController!
	
	@IBOutlet weak var menuButton: UIButton!
	
	let transition = BubbleTransition()
	let healthStatusManager = FMHealthStatusManager.sharedManager
	
	override func loadView() {
		super.loadView()
		
		FMRootViewController.defaultController = self
		
		let homeViewController = FMHomeViewController.getDefaultController()
		self.view.addSubview(homeViewController.view)
		self.view.sendSubview(toBack: homeViewController.view)
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[homeView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["homeView": homeViewController.view]))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[homeView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["homeView": homeViewController.view]))
		homeViewController.view.isHidden = false
		
		let exerciseViewController = FMExerciseViewController.getDefaultController()
		self.view.addSubview(exerciseViewController.view)
		self.view.sendSubview(toBack: exerciseViewController.view)
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[exerciseView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["exerciseView": exerciseViewController.view]))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[exerciseView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["exerciseView": exerciseViewController.view]))
		exerciseViewController.view.isHidden = true
		
		let statisticsViewController = FMStatisticsViewController.getDefaultController()
		self.view.addSubview(statisticsViewController.view)
		self.view.sendSubview(toBack: statisticsViewController.view)
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[statisticsView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["statisticsView": statisticsViewController.view]))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[statisticsView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["statisticsView": statisticsViewController.view]))
		statisticsViewController.view.isHidden = true
		
		let accountViewController = FMAccountViewController.getDefaultController()
		self.view.addSubview(accountViewController.view)
		self.view.sendSubview(toBack: accountViewController.view)
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[accountView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["accountView": accountViewController.view]))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[accountView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["accountView": accountViewController.view]))
		accountViewController.view.isHidden = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}

extension FMRootViewController: UIViewControllerTransitioningDelegate {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let controller = segue.destination
		transition.duration = 0.2
		controller.transitioningDelegate = self
		controller.modalPresentationStyle = .custom
	}
	
	// MARK: UIViewControllerTransitioningDelegate
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .present
		transition.startingPoint = menuButton.center
		transition.bubbleColor = UIColor.primaryColor
		return transition
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .dismiss
		transition.startingPoint = menuButton.center
		transition.bubbleColor = UIColor.primaryColor
		return transition
	}
}
