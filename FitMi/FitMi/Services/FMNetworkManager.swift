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
								if let xml = response.result.value {
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
	
	
}
