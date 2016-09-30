//
//  ViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import BubbleTransition

class FMViewController: UIViewController {
	
	@IBOutlet weak var menuButton: UIButton!
	let transition = BubbleTransition()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

extension FMViewController: UIViewControllerTransitioningDelegate {
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
