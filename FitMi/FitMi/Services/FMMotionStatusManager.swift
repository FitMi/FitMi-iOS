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
                             didRecieveMotionData data: CMPedometerData)
    func motionStatusManager(manager: FMMotionStatusManager,
                             didRecieveActivityData data: CMMotionActivity)
    func motionStatusManager(manager: FMMotionStatusManager,
                             onError error: NSError)
}

class FMMotionStatusManager: NSObject {
    static let sharedManager = FMMotionStatusManager()

    var delegate: FMMotionStatusDelegate?

    private let dataProcessingQueue = OperationQueue()
    private let pedometer = CMPedometer()
    private let lengthFormatter = LengthFormatter()
    private let activityManager = CMMotionActivityManager()
    
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
                self.handleError(error: error! as NSError)
            } else {
                if let motionData: CMPedometerData = data {
                    self.delegate?.motionStatusManager(manager: self,
                                                       didRecieveMotionData: motionData)
                }
            }
        }
        
        activityManager.startActivityUpdates(to: dataProcessingQueue) {
            data in
            if let activityData: CMMotionActivity = data {
                self.delegate?.motionStatusManager(manager: self,
                                                   didRecieveActivityData: activityData)
            }
        }
    }
    
    func stopMotionUpdates() {
        pedometer.stopUpdates()
        activityManager.stopActivityUpdates()
    }
    
    func isDistanceAvailable() -> Bool {
        return CMPedometer.isDistanceAvailable()
    }
    
    func isFloorCountingAvailable() -> Bool {
        return CMPedometer.isFloorCountingAvailable()
    }
    
    private func handleError(error: NSError) {
        self.stopMotionUpdates()
        self.delegate?.motionStatusManager(manager: self, onError: error)
    }
}
