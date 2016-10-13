//
//  FMOnboardViewController.swift
//  FitMi
//
//  Created by Jiang Sheng on 13/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import JazzHands
import Masonry

class FMOnboardViewController: IFTTTAnimatedPagingScrollViewController {
	
	private var page0Label0: UILabel!
	private var page0ImageView0: UILabel!
	
	override func numberOfPages() -> UInt {
		return 1
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.configureViews()
    }
	
	private func configureViews() {
		
		
		do {
			let label = UILabel()
			label.text = "Welcome"
			label.textAlignment = .center
			
			
			self.view.addSubview(label)
			self.page0Label0 = label
		}
		
	}
	
	private func configureAnimations() {
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
