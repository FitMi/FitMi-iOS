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
	private var controller: FMViewController?
	
	override func viewDidLoad() {
		closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
	}
	
	@IBAction func closeAction(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		if let _ = self.presentingViewController {
			if let controller = self.controller {
				UIApplication.shared.delegate?.window??.rootViewController = controller
				UIApplication.shared.delegate?.window??.sendSubview(toBack: controller.view)
			}
		}
	}

}
