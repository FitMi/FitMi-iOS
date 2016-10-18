//
//  ViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMViewController: UIViewController {
	
	@IBOutlet weak var toolBar: UIView!
	@IBOutlet weak var topBar: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		if self.toolBar != nil {
			self.toolBar.backgroundColor = UIColor.primaryColor
		}
		
		if self.topBar != nil {
			self.topBar.backgroundColor = UIColor.primaryColor
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func willMoveAway(fromParentViewController parent: UIViewController?) {
		
	}
	
	@IBAction func dismiss() {
		self.dismiss(animated: true, completion: nil)
	}
}
