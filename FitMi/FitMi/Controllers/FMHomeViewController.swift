//
//  FMHomeViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMHomeViewController: FMViewController {

	@IBOutlet weak var spriteView: SKView!
	
	private static var defaultController: FMHomeViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if FMHomeViewController.defaultController == nil {
			FMHomeViewController.defaultController = self
		}
		
		if let scene = SKScene(fileNamed: "FMMainScene") {
			scene.scaleMode = .aspectFill
			self.spriteView.presentScene(scene)
		}
		
		self.spriteView.ignoresSiblingOrder = true
		self.spriteView.showsFPS = true
		self.spriteView.showsNodeCount = true
	}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	class func getDefaultController() -> FMHomeViewController {
		if FMHomeViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMHomeViewController") as! FMHomeViewController
			FMHomeViewController.defaultController = controller
		}
		
		return FMHomeViewController.defaultController!
	}

}
