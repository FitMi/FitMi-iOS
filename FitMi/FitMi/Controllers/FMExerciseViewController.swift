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

}
