//
//  FMNetworkManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 17/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FMNetworkManager: NSObject {
	static var sharedManager = FMNetworkManager()
	
	func checkConfiguratonFileUpdate(completion: @escaping (_ error: Error, _ requireUpdate: Bool, _ configDict: NSDictionary) -> Void) {
		let param: Parameters = ["updateTime": ""]
        Alamofire.request("https://72s7ml6tyb.execute-api.ap-southeast-1.amazonaws.com/production/updateCheck", method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let res = response.result.value {
                    let json = JSON(res)
                    if json["required"].bool! {
                        // Update required
                        Alamofire.request(json["url"].string!).responsePropertyList {
                            response in
                            if let xml = response.result.value {
                                // print(xml as! NSDictionary)
                            }
                        }
                    } else {
                        // No Updates needed
                    }
                }
            }
	}
    
    
}
