//
//  FMLoadingViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 17/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMLoadingViewController: FMViewController {

	@IBOutlet var progressView: UIProgressView!
	
	fileprivate var didRecievePackets = false
	fileprivate var timer: Timer!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.progressView.setProgress(0, animated: false)
		self.progressView.isHidden = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		FMConfigurationParser.delegate = self
		FMConfigurationParser.refreshConfiguration()
		UIView.animate(withDuration: 0.2, animations: {
			self.progressView.alpha = 1
		})
		self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(fakeProgress), userInfo: nil, repeats: true)
	}

	func fakeProgress() {
		if !didRecievePackets {
			var progress = self.progressView.progress
			if progress < 0.6 {
				progress += 0.1
			} else {
				self.timer.invalidate()
			}
			self.progressView.setProgress(progress, animated: true)
		} else {
			self.timer.invalidate()
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}

extension FMLoadingViewController: FMConfigurationParserDelegate {
	func parserDidReceiveUpdate(newProgress: Int, total: Int) {
		print("Downloaded: \(newProgress)/\(total)")
		self.didRecievePackets = true
		let progress = Float(newProgress) / Float(total)
		if progress > self.progressView.progress {
			self.progressView.setProgress(progress, animated: true)
		}
	}
	
	func parserDidCompleteWork() {
		print("Update Completed")
		self.progressView.setProgress(1, animated: true)
		Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(redirectToMainView), userInfo: nil, repeats: false)
	}
	
	func redirectToMainView() {
		DispatchQueue.main.async {
			let storyBoard = UIStoryboard(name: "Main", bundle: nil)
			let rootVC = storyBoard.instantiateViewController(withIdentifier: "FMMainViewController")
			UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.3, options: [.transitionCrossDissolve], animations: {
				UIApplication.shared.keyWindow?.rootViewController = rootVC
			}, completion: nil)
		}
	}
}
