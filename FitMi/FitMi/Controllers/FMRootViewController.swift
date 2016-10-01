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

	@IBOutlet weak var menuButton: UIButton!
	let transition = BubbleTransition()
	
	override func loadView() {
		super.loadView()
		
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
		transition.bubbleColor = FMColorManager.primaryColor
		return transition
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .dismiss
		transition.startingPoint = menuButton.center
		transition.bubbleColor = FMColorManager.primaryColor
		return transition
	}
}
