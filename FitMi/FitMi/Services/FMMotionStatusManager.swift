//
//  FMMotionStatusManager.swift
//  FitMi
//
//  Created by Jiang Sheng on 11/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import CoreMotion

protocol FMMotionStatusDelegate {
    func motionStatusManager(manager: FMMotionStatusManager,
                             didRecieveData data: CMPedometerData)
}

class FMMotionStatusManager: NSObject {
    static let sharedManager = FMMotionStatusManager()

    var delegate: FMMotionStatusDelegate?

    private let dataProcessingQueue = OperationQueue()
    private let pedometer = CMPedometer()
    private let lengthFormatter = LengthFormatter()
    
    override init() {
        self.lengthFormatter.numberFormatter.usesSignificantDigits = false
        self.lengthFormatter.numberFormatter.maximumSignificantDigits = 2
        self.lengthFormatter.unitStyle = .short
    }
    
    func startMotionUpdates() {
        let currentDate = Date()
        pedometer.startUpdates(from: currentDate) {
            (data, error) in
            if error != nil {
                print("There was an error obtaining pedometer data: \(error)")
            } else {
                if let motionData: CMPedometerData = data {
                    self.delegate?.motionStatusManager(manager: self,
                                                       didRecieveData: motionData)
                }
            }
        }
    }
    
    func stopMotionUpdates() {
        pedometer.stopUpdates()
    }
    
    func isDistanceAvailable() -> Bool {
        return CMPedometer.isDistanceAvailable()
    }
    
    func isFloorCountingAvailable() -> Bool {
        return CMPedometer.isFloorCountingAvailable()
    }
}
