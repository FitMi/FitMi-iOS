//
//  FMAtomicCounter.swift
//  FitMi
//
//  Created by Jinghan Wang on 17/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMAtomicCounter {
	private var mutex = pthread_mutex_t()
	private var counter: Int = 0
	
	init() {
		pthread_mutex_init(&mutex, nil)
	}
	
	deinit {
		pthread_mutex_destroy(&mutex)
	}
	
	func get() -> Int {
		return counter
	}
	
	func incrementAndGet() -> Int {
		pthread_mutex_lock(&mutex)
		defer {
			pthread_mutex_unlock(&mutex)
		}
		counter += 1
		return counter
	}
}
