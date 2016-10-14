//
//  FMExercisePopupViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 14/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMExercisePopupViewController: FMViewController {

	@IBOutlet var cardView: UIView!
	@IBOutlet var cardViewLayoutY: NSLayoutConstraint!
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var startLabel: UILabel!
	@IBOutlet var endLabel: UILabel!
	@IBOutlet var durationLabel: UILabel!
	@IBOutlet var stepsLabel: UILabel!
	@IBOutlet var distanceLabel: UILabel!
	@IBOutlet var floorsLabel: UILabel!
	
	static var dateFormater: DateFormatter!
	
	var exerciseRecord: FMExerciseRecord?
	
	override func loadView() {
		super.loadView()
		self.cardViewLayoutY.constant = UIScreen.main.bounds.height
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.setCardViewData()
		self.animateCardViewIn()
		self.setCardViewStyle()
	}
	
	func animateCardViewIn() {
		self.cardViewLayoutY.constant = UIScreen.main.bounds.height
		self.view.setNeedsLayout()
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
			self.cardViewLayoutY.constant = 0
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	@IBAction func animateCarViewOut() {
		self.cardViewLayoutY.constant = 0
		self.view.setNeedsLayout()
		self.dismiss(animated: true, completion: nil)
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
			self.cardViewLayoutY.constant = UIScreen.main.bounds.height
			self.view.layoutIfNeeded()
		}, completion: {
			_ in
			
		})
	}
	
	func setCardViewStyle() {
		let layer = self.cardView.layer
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize.zero
		layer.shadowRadius = 20
		layer.shadowOpacity = 0.3
	}
	
	func setCardViewData() {
		if let record = self.exerciseRecord {
			self.titleLabel.text = "WORKOUT STORED"
			
			self.startLabel.text = FMExercisePopupViewController.dateFormater.string(from: record.startTime)
			self.endLabel.text = FMExercisePopupViewController.dateFormater.string(from: record.endTime)
			
			let duration = Int(record.endTime.timeIntervalSince(record.startTime))
			let hour = duration / 3600
			let min = (duration - hour * 3600) / 60
			let sec = duration % 60
			DispatchQueue.main.async {
				self.durationLabel.text = "\(hour < 10 ? "0": "")\(hour) : \(min < 10 ? "0": "")\(min) : \(sec < 10 ? "0": "")\(sec)"
			}
			
			self.stepsLabel.text = "\(record.steps)"
			self.distanceLabel.text = "\(record.distance) m"
			self.floorsLabel.text = "\(record.flights)"
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let dateFormater = DateFormatter()
		dateFormater.dateFormat = "MMM dd, hh:mm:ss"
		FMExercisePopupViewController.dateFormater = dateFormater
		
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	class func controllerFromStoryboard() -> FMExercisePopupViewController {
		let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "FMExercisePopupViewController") as! FMExercisePopupViewController
		controller.modalPresentationStyle = .overCurrentContext
		controller.modalTransitionStyle = .crossDissolve
		return controller
	}

}
