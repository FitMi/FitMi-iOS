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
	
	var character: SKSpriteNode!
	var background = SKSpriteNode()
	
	
	override func didMove(to view: SKView) {
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SPRITE_LOADED_NOTIFICATION"), object: nil, queue: nil, using: {
			_ in
			self.loadCharacterSprites()
			self.displayCharacter()
		})
	}
	
	private func loadCharacterSprites() {
		let sprite = FMSpriteStatusManager.sharedManager.sprite!
		
		normalSpriteArray = sprite.relaxAction.sprites().map { return SKTexture(image: $0) }
		tiredSpriteArray = sprite.tiredAction.sprites().map { return SKTexture(image: $0) }
		sleepSpriteArray = sprite.sleepAction.sprites().map { return SKTexture(image: $0) }
		wakeSpriteArray = sprite.wakeAction.sprites().map { return SKTexture(image: $0) }
		runSpriteArray = sprite.runAction.sprites().map { return SKTexture(image: $0) }
		touchSpriteArray = sprite.touchAction.sprites().map { return SKTexture(image: $0) }
	}
	
	private func displayCharacter() {
		if self.character == nil {
			self.character = SKSpriteNode(texture: normalSpriteArray.first)
			self.character.size = CGSize(width: 400, height: 400)
			self.character.position = CGPoint(x: -20, y: 40)
			self.character.setScale(self.defaultScale)
			
			self.addChild(self.character)
			
			self.animateNormalSprite()
		}
	}
	
	public func animateNormalSprite() {
		self.character.run(SKAction.repeat(SKAction.animate(with: self.normalSpriteArray, timePerFrame: 1, resize: false, restore: true), count: 3), completion: {() -> Void in
			self.animateTiredSprite()
		})
	}
	
	private func animateTiredSprite() {
		self.character.run(SKAction.animate(with: self.tiredSpriteArray, timePerFrame: 0.4, resize: false, restore: true), completion: {() -> Void in
			self.animateSleepSprite()
		})
	}
	
	private func animateSleepSprite() {
		self.isSleeping = true
		self.character.run(SKAction.repeatForever(SKAction.animate(with: self.sleepSpriteArray, timePerFrame: 0.5, resize: false, restore: true)))
	}
	
	private func animateWakeSprite() {
		self.character.run(SKAction.animate(with: self.wakeSpriteArray, timePerFrame: 0.5, resize: false, restore: true), completion: {() -> Void in
			self.animateNormalSprite()
		})
	}
	
	public func animateRunSprite() {
		self.character.run(SKAction.repeatForever(SKAction.animate(with: self.runSpriteArray, timePerFrame: 0.4, resize: false, restore: true)))
	}
	
	public func removeSpriteAnimation() {
		self.character.removeAllActions()
	}
}
