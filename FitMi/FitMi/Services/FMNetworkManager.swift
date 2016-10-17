//
//  FMNetworkManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 17/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import SwiftHTTP

class FMNetworkManager: NSObject {
	static var sharedManager = FMNetworkManager()
	
	func checkConfiguratonFileUpdate(completion: (_ error: Error, _ requireUpdate: Bool, _ configDict: NSDictionary) -> Void) {
		let param = ["updateTime": ""]
		do {
			let opt = try HTTP.POST("https://72s7ml6tyb.execute-api.ap-southeast-1.amazonaws.com/production/updateCheck", parameters: param, headers: nil, requestSerializer: JSONParameterSerializer())
			opt.start({
				response in
				print(response)
			})
		} catch let error {
			print(error)
		}
	}
}
