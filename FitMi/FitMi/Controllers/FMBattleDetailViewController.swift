//
//  FMBattleDetailViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 21/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMBattleDetailViewController: FMViewController {

	var opponentID = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		FMNotificationManager.sharedManager.showStandardFeedbackMessage(text: self.opponentID)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
