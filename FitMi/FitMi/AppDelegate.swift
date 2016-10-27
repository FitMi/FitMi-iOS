//
//  AppDelegate.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import FontBlaster
import FacebookCore
import FBSDKCoreKit
import RealmSwift
import UserNotifications
import WatchConnectivity

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	var session: WCSession? {
		didSet {
			if let session = session {
				session.delegate = self
				session.activate()
			}
		}
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		self.session = WCSession.default()
		
		let config = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: 6,

			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { migration, oldSchemaVersion in
				// We haven’t migrated anything yet, so oldSchemaVersion == 0
				if (oldSchemaVersion < 1) {
					// Nothing to do!
					// Realm will automatically detect new properties and removed properties
					// And will update the schema on disk automatically
				}
		})
		
		// Tell Realm to use this new configuration object for the default Realm
		Realm.Configuration.defaultConfiguration = config
		
        // Request for local Notification permission
        /*
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
                (granted, error) in
                // Enable or disable features based on authorization.
            }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
		*/
        
        let hasOnboard = application.hasOnboard
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		if hasOnboard {
			let rootVC = storyBoard.instantiateViewController(withIdentifier: "FMLoadingViewController")
            self.window?.rootViewController = rootVC
        } else {
			let onboardVC = storyBoard.instantiateViewController(withIdentifier: "FMOnboardViewController")
            self.window?.rootViewController = onboardVC
        }
        self.window?.makeKeyAndVisible()
		
		return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        /*
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        } else {
            application.cancelAllLocalNotifications()
        }
        */
	}


}

extension AppDelegate: WCSessionDelegate {
	@available(iOS 9.3, *)
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Activation Error: \(error)")
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		if let data = message[CONNECTIVITY_KEY_WATCH_DATA] as? [[String : String]] {
			FMDatabaseManager.sharedManager.updateRecords(records: data)
			replyHandler(["success": 1])
			DispatchQueue.main.async {
				let controller = UIAlertController(title: "Data Received from Watch", message: "\(data.count) new \(data.count == 1 ? "record has" : "records have") been added.", preferredStyle: .actionSheet)
				controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				self.window?.rootViewController?.present(controller, animated: true, completion: nil)
			}
		} else {
			replyHandler(["success": 0])
		}
	}
}
