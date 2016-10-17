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
	
	fileprivate var pageControl: UIPageControl!
	
	fileprivate var page0Label0: UILabel!
	fileprivate var page0Label1: UILabel!
	fileprivate var page0ImageView0: UIImageView!
	
	fileprivate var page1Label0: UILabel!
	fileprivate var page1Label1: UILabel!
	
	fileprivate var page2Label0: UILabel!
	fileprivate var page2Label1: UILabel!
	fileprivate var page2ImageView0: UIImageView!
	fileprivate var page2Button0: UIButton!
	
	fileprivate var page3Label0: UILabel!
	fileprivate var page3Label1: UILabel!
	fileprivate var page3Label2: UILabel!
	fileprivate var page3Button0: UIButton!
	fileprivate var page3Button1: UIButton!
	
	fileprivate var titleFont = UIFont(name: "Pixeled", size: 23)
	fileprivate var buttonFont = UIFont(name: "Pixeled", size: 12)
	fileprivate var descriptionFont = UIFont(name: "VT323", size: 25)
	fileprivate var captionFont = UIFont(name: "VT323", size: 17)
	
	override func numberOfPages() -> UInt {
		return 4
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.configureViews()
		self.configureAnimations()
    }
	
	private func configureViews() {
		
		self.contentView.backgroundColor = UIColor(red:0.26, green:0.84, blue:0.80, alpha:1.00)
		self.view.backgroundColor = self.contentView.backgroundColor
		
		do {
			let control = UIPageControl()
			control.numberOfPages = Int(self.numberOfPages())
			control.currentPage = 0
			control.isUserInteractionEnabled = false
			
			self.contentView.addSubview(control)
			self.pageControl = control
		}
		
		do {
			let label = UILabel()
			label.text = "Welcome".uppercased()
			label.textAlignment = .center
			label.font = titleFont
			label.textColor = UIColor.white
			
			
			self.contentView.addSubview(label)
			self.page0Label0 = label
		}

		do {
			let label = UILabel()
			label.text = "to a healthier life".uppercased()
			label.textAlignment = .center
			label.numberOfLines = 0
			label.font = descriptionFont
			label.textColor = UIColor.white
			
			
			self.contentView.addSubview(label)
			self.page0Label1 = label
		}
		
		do {
			let imageView = UIImageView()
			imageView.image = UIImage(named: "onboarding1-1")
			
			self.contentView.addSubview(imageView)
			self.page0ImageView0 = imageView
		}
		
		do {
			let label = UILabel()
			label.text = "I am Mi !"
			label.textAlignment = .right
			label.numberOfLines = 0
			label.font = titleFont
			label.textColor = UIColor.white
			
			
			self.contentView.addSubview(label)
			self.page1Label0 = label
		}
		
		do {
			let label = UILabel()
			label.text = "I will grow up\nwhen you exercise"
			label.textAlignment = .right
			label.numberOfLines = 0
			label.font = descriptionFont
			label.textColor = UIColor.white
			
			
			self.contentView.addSubview(label)
			self.page1Label1 = label
		}
		
		do {
			let label = UILabel()
			label.text = "HealthKit"
			label.textAlignment = .center
			label.numberOfLines = 0
			label.font = titleFont
			label.textColor = UIColor.white
			
			
			self.contentView.addSubview(label)
			self.page2Label0 = label
		}
		
		do {
			let label = UILabel()
			label.text = "I read from HealthKit\nso that you won't lose any pieces of your workout data"
			label.textAlignment = .center
			label.numberOfLines = 0
			label.font = descriptionFont
			label.textColor = UIColor.white
			
			
			self.contentView.addSubview(label)
			self.page2Label1 = label
		}
		
		do {
			let imageView = UIImageView()
			imageView.image = UIImage(named: "onboarding1-2")
			
			self.contentView.addSubview(imageView)
			self.page2ImageView0 = imageView
		}
		
		do {
			let button = UIButton(type: .system)
			button.setTitle("Grant Access".uppercased(), for: .normal)
			button.tintColor = UIColor.primaryColor
			button.backgroundColor = UIColor.secondaryColor
			button.titleLabel?.font = buttonFont
			button.addTarget(self, action: #selector(grantHealthKitAccess), for: .touchUpInside)
			
			let layer = button.layer
			layer.borderColor = UIColor.primaryColor.cgColor
			layer.borderWidth = 3
			
			self.contentView.addSubview(button)
			self.page2Button0 = button
		}
		
		do {
			let label = UILabel()
			label.text = "Privacy".uppercased()
			label.textAlignment = .center
			label.numberOfLines = 0
			label.font = titleFont
			label.textColor = UIColor.white
			
			
			self.contentView.addSubview(label)
			self.page3Label0 = label
		}
		
		do {
			let label = UILabel()
			label.text = "Your health data won't be shared with any one. Do check out the complete privacy policy below."
			label.textAlignment = .center
			label.numberOfLines = 0
			label.font = descriptionFont
			label.textColor = UIColor.white
			
			
			self.contentView.addSubview(label)
			self.page3Label1 = label
		}
		
		do {
			let button = UIButton(type: .system)
			button.setTitle("Privacy Policy".uppercased(), for: .normal)
			button.tintColor = UIColor.primaryColor
			button.backgroundColor = UIColor.secondaryColor
			button.titleLabel?.font = buttonFont
			button.addTarget(self, action: #selector(openPrivacyPolicy), for: .touchUpInside)
			
			let layer = button.layer
			layer.borderColor = UIColor.primaryColor.cgColor
			layer.borderWidth = 3
			
			self.contentView.addSubview(button)
			self.page3Button0 = button
		}
		
		do {
			let label = UILabel()
			label.text = "HealthKit access must be granted\nbefore you can start."
			label.textAlignment = .center
			label.numberOfLines = 0
			label.font = captionFont
			label.textColor = UIColor.white
			
			
			self.contentView.addSubview(label)
			self.page3Label2 = label
		}

		
		do {
			let button = UIButton(type: .system)
			button.setTitle("Grant Access".uppercased(), for: .normal)
			button.tintColor = UIColor.primaryColor
			button.backgroundColor = UIColor.secondaryColor
			button.titleLabel?.font = buttonFont
			button.titleLabel?.numberOfLines = 0
			button.addTarget(self, action: #selector(start), for: .touchUpInside)
			
			let layer = button.layer
			layer.borderColor = UIColor.primaryColor.cgColor
			layer.borderWidth = 3
			
			self.contentView.addSubview(button)
			self.page3Button1 = button
		}

	}
	
	private func configureAnimations() {
		self.configureAnimationPageControl()
		
		self.configureAnimationPage0Label0()
		self.configureAnimationPage0Label1()
		self.configureAnimationPage0ImageView0()
		
		self.configureAnimationPage1Label0()
		self.configureAnimationPage1Label1()
		
		self.configureAnimationPage2Label0()
		self.configureAnimationPage2Label1()
		self.configureAnimationPage2ImageView0()
		self.configureAnimationPage2Button0()
		
		self.configureAnimationPage3Label0()
		self.configureAnimationPage3Label1()
		self.configureAnimationPage3Button0()
		self.configureAnimationPage3Label2()
		self.configureAnimationPage3Button1()
	}
	
	private func configureAnimationPageControl() {
		self.pageControl.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.4)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.9)
		})
		
		self.keepView(self.pageControl, onPages: [0, 1, 2, 3])
	}
	
	private func configureAnimationPage0Label0() {
		self.page0Label0.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.8)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.2)
		})
		
		self.keepView(self.page0Label0, onPages: [0, -0.3], atTimes:[0, 1])
	}
	
	private func configureAnimationPage0Label1() {
		self.page0Label1.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.9)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.4)
		})
		
		self.keepView(self.page0Label1, onPages: [0, -1], atTimes:[0, 1])
	}
	
	private func configureAnimationPage0ImageView0() {
		self.page0ImageView0.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.48)
			_ = make?.height.equalTo()(self.page0ImageView0.mas_width)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(0.7)
		})
		
		let scaleAnimation = IFTTTScaleAnimation(view: self.page0ImageView0)!
		scaleAnimation.addKeyframe(forTime: 0, scale: 1, withEasingFunction: IFTTTEasingFunctionEaseInQuad)
		scaleAnimation.addKeyframe(forTime: 1, scale: 1.5, withEasingFunction: IFTTTEasingFunctionEaseInQuad)
		self.animator.addAnimation(scaleAnimation)
		
		let rotationAnimation = IFTTTRotationAnimation(view: self.page0ImageView0)!
		rotationAnimation.addKeyframe(forTime: 0, rotation: 0)
		rotationAnimation.addKeyframe(forTime: 0.5, rotation: -5)
		rotationAnimation.addKeyframe(forTime: 1, rotation: 0)
		rotationAnimation.addKeyframe(forTime: 2, rotation: 20)
		self.animator.addAnimation(rotationAnimation)

		self.keepView(self.page0ImageView0, onPages: [0, 0.85], atTimes: [0, 1])
	}
	
	private func configureAnimationPage1Label0() {
		self.page1Label0.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.8)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.4)
		})
		
		self.keepView(self.page1Label0, onPages: [1, 0.5], atTimes:[1, 2])
	}
	
	private func configureAnimationPage1Label1() {
		self.page1Label1.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.8)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.6)
		})
		
		self.keepView(self.page1Label1, onPages: [1, 0.5], atTimes:[1, 1.5])
	}
	
	private func configureAnimationPage2Label0() {
		self.page2Label0.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.8)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.0)
		})
		
		self.keepView(self.page2Label0, onPages: [2, 1.75], atTimes:[2, 3])
	}
	
	private func configureAnimationPage2Label1() {
		self.page2Label1.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.9)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.3)
		})
		
		self.keepView(self.page2Label1, onPages: [2, 2], atTimes:[2, 3])
	}
	
	private func configureAnimationPage2ImageView0() {
		self.page2ImageView0.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.48)
			_ = make?.height.equalTo()(self.page2ImageView0.mas_width)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(0.53)
		})
		
		self.keepView(self.page2ImageView0, onPages: [2, 1.5], atTimes: [2, 3])
	}
	
	private func configureAnimationPage2Button0() {
		self.page2Button0.mas_makeConstraints({
			make in
			_ = make?.height.equalTo()(80)
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.6)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.7)
		})
		
		self.keepView(self.page2Button0, onPages: [3, 2], atTimes:[1.5, 2])
	}

	
	private func configureAnimationPage3Label0() {
		self.page3Label0.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.9)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(0.3)
		})
		
		self.keepView(self.page3Label0, onPages: [3], atTimes:[3])
	}
	
	private func configureAnimationPage3Label1() {
		self.page3Label1.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.9)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(0.7)
		})
		
		self.keepView(self.page3Label1, onPages: [4, 3], atTimes:[2, 3])
	}
	
	private func configureAnimationPage3Button0() {
		self.page3Button0.mas_makeConstraints({
			make in
			_ = make?.height.equalTo()(80)
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.6)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.15)
		})
		
		self.keepView(self.page3Button0, onPages: [4, 3], atTimes:[2.5, 3])
	}
	
	private func configureAnimationPage3Label2() {
		self.page3Label2.mas_makeConstraints({
			make in
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.8)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.47)
		})
		
		self.keepView(self.page3Label2, onPages: [4, 3], atTimes:[2.75, 3])
	}
	
	private func configureAnimationPage3Button1() {
		self.page3Button1.mas_makeConstraints({
			make in
			_ = make?.height.equalTo()(80)
			_ = make?.width.equalTo()(self.scrollView)?.multipliedBy()(0.6)
			_ = make?.centerY.equalTo()(self.contentView)?.multipliedBy()(1.7)
		})
		
		self.keepView(self.page3Button1, onPages: [4, 3], atTimes:[2.875, 3])
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


// MARK: Actions
extension FMOnboardViewController {
	func grantHealthKitAccess() {
		FMHealthStatusManager.sharedManager.authorizeHealthKit {
			(authorized,  error) -> Void in
			DispatchQueue.main.sync {
				if authorized {
					self.page2Button0.setTitle("Request Prompted".uppercased(), for: .normal)
					self.page2Button0.isEnabled = false
					
					self.page3Button1.setTitle("Start".uppercased(), for: .normal)
					self.page3Label2.text = "By clicking start, you agree to the privacy policy above."
				} else {
					if error != nil {
						print("\(error)")
					}
				}
			}
		}
	}
	
	func start() {
		if self.page3Button1.title(for: .normal) == "START" {
			let storyBoard = UIStoryboard(name: "Main", bundle: nil)
			let rootVC = storyBoard.instantiateViewController(withIdentifier: "FMLoadingViewController")
			UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.3, options: [.transitionCrossDissolve], animations: {
				UIApplication.shared.keyWindow!.rootViewController = rootVC
			}, completion: nil)
			
		} else {
			self.grantHealthKitAccess()
		}
	}
	
	func openPrivacyPolicy() {
		let url = URL(string: "https://fitmi.club/privacy.html")!
		UIApplication.shared.openURL(url)
	}
}

extension FMOnboardViewController {
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		super.scrollViewDidScroll(scrollView)
		let width = scrollView.frame.size.width
		let x = scrollView.contentOffset.x
		self.pageControl.currentPage = Int(x / width)
	}
}
