//
//  FMMainViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMMainViewController: FMViewController {

	static var defaultController: FMMainViewController?
	
	@IBOutlet weak var spriteView: SKView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if FMMainViewController.defaultController == nil {
			FMMainViewController.defaultController = self
		}
		
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

	class func getDefaultController() -> FMMainViewController {
		if FMMainViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMMainViewController") as! FMMainViewController
			FMMainViewController.defaultController = controller
		}
		
		return FMMainViewController.defaultController!
	}
}
