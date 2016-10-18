//
//  FMBattleViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import RealmSwift

class FMBattleViewController: FMViewController {

	@IBOutlet var testImageViewLeft: UIImageView!
	@IBOutlet var testImageViewRight: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
	
	override func didMove(toParentViewController parent: UIViewController?) {
		super.didMove(toParentViewController: parent)
		
		let realm = try! Realm()
		let skill = realm.objects(FMSkill.self).first!
		let attackImages = skill.attackSprites()
		self.testImageViewLeft.image = attackImages.last
		self.testImageViewLeft.animationImages = attackImages
		self.testImageViewLeft.animationDuration = 1
		self.testImageViewLeft.animationRepeatCount = 3
		self.testImageViewLeft.startAnimating()
		
		let defenceImages = skill.defenceSprites()
		self.testImageViewRight.image = defenceImages.last
		self.testImageViewRight.animationImages = defenceImages
		self.testImageViewRight.animationDuration = 1
		self.testImageViewRight.transform = CGAffineTransform(scaleX: -1, y: 1)
		self.testImageViewRight.animationRepeatCount = 3
		self.testImageViewRight.startAnimating()
	}
	
	private static var defaultController: FMBattleViewController?
	class func getDefaultController() -> FMBattleViewController {
		if FMBattleViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMBattleViewController") as! FMBattleViewController
			FMBattleViewController.defaultController = controller
		}
		
		return FMBattleViewController.defaultController!
	}

}
