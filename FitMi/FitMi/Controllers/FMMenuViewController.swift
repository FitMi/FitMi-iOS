//
//  FMMenuViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMMenuViewController: FMViewController {

	@IBOutlet weak var closeButton: UIButton!
	private let viewControllers = [FMHomeViewController.getDefaultController(), FMExerciseViewController.getDefaultController(), FMBattleViewController.getDefaultController(), FMStatisticsViewController.getDefaultController(), FMAccountViewController.getDefaultController()]
	
	override func viewDidLoad() {
		closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
		self.view.backgroundColor = UIColor.primaryColor
	}
	
	@IBAction func closeAction(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: {
			for i in 0..<self.viewControllers.count {
				if !self.viewControllers[i].view.isHidden {
					self.viewControllers[i].didMove(toParentViewController: nil)
				}
			}
		})
	}
	
	@IBAction func didSelectPage(button: UIButton) {
		var hidden = [true, true, true, true, true]
		hidden[button.tag] = false
		
		for i in 0..<self.viewControllers.count {
			if !self.viewControllers[i].view.isHidden {
				self.viewControllers[i].willMoveAway(fromParentViewController: nil)
			}
			self.viewControllers[i].view.isHidden = hidden[i]
			if !hidden[i] {
				self.viewControllers[i].willMove(toParentViewController: nil)
			}
		}
		
		self.closeAction(button)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
}
