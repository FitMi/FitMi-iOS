//
//  main.swift
//  FitMi
//
//  Created by Jinghan Wang on 23/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import UIKit


UIApplicationMain(
	CommandLine.argc,
	UnsafeMutableRawPointer(CommandLine.unsafeArgv)
		.bindMemory(
			to: UnsafeMutablePointer<Int8>.self,
			capacity: Int(CommandLine.argc)),
	NSStringFromClass(FMApplication.self),
	NSStringFromClass(AppDelegate.self)
)
