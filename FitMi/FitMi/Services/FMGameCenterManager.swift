//
//  FMGameCenterManager.swift
//  FitMi
//
//  Created by Jiang Sheng on 2/11/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import GameKit


class FMGameCenterManager: NSObject {
    static var sharedManager = FMGameCenterManager()
    var currentAchievements = [String:GKAchievement]()
    
    func authenticateWithGameCenter(completion: @escaping (_ vc: UIViewController?, _ error: Error?) -> Void) {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            viewController, error in
            
            // Has error
            if let err = error {
                print(err)
                completion(nil, err)
                return
            }
            
            // Login required
            if let vc = viewController {
                completion(vc, nil)
                return
            }
            
            // Already login, load current achievement progress
            if (localPlayer.isAuthenticated) {
                GKAchievement.loadAchievements { (result, err) in
                    if let _ = err {
                        print("Error loading achievements")
                        return
                    } else if let achievements = result {
                        for achievement in achievements  {
                            self.currentAchievements[achievement.identifier!] = achievement
                        }
                        completion(nil, nil) // Returns here
                    }
                }
            }
        }
    }
    
    func isGameCenterAuthenticated() -> Bool {
        let localPlayer = GKLocalPlayer.localPlayer()
        return localPlayer.isAuthenticated
    }
    
    func completeAchievement(achievementId: String) {
        self.updateAchievement(achievementId: achievementId, progress: 100.0)
    }
    
    func updateAchievement(achievementId: String, progress: Double) {
        if !self.isGameCenterAuthenticated() {
            return
        }
        
        let achi = self.getAchievement(id: achievementId)
        if achi.isCompleted {
            return
        }
        achi.percentComplete = progress
        if progress == 100.0 {
            achi.showsCompletionBanner = true
        }
        GKAchievement.report([achi], withCompletionHandler: {
            (err) in
            if let error = err {
                print(error)
            }
        })
    }
    
    func resetAchievements(achievementId: String) {
        GKAchievement.resetAchievements { (error) in
            if error != nil {
                print(error!)
            } else {
                print("RESET")
            }
        }
    }
    
    func hasReceivedAchievements(achievementId: String) -> Bool {
        let achi = getAchievement(id: achievementId)
        return achi.isCompleted
    }
    
    func getAchievement(id: String) -> GKAchievement {
        if let achievement = currentAchievements[id] {
            return achievement
        } else {
            return GKAchievement(identifier: id)
        }
    }
}
