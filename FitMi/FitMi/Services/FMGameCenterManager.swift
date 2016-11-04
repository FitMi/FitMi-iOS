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

    func handleBattleWon(totalWin: Int) {
        let achievementWon10 = getAchievement(id: AchievementId.BATTLE_WON_10.rawValue)
        achievementWon10.percentComplete = min(Double(totalWin) * 10.0, 100.0)
        if totalWin == 10 {
            achievementWon10.showsCompletionBanner = true
        }
        
        let achievementWon50 = getAchievement(id: AchievementId.BATTLE_WON_50.rawValue)
        achievementWon50.percentComplete = min(Double(totalWin) * 2.0, 100.0)
        if totalWin == 50 {
            achievementWon50.showsCompletionBanner = true
        }
        
        let achievementWon100 = getAchievement(id: AchievementId.BATTLE_WON_100.rawValue)
        achievementWon100.percentComplete = min(Double(totalWin), 100.0)
        if totalWin == 100 {
            achievementWon100.showsCompletionBanner = true
        }
        
        let achievementWon500 = getAchievement(id: AchievementId.BATTLE_WON_500.rawValue)
        achievementWon500.percentComplete = min(Double(totalWin) / 5.0, 100.0)
        if totalWin == 500 {
            achievementWon500.showsCompletionBanner = true
        }

        GKAchievement.report([achievementWon10, achievementWon50, achievementWon100, achievementWon500], withCompletionHandler: {
            (err) in
            if let error = err {
                print(error)
            }
        })
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
            let achi = GKAchievement(identifier: id)
            currentAchievements[id] = achi
            return achi
        }
    }
	
	func reportLeaderboardScores() {
		let manager = FMSpriteStatusManager.sharedManager
		let healthScore = GKScore(leaderboardIdentifier: "com.fitmi.leaderboard.health")
		healthScore.value = Int64(manager.currentHP())
		healthScore.context = 0
		
		let strengthScore = GKScore(leaderboardIdentifier: "com.fitmi.leaderboard.strength")
		strengthScore.value = Int64(manager.currentStrength())
		strengthScore.context = 0
		
		let staminaScore = GKScore(leaderboardIdentifier: "com.fitmi.leaderboard.stamina")
		staminaScore.value = Int64(manager.currentStamina())
		staminaScore.context = 0
		
		let agilityScore = GKScore(leaderboardIdentifier: "com.fitmi.leaderboard.agility")
		agilityScore.value = Int64(manager.currentAgility())
		agilityScore.context = 0
		
		let scores = [healthScore, strengthScore, staminaScore, agilityScore]
		
		GKScore.report(scores, withCompletionHandler: {
			error in
			print(error ?? "Leaderboard: No Error")
		})
	}
}
