//
//  FMMainViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMMainViewController: FMViewController {

	@IBOutlet var spriteView: SKView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Load the SKScene from 'GameScene.sks'
		if let scene = SKScene(fileNamed: "GameScene") {
			// Set the scale mode to scale to fit the window
			scene.scaleMode = .aspectFill
			
			// Present the scene
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
