//
//  FMExerciseViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import CoreMotion

class FMExerciseViewController: FMViewController {

	private static var defaultController: FMExerciseViewController?
	
	@IBOutlet var statusPanelViewTopConstraint: NSLayoutConstraint!
	@IBOutlet var statusPanelView: UIView!
	@IBOutlet var statusPanelTitleContainer: UIView!
	@IBOutlet var statusPanelTitleLabel: UILabel!
	@IBOutlet var spriteView: SKView!
	@IBOutlet var highlightBackground: UIButton!
	
	@IBOutlet var buttonStartExercise: UIButton!
	@IBOutlet var buttonEndExercise: UIButton!
	
	@IBOutlet var labelDuration: UILabel!
	@IBOutlet var labelStepCount: UILabel!
	@IBOutlet var labelDistance: UILabel!
	@IBOutlet var labelFlights: UILabel!
	
	@IBOutlet var tap: UITapGestureRecognizer!
    
    var mainScene = FMExerciseScene()
    
	let buttonAlphaDisabled: CGFloat = 0.3
	
	var exerciseStartDate: Date!
	var exerciseEndDate: Date!
	var stepCount: Int = 0
	var distance: Int = 0
	var flights: Int = 0
	var durationUpdateTimer: Timer!
    
    var wasMoving = false
	
    private let motionStatusManager = FMMotionStatusManager.sharedManager

	override func loadView() {
		super.loadView()
		
		self.view.backgroundColor = UIColor.secondaryColor
        motionStatusManager.delegate = self
		
		do {
			self.statusPanelView.backgroundColor = UIColor.white
			let layer = self.statusPanelView.layer
			layer.borderWidth = 3
			layer.borderColor = UIColor.black.cgColor
		}
		
		do {
			self.statusPanelTitleContainer.backgroundColor = UIColor.white
			let layer = self.statusPanelTitleContainer.layer
			layer.borderWidth = 3
			layer.borderColor = UIColor.black.cgColor
		}
		
		do {
			if let scene = FMExerciseScene(fileNamed: "FMExerciseScene") {
                self.mainScene = scene
				scene.scaleMode = .aspectFill
				self.spriteView.presentScene(scene)
			}
			
			self.spriteView.ignoresSiblingOrder = true
		}
		
		self.view.isUserInteractionEnabled = true
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if FMExerciseViewController.defaultController == nil {
			FMExerciseViewController.defaultController = self
		}
		
		self.buttonStartExercise.isEnabled = true
		self.buttonEndExercise.alpha = buttonAlphaDisabled
		self.buttonEndExercise.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	class func getDefaultController() -> FMExerciseViewController {
		if FMExerciseViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMExerciseViewController") as! FMExerciseViewController
			FMExerciseViewController.defaultController = controller
		}
		
		return FMExerciseViewController.defaultController!
	}

	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
	}
	
	override func willMoveAway(fromParentViewController parent: UIViewController?) {
	}
	
	func updateDurationLabel() {
		let duration = Int(Date().timeIntervalSince(self.exerciseStartDate))
		let hour = duration / 3600
		let min = (duration - hour * 3600) / 60
		let sec = duration % 60
		DispatchQueue.main.async {
			self.labelDuration.text = "\(hour < 10 ? "0": "")\(hour) : \(min < 10 ? "0": "")\(min) : \(sec < 10 ? "0": "")\(sec)"
		}
	}
	
	func generateExerciseReport() {
		print("Exercise Finished")
		print("Steps: \(self.stepCount)")
		print("Distance: \(self.distance)")
		print("Flights: \(self.flights)")
		print("Start: \(self.exerciseStartDate)")
		print("End: \(self.exerciseEndDate)")
		print("Duration: \(self.exerciseEndDate.timeIntervalSince(self.exerciseStartDate))")
		
		if !(self.stepCount == 0 && self.distance == 0 && self.flights == 0) {
			let record = FMExerciseRecord()
			record.steps = self.stepCount
			record.distance = self.distance
			record.flights = self.flights
			record.startTime = self.exerciseStartDate
			record.endTime = self.exerciseEndDate

			let databaseManager = FMDatabaseManager.sharedManager
			databaseManager.realmUpdate {
				databaseManager.getCurrentSprite().exercises.append(record)
			}
		}

		self.highlightPanel()
	}
	
	func highlightPanel() {
		self.highlightBackground.isHidden = false
		UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
			self.spriteView.alpha = 0
			self.highlightBackground.alpha = 1
		}, completion: {
			_ in
			self.view.setNeedsLayout()
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
				self.statusPanelViewTopConstraint.constant = UIScreen.main.bounds.height / 2 - 160
				self.view.layoutIfNeeded()
			}, completion: nil)
		})
	}
	
	@IBAction func deHighlightPanel() {
		UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
			self.spriteView.alpha = 1
			self.highlightBackground.alpha = 0
		}, completion: {
			_ in
			self.highlightBackground.isHidden = true
		})
		
		self.reset(nil)
		
		self.view.setNeedsLayout()
		UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
			self.statusPanelViewTopConstraint.constant = 40
			self.view.layoutIfNeeded()
			}, completion: nil)
	}
	
	
	
	@IBAction func reset(_ sender: AnyObject?) {
		self.exerciseStartDate = nil
		self.exerciseEndDate = nil
		self.stepCount = 0
		self.distance = 0
		self.flights = 0
		self.updateLabels()
	}

    @IBAction func startExercise(_ sender: AnyObject) {
		self.tap.isEnabled = false
		self.buttonStartExercise.isEnabled = false
		self.buttonStartExercise.alpha = buttonAlphaDisabled
		self.buttonEndExercise.isEnabled = true
		self.buttonEndExercise.alpha = 1
		self.exerciseStartDate = Date()
		self.durationUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDurationLabel), userInfo: nil, repeats: true)
        motionStatusManager.startMotionUpdates()
    }
    
    @IBAction func endExercise(_ sender: AnyObject) {
        self.mainScene.animateNormalSprite()
        motionStatusManager.stopMotionUpdates()
		self.tap.isEnabled = true
		self.buttonStartExercise.isEnabled = true
		self.buttonStartExercise.alpha = 1
		self.buttonEndExercise.isEnabled = false
		self.buttonEndExercise.alpha = buttonAlphaDisabled
		self.exerciseEndDate = Date()
		self.durationUpdateTimer.invalidate()
		
		self.generateExerciseReport()
    }
	
	func updateLabels() {
		if self.exerciseStartDate == nil {
			self.labelDuration.text = "00 : 00 : 00"
		}
		self.labelStepCount.text = "\(self.stepCount)"
		self.labelDistance.text = "\(self.distance) m"
		self.labelFlights.text = "\(self.flights)"
	}
}

extension FMExerciseViewController: FMMotionStatusDelegate {
    func motionStatusManager(manager: FMMotionStatusManager, didRecieveMotionData data: CMPedometerData) {
		self.stepCount = Int(data.numberOfSteps)
		
		if manager.isDistanceAvailable() {
			self.distance = Int(data.distance!)
		}
		
		if manager.isFloorCountingAvailable() {
			self.flights = Int(data.floorsAscended!)
		}
		
		DispatchQueue.main.async {
			self.updateLabels()
		}
    }
    
    func motionStatusManager(manager: FMMotionStatusManager, didRecieveActivityData data: CMMotionActivity) {
        // TODO: collect the data and reflect them in the view
        var isMoving = false
        if data.running {
            print("Activity: running")
            isMoving = true
        } else if data.cycling {
            print("Activity: cycling")
            isMoving = true
        } else if data.walking {
            print("Activity: walking")
            isMoving = true
        } else if data.stationary {
            print("Activity: still")
            isMoving = false
        } else {
        }
        
        if (isMoving != self.wasMoving) {
            print("satus changed!")
            if (isMoving) {
                self.mainScene.removeAllActions()
                self.mainScene.animateRunSprite()
            } else {
                self.mainScene.removeAllActions()
                self.mainScene.animateNormalSprite()
            }
        }
        
        self.wasMoving = isMoving
    }
    
    func motionStatusManager(manager: FMMotionStatusManager, onError error: NSError) {
        if error.code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
            let message = "Turn off motion activity will disable built-in pedometer. " +
                            "Please turn it back on in Settings > Privacy > Motion&Fitness > FitMi."
            let alertController = UIAlertController(title: "MOTION ACTIVITY ERROR", message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: {
                (_) in
                // Stop Exercise
                self.tap.isEnabled = true
                self.buttonStartExercise.isEnabled = true
                self.buttonStartExercise.alpha = 1
                self.buttonEndExercise.isEnabled = false
                self.buttonEndExercise.alpha = self.buttonAlphaDisabled
                self.durationUpdateTimer.invalidate()
                // Update UI
                self.exerciseStartDate = nil
                self.exerciseEndDate = nil
                self.stepCount = 0
                self.distance = 0
                self.flights = 0
                self.updateLabels()
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
