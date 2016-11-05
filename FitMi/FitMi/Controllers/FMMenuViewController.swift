//
//  FMMenuViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import GameKit

class FMMenuViewController: FMViewController {

	@IBOutlet weak var closeButton: UIButton!
	private let viewControllers = [FMHomeViewController.getDefaultController(), FMExerciseViewController.getDefaultController(), FMBattleViewController.getDefaultController(), FMStatisticsViewController.getDefaultController(), FMAccountViewController.getDefaultController()]
	
	override func loadView() {
		super.loadView()
		closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
		self.view.backgroundColor = UIColor.primaryColor
		self.closeButton.setTitleColor(UIColor.primaryColor, for: .normal)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
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
	
	@IBAction func showGameCenterViewController(button: UIButton) {
        if !FMGameCenterManager.sharedManager.isGameCenterAuthenticated() {
            FMNotificationManager.sharedManager.showStandardFeedbackMessage(text: "Game Center Not Logged In")
        } else {
            // show Game center
            let gameCenterVc = GKGameCenterViewController()
            gameCenterVc.gameCenterDelegate = self
            gameCenterVc.viewState = .default
            
            self.present(gameCenterVc, animated: true, completion: nil)
        }
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


extension FMMenuViewController: GKGameCenterControllerDelegate {
	func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
		gameCenterViewController.dismiss(animated: true, completion: nil)
	}
}
