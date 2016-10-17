//
//  FMExerciseScene.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import SpriteKit
import GameplayKit

class FMExerciseScene: SKScene {
	
	private let spriteStatusManager = FMSpriteStatusManager.sharedManager
	
	private var normalSpriteAtlas = SKTextureAtlas()
	private var normalSpriteArray = [SKTexture]()
	private var tiredSpriteAtlas = SKTextureAtlas()
	private var tiredSpriteArray = [SKTexture]()
	private var sleepSpriteAtlas = SKTextureAtlas()
	private var sleepSpriteArray = [SKTexture]()
	private var touchSpriteAtlas = SKTextureAtlas()
	private var touchSpriteArray = [SKTexture]()
	private var wakeSpriteAtlas = SKTextureAtlas()
	private var wakeSpriteArray = [SKTexture]()
	private var runSpriteAtlas = SKTextureAtlas()
	private var runSpriteArray = [SKTexture]()
	
	private var defaultScale: CGFloat = 0.8
	private var isSleeping = false
	
	var character = SKSpriteNode()
	var background = SKSpriteNode()
	
	
	override func didMove(to view: SKView) {
		self.loadCharacterSprites()
		self.displayCharacter()
	}
	
	private func loadCharacterSprites() {
		self.normalSpriteAtlas = SKTextureAtlas(named: "sprite-relax")
		for i in 1...self.normalSpriteAtlas.textureNames.count {
			let name = "relax1-\(i).png"
			normalSpriteArray.append(SKTexture(imageNamed: name))
		}
		
		self.tiredSpriteAtlas = SKTextureAtlas(named: "sprite-tired")
		for i in 1...self.tiredSpriteAtlas.textureNames.count {
			let name = "tired1-\(i).png"
			tiredSpriteArray.append(SKTexture(imageNamed: name))
		}
		
		self.sleepSpriteAtlas = SKTextureAtlas(named: "sprite-sleep")
		for i in 1...self.sleepSpriteAtlas.textureNames.count {
			let name = "sleep1-\(i).png"
			sleepSpriteArray.append(SKTexture(imageNamed: name))
		}
		
		self.wakeSpriteAtlas = SKTextureAtlas(named: "sprite-wake")
		for i in 2...self.wakeSpriteAtlas.textureNames.count {
			let name = "wake1-\(i).png"
			wakeSpriteArray.append(SKTexture(imageNamed: name))
		}
		
		self.touchSpriteAtlas = SKTextureAtlas(named: "sprite-touch")
		for i in 2...self.touchSpriteAtlas.textureNames.count {
			let name = "touch1-\(i).png"
			touchSpriteArray.append(SKTexture(imageNamed: name))
		}
		
		self.runSpriteAtlas = SKTextureAtlas(named: "sprite-run")
		for i in 1...self.runSpriteAtlas.textureNames.count {
			let name = "run1-\(i).png"
			runSpriteArray.append(SKTexture(imageNamed: name))
		}
	}
	
	private func displayCharacter() {
		self.character = SKSpriteNode(imageNamed: "relax1-1.png")
		self.character.size = CGSize(width: 400, height: 400)
		self.character.position = CGPoint(x: -20, y: 40)
		self.character.setScale(self.defaultScale)
		
		self.addChild(self.character)
		
		self.animateNormalSprite()
	}
	
	public func animateNormalSprite() {
		self.character.run(SKAction.repeat(SKAction.animate(with: self.normalSpriteArray, timePerFrame: 1, resize: true, restore: true), count: 3), completion: {() -> Void in
			self.animateTiredSprite()
		})
	}
	
	private func animateTiredSprite() {
		self.character.run(SKAction.animate(with: self.tiredSpriteArray, timePerFrame: 0.4, resize: true, restore: true), completion: {() -> Void in
			self.animateSleepSprite()
		})
	}
	
	private func animateSleepSprite() {
		self.isSleeping = true
		self.character.run(SKAction.repeatForever(SKAction.animate(with: self.sleepSpriteArray, timePerFrame: 0.5, resize: true, restore: true)))
	}
	
	private func animateWakeSprite() {
		self.character.run(SKAction.animate(with: self.wakeSpriteArray, timePerFrame: 0.5, resize: true, restore: true), completion: {() -> Void in
			self.animateNormalSprite()
		})
	}
	
	public func animateRunSprite() {
		self.character.run(SKAction.repeatForever(SKAction.animate(with: self.runSpriteArray, timePerFrame: 0.4, resize: true, restore: true)))
	}
	
	public func removeSpriteAnimation() {
		self.character.removeAllActions()
	}
}
