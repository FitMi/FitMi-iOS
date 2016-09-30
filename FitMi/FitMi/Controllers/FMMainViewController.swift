//
//  FMMainViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import BubbleTransition

class FMMainViewController: FMViewController {

	@IBOutlet weak var spriteView: SKView!
	@IBOutlet weak var menuButton: UIButton!
	
	let transition = BubbleTransition()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let scene = SKScene(fileNamed: "FMMainScene") {
			scene.scaleMode = .aspectFill
			self.spriteView.presentScene(scene)
		}
		
		self.spriteView.ignoresSiblingOrder = true
		self.spriteView.showsFPS = true
		self.spriteView.showsNodeCount = true
	}
	
	override var shouldAutorotate: Bool {
		return true
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .allButUpsideDown
		} else {
			return .all
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}

}

extension FMMainViewController: UIViewControllerTransitioningDelegate {
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
