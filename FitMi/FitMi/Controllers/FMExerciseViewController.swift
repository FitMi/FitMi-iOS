//
//  FMExerciseViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMExerciseViewController: FMViewController {

	private static var defaultController: FMExerciseViewController?
	
	@IBOutlet var statusPanelView: UIView!
	@IBOutlet var statusPanelTitleContainer: UIView!
	@IBOutlet var statusPanelTitleLabel: UILabel!
	@IBOutlet var spriteView: SKView!
	
	override func loadView() {
		super.loadView()
		
		self.view.backgroundColor = UIColor.secondaryColor
		
		
		do {
			self.statusPanelView.backgroundColor = UIColor.white
			let layer = self.statusPanelView.layer
			layer.borderWidth = 3
			layer.borderColor = UIColor.black.cgColor
		}
		
		do {
			self.statusPanelTitleContainer.backgroundColor = UIColor.white
			let layer = self.statusPanelTitleContainer.layer
			layer.borderWidth = 3
			layer.borderColor = UIColor.black.cgColor
		}
		
		do {
			if let scene = SKScene(fileNamed: "FMMainScene") {
				scene.scaleMode = .aspectFill
				self.spriteView.presentScene(scene)
			}
			
			self.spriteView.ignoresSiblingOrder = true
		}
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if FMExerciseViewController.defaultController == nil {
			FMExerciseViewController.defaultController = self
		}
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	class func getDefaultController() -> FMExerciseViewController {
		if FMExerciseViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMExerciseViewController") as! FMExerciseViewController
			FMExerciseViewController.defaultController = controller
		}
		
		return FMExerciseViewController.defaultController!
	}

	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
	}
	
	override func willMoveAway(fromParentViewController parent: UIViewController?) {
	}
}
