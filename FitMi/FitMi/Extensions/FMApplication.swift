//
//  FMApplication.swift
//  FitMi
//
//  Created by Jinghan Wang on 23/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import AVFoundation

class FMApplication: UIApplication {
	
	fileprivate var buttonSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "touch", ofType: "mp3")!)
	fileprivate var audioPlayer = AVAudioPlayer()
	
	override func sendAction(_ action: Selector, to target: Any?, from sender: Any?, for event: UIEvent?) -> Bool {
		
		if let _ = sender as? UIButton {
			do {
				try audioPlayer = AVAudioPlayer(contentsOf: buttonSoundURL)
				audioPlayer.play()
			} catch {
				print("Audio play failed")
			}
		}
		
		return super.sendAction(action, to: target, from: sender, for: event)
	}
}
