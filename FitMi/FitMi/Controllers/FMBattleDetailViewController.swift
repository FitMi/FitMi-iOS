//
//  FMBattleDetailViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 21/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import SwiftyJSON

class FMBattleDetailViewController: FMViewController {

	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var escapeButton: UIButton!
	@IBOutlet var battleView: UIView!
	@IBOutlet var primaryImageView: UIImageView!
	@IBOutlet var secondaryImageView: UIImageView!
	
	var opponentID = ""
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.configureImageView()
		
		self.loadOpponentData(completion: {
			json in
			if let _ = json {
				self.activityIndicator.stopAnimating()
				self.battleView.isUserInteractionEnabled = true
				UIView.animate(withDuration: 0.5, animations: {
					self.battleView.alpha = 1
				})
			}
		})
    }
	
	private func configureImageView() {
		self.primaryImageView.animationDuration = 1
		self.primaryImageView.animationRepeatCount = 3
		
		self.secondaryImageView.animationDuration = 1
		self.secondaryImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
		self.secondaryImageView.animationRepeatCount = 3
	}
	
	fileprivate func loadOpponentData(completion: @escaping ((_ data: JSON?) -> Void)) {
		let data = self.loadFake()
		
		DispatchQueue(label: "any").asyncAfter(deadline: .now() + 0.5, execute: {
			DispatchQueue.main.async {
				completion(data)
			}
		})
	}
	
	fileprivate func loadFake() -> JSON {
		let str = "{\"_id\": \"object ID\",\"username\": \"username\",\"spritename\": \"sprite name\",\"facebookToken\": \"Facebook access token\",\"facebookId\": \"Facebook ID\",\"__v\": 0,\"strength\": 200,\"stamina\": 132,\"agility\": 123,\"health\": 190,\"level\": 14,\"skillInUse\": [\"skill-D4D534EE-297B-42C3-B8CA-77906414B14B\", \"skill-56AC9D4A-BAF2-46EA-A5DD-785799D51FDE\"],\"updatedAt\": \"2016-10-20T15:12:08.240Z\",\"lastCombatTime\": \"2016-10-20T15:12:08.240Z\",\"createdAt\": \"2016-10-20T15:12:08.240Z\"}"
		return JSON.parse(str)
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
