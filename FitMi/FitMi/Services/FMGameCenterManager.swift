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
            
            // Already login
            if (localPlayer.isAuthenticated) {
                completion(nil, nil)
            }
        }
    }
    
    func isGameCenterAuthenticated() -> Bool {
        let localPlayer = GKLocalPlayer.localPlayer()
        return localPlayer.isAuthenticated
    }
}
