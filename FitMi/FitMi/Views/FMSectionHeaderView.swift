//
//  FMSectionHeaderView.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMSectionHeaderView: UIView {

	@IBOutlet var titleLabel: UILabel!
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	static func viewFromNib() -> FMSectionHeaderView {
		let view = Bundle.main.loadNibNamed("FMSectionHeaderView", owner: self, options: nil)![0] as! FMSectionHeaderView
		return view
	}

}
