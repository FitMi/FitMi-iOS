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
	private let viewControllers = [FMHomeViewController.getDefaultController(), FMExerciseViewController.getDefaultController()]
	
	override func viewDidLoad() {
		closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
	}
	
	@IBAction func closeAction(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func didSelectPage(button: UIButton) {
		var hidden = [Bool]()
		switch button.tag {
		case 0:
			hidden = [false, true]
		case 1:
			hidden = [true, false]
		default:
			print("Button action is not implemented.")
		}
		
		for i in 0..<viewControllers.count {
			viewControllers[i].view.isHidden = hidden[i]
		}
		
		self.closeAction(button)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
}
