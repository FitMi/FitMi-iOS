//
//  FMAccountViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class FMAccountViewController: FMViewController {

	private static var defaultController: FMAccountViewController?
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if FMAccountViewController.defaultController == nil {
			FMAccountViewController.defaultController = self
		}
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	class func getDefaultController() -> FMAccountViewController {
		if FMAccountViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMAccountViewController") as! FMAccountViewController
			FMAccountViewController.defaultController = controller
		}
		
		return FMAccountViewController.defaultController!
	}
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        FMRootViewController.defaultController.addChildViewController(self)
    }
    
    override func willMoveAway(fromParentViewController parent: UIViewController?) {
        super.willMoveAway(fromParentViewController: parent)
        self.removeFromParentViewController()
    }
    
    @IBAction func facebookLoginDidClick(sender: AnyObject?) {
//        FMRootViewController.defaultController.facebookLoginButton
    }

}
