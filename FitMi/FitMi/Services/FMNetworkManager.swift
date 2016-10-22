//
//  FMNetworkManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 17/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import RealmSwift
import FacebookCore

class FMNetworkManager: NSObject {
	static var sharedManager = FMNetworkManager()
	
	func checkConfiguratonFileUpdate(completion: @escaping (_ error: Error?, _ requireUpdate: Bool, _ configDict: NSDictionary?) -> Void) {
		
		let realm = try! Realm()
		let appearances = realm.objects(FMAppearance.self).sorted(byProperty: "lastUpdateTime", ascending: false)
		var dateString = ""
		if let appearance = appearances.first {
			dateString = appearance.lastUpdateTime.timeStamp
		}
		
		let param: Parameters = ["updateTime": dateString]
        Alamofire.request("https://72s7ml6tyb.execute-api.ap-southeast-1.amazonaws.com/production/updateCheck", method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
				if let error = response.result.error {
					completion(error, false, nil)
				} else {
					if let res = response.result.value {
						let json = JSON(res)
						if json["required"].bool! {
							// Update required
							Alamofire.request(json["url"].string!).responsePropertyList {
								response in
								if let error = response.result.error {
									completion(error, false, nil)
								} else if let xml = response.result.value {
									completion(nil, true, xml as? NSDictionary)
								} else {
									let error = NSError(domain: "fitmi-config-fault", code: 1, userInfo: nil) as Error
									completion(error, false, nil)
								}
							}
						} else {
							completion(nil, false, nil)
						}
					} else {
						let error = NSError(domain: "fitmi-config-fault", code: 1, userInfo: nil) as Error
						completion(error, false, nil)
					}
				}
            }
	}
	
	func downloadImageFromUrl(urlString: String, completion: @escaping (_ error: Error?, _ image: UIImage?) -> Void) {
		let url = URL(string: urlString)!
		Alamofire.request(url).responseImage(completionHandler: {
			response in
			if let data = response.result.value {
				completion(nil, data)
			} else {
				let error = NSError(domain: "fitmi-image-fault", code: 2, userInfo: nil) as Error
				completion(error, nil)
			}
		})
	}
    
    func isTokenAvailable() -> Bool {
        let prefs = UserDefaults.standard
        return (prefs.string(forKey: "jwt") != nil) && (AccessToken.current != nil)
    }
    
    func authenticateWithToken(token: String, completion: @escaping (_ error: Error?, _ jwt: String?) -> Void) {
        let parameters: Parameters = ["token": token]
        Alamofire.request(API_BASE_ENDPOINT + "/authenticate", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                if let res = response.result.value {
                    completion(nil, res as? String)
                } else {
                    let error = NSError(domain: "fitmi-server-error-response", code: 2, userInfo: nil) as Error
                    completion(error, nil)
                }
        }
    }
    
    func getUser(userFbId: String, completion: @escaping (_ error: Error?, _ user: JSON?) -> Void) {
        let prefs = UserDefaults.standard
        guard let jwt = prefs.string(forKey: "jwt") else {
            // TODO: better handling
            let error = NSError(domain: "fitmi-invalid-jwt-token", code: 2, userInfo: nil) as Error
            completion(error, nil)
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwt)"
        ]
        Alamofire.request(API_BASE_ENDPOINT + "/users/\(userFbId)", method: .get, headers: headers)
            .responseJSON { (response) in
                if let res = response.result.value {
                    completion(nil, JSON(res))
                } else {
                    // TODO: better handling
                    let error = NSError(domain: "fitmi-server-error-response", code: 2, userInfo: nil) as Error
                    completion(error, nil)
                }
        }
    }
    
    func updateUser(newData: Parameters, completion: @escaping (_ error: Error?, _ success: Bool) -> Void) {
        let prefs = UserDefaults.standard
        guard let jwt = prefs.string(forKey: "jwt") else {
            // TODO: better handling
            let error = NSError(domain: "fitmi-invalid-jwt-token", code: 2, userInfo: nil) as Error
            completion(error, false)
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwt)"
        ]
        Alamofire.request(API_BASE_ENDPOINT + "/users", method: .post, parameters: newData, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                if let error = response.result.error {
                    completion(error, false)
                } else if response.result.value != nil {
                    completion(nil, true)
                } else {
                    // TODO: better handling
                    let error = NSError(domain: "fitmi-server-error-response", code: 2, userInfo: nil) as Error
                    completion(error, false)
                }
        }
    }
    
    func getFriendList(completion: @escaping (_ error: Error?, _ friends: JSON?) -> Void) {
        let prefs = UserDefaults.standard
        guard let jwt = prefs.string(forKey: "jwt") else {
            // TODO: better handling
            let error = NSError(domain: "fitmi-invalid-jwt-token", code: 2, userInfo: nil) as Error
            completion(error, false)
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwt)"
        ]
        Alamofire.request(API_BASE_ENDPOINT + "/users/friends", method: .get, headers: headers)
            .responseJSON { (response) in
                if let error = response.result.error {
                    completion(error, nil)
                } else if let res = response.result.value {
					let json = JSON(res)
					let sorted = json.arrayValue.sorted(by: { $0["level"].intValue > $1["level"].intValue })
					let sortedJSON = JSON(sorted)
                    completion(nil, sortedJSON)
                } else {
                    // TODO: better handling
                    let error = NSError(domain: "fitmi-server-error-response", code: 2, userInfo: nil) as Error
                    completion(error, nil)
                }
        }
    }
    
    func createCombat(combat: Parameters, completion: @escaping (_ error: Error?, _ combat: JSON?) -> Void) {
        let prefs = UserDefaults.standard
        guard let jwt = prefs.string(forKey: "jwt") else {
            // TODO: better handling
            let error = NSError(domain: "fitmi-invalid-jwt-token", code: 2, userInfo: nil) as Error
            completion(error, false)
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwt)"
        ]
        Alamofire.request(API_BASE_ENDPOINT + "/combats/create", method: .post, parameters: combat, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                if let error = response.result.error {
                    completion(error, nil)
                } else if let combat = response.result.value {
                    completion(nil, JSON(combat))
                } else {
                    // TODO: better handling
                    let error = NSError(domain: "fitmi-server-error-response", code: 2, userInfo: nil) as Error
                    completion(error, nil)
                }
        }
    }
    
    func getCombat(combatId: String, completion: @escaping (_ error: Error?, _ combat: JSON?) -> Void) {
        let prefs = UserDefaults.standard
        guard let jwt = prefs.string(forKey: "jwt") else {
            // TODO: better handling
            let error = NSError(domain: "fitmi-invalid-jwt-token", code: 2, userInfo: nil) as Error
            completion(error, false)
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwt)"
        ]
        Alamofire.request(API_BASE_ENDPOINT + "/combats/\(combatId)", method: .get, headers: headers)
            .responseJSON { (response) in
                if let error = response.result.error {
                    completion(error, nil)
                } else if let combat = response.result.value {
                    completion(nil, JSON(combat))
                } else {
                    // TODO: better handling
                    let error = NSError(domain: "fitmi-server-error-response", code: 2, userInfo: nil) as Error
                    completion(error, nil)
                }
        }
    }
}
