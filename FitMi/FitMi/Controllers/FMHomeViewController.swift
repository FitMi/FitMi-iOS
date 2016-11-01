//
//  FMHomeViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import GameKit

class FMHomeViewController: FMViewController {

    @IBOutlet weak var experienceIndicatorLabel: UILabel!
    @IBOutlet weak var experienceProgressView: UIProgressView!
	@IBOutlet weak var spriteView: SKView!
    var mainScene = FMMainScene()
    var state = FMSpriteState()
	
    private static var defaultController: FMHomeViewController?
    
    private let gameCenterManager = FMGameCenterManager.sharedManager
    
    let maxHealth = 100
    var maxBarLength: CGFloat = 0
    var maxExpBarLength: CGFloat = 0
	
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        if !gameCenterManager.isGameCenterAuthenticated() {
            gameCenterManager.authenticateWithGameCenter(completion: { (vc, err) in
                if let error = err {
                    print(error)
                    // TODO: say some thing to ask user to login to Game Center to enjoy achievements
                    return
                }

                if let controller = vc {
                    FMRootViewController.defaultController.present(controller, animated: true, completion: nil)
                    return
                }

//                // show Game center
//                let gameCenterVc = GKGameCenterViewController()
//                gameCenterVc.gameCenterDelegate = self
//                gameCenterVc.viewState = .achievements
//                FMRootViewController.defaultController.present(gameCenterVc, animated: true, completion: nil)
            })
        }
	}
    
    override func willMove(toParentViewController parent: UIViewController?) {
        self.refreshSprite() // refresh when it will appear
    }
    
    func appMovedToBackground() {
        // Schedule notification when the app becomes inactive
        FMNotificationManager.sharedManager.scheduleDailyNotification(title: "Dear master~", body : "Let's go exercise (O^~^O)")

        // If no token, reject the update
        if !FMNetworkManager.sharedManager.isTokenAvailable() {
            return
        }
        let prefs = UserDefaults.standard
        if let lastSyncTime = prefs.object(forKey: "lastSyncTime") as? Date {
            let interval = Calendar.current.dateComponents([.minute], from: lastSyncTime, to: Date()).minute ?? 0
            print("Last sync since \(interval)")
            if interval >= 60 {
                FMSpriteStatusManager.sharedManager.pushSpriteStatusToRemote { (error, success) in
                    if error != nil {
                        print(error!)
                    } else {
                        if success {
                            print("updated")
                            prefs.set(Date(), forKey: "lastSyncTime")
                        }
                    }
                }
            } else {
                print("Not old enough to sync data.")
            }
        } else {
            FMSpriteStatusManager.sharedManager.pushSpriteStatusToRemote { (error, success) in
                if error != nil {
                    print(error!)
                } else {
                    if success {
                        print("updated")
                        prefs.set(Date(), forKey: "lastSyncTime")
                    }
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
					NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SPRITE_LOADED_NOTIFICATION"), object: nil)
                } else {
                    print("sprite not updated")
                }
            }
        }
    }
    
    private func displaySpriteData() {
        let experience = self.state.experience
        let level = self.state.level
        let maxExp = FMSpriteLevelManager.sharedManager.experienceLimitForLevel(level: level)
		let maxExpLastLevel = level > 0 ? FMSpriteLevelManager.sharedManager.experienceLimitForLevel(level: level - 1) : 0
		let progress = Float(experience - maxExpLastLevel) / Float(maxExp - maxExpLastLevel)
		self.experienceProgressView.setProgress(progress, animated: true)
		
        self.experienceIndicatorLabel.text = "Lv. \(level):    \(experience) / \(maxExp)"
    }

	@IBAction func presentBoothViewController() {
		let controller = FMBoothViewController.controllerFromStoryboard()
		FMRootViewController.defaultController.present(controller, animated: true, completion: nil)
	}
	
	@IBAction func presentSpriteStatsController() {
		let controller = FMSpriteStatsViewController.controllerFromStoryboard()
		FMRootViewController.defaultController.present(controller, animated: true, completion: nil)
	}
	
	@IBAction func goalButtonDidClick(sender: UIButton) {
        let controller = FMGoalViewController.controllerFromStoryboard()
        controller.currentState = self.state
        FMRootViewController.defaultController.present(controller, animated: false, completion: nil)
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

extension FMHomeViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
