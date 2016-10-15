//
//  FMHomeViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMHomeViewController: FMViewController {

    @IBOutlet weak var healthBar: UIView!
	@IBOutlet weak var spriteView: SKView!
    var mainScene = FMMainScene()
    var state = FMSpriteState()
	
    @IBOutlet weak var healthBarWidth: NSLayoutConstraint!
	
    private static var defaultController: FMHomeViewController?
    
    let maxHealth = 100
    var maxBarLength: CGFloat = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if FMHomeViewController.defaultController == nil {
			FMHomeViewController.defaultController = self
		}
		
		if let scene = FMMainScene(fileNamed: "FMMainScene") {
			self.mainScene = scene
            self.mainScene.scaleMode = .aspectFill
			self.spriteView.presentScene(self.mainScene)
		}
		
		self.spriteView.ignoresSiblingOrder = true
		
		self.view.backgroundColor = UIColor.secondaryColor
        
        FMHealthStatusManager.sharedManager.authorizeHealthKit {
            (authorized,  error) -> Void in
            if authorized {
                self.refreshSprite()
            } else {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
            }
        }
	}
    
    private func refreshSprite() {
        FMSpriteStatusManager.sharedManager.refreshSprite {success in
            DispatchQueue.main.async {
                if (success) {
                    let sprite = FMSpriteStatusManager.sharedManager.sprite!
                    self.state = sprite.states.last!
                    self.displaySpriteData()
                } else {
                    print("sprite not updated")
                }
            }
        }
    }
    
    private func displaySpriteData() {
        self.maxBarLength = self.healthBar.frame.width
        let health = min(self.state.health, self.maxHealth)
        let percentage = Float(health) / Float(maxHealth)
        self.healthBarWidth.constant = -CGFloat(1 - percentage) * CGFloat(self.maxBarLength)
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
