//
//  FMLoadingViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 17/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMLoadingViewController: FMViewController {

	@IBOutlet var progressView: FMProgressView!
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		FMConfigurationParser.delegate = self
		FMConfigurationParser.refreshConfiguration()
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
}

extension FMLoadingViewController: FMConfigurationParserDelegate {
	func parserDidReceiveUpdate(newProgress: Int, total: Int) {
		print("Downloaded: \(newProgress)/\(total)")
		self.progressView.maxValue = Double(total)
		self.progressView.value = Double(newProgress)
	}
	
	func parserDidCompleteWork() {
		print("Update Completed")
		self.progressView.percentage = 1
		
		Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(redirectToMainView), userInfo: nil, repeats: false)
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
