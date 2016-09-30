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
	private var nextViewController: FMViewController?
	
	override func viewDidLoad() {
		closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.nextViewController = nil
	}
	
	@IBAction func closeAction(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func didSelectPage(button: UIButton) {
		switch button.tag {
		case 0:
			self.nextViewController = FMMainViewController.getDefaultController()
		case 1:
			self.nextViewController = FMExerciseViewController.getDefaultController()
		default:
			print("Button action is not implemented.")
		}
		
		self.closeAction(button)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if let presentingViewController = self.presentingViewController {
			if let controller = self.nextViewController {
				if controller != presentingViewController {
					UIApplication.shared.delegate?.window??.rootViewController = controller
					UIApplication.shared.delegate?.window??.sendSubview(toBack: controller.view)
				}
			}
		}
	}
}
