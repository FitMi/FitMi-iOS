//
//  FMMainScene.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import SpriteKit
import GameplayKit

class FMMainScene: SKScene {
    
    private let spriteStatusManager = FMSpriteStatusManager.sharedManager
    
    private var backgroundAtlas = SKTextureAtlas()
    private var backgroundArray = [SKTexture]()
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
    
	private var defaultScale: CGFloat = 1.0
    private var isSleeping = false
	
	var character: SKSpriteNode!
    var background = SKSpriteNode()
	
	private var firstWakeTexture: SKTexture?
	private var firstTouchTexture: SKTexture?
	
	
    override func didMove(to view: SKView) {
        self.loadBackgroundSprites()
		self.displayBackground()
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SPRITE_LOADED_NOTIFICATION"), object: nil, queue: nil, using: {
			_ in
			self.loadCharacterSprites()
			self.displayCharacter()
		})
	}
    
    private func loadBackgroundSprites() {
        self.backgroundAtlas = SKTextureAtlas(named: "background-01")
        for i in 1...self.backgroundAtlas.textureNames.count {
            let name = "background01-\(i).png"
            self.backgroundArray.append(SKTexture(imageNamed: name))
        }
    }
    
	func loadCharacterSprites() {
		
		let sprite = FMSpriteStatusManager.sharedManager.sprite!
		
		normalSpriteArray = sprite.relaxAction.sprites().map { return SKTexture(image: $0) }
		tiredSpriteArray = sprite.tiredAction.sprites().map { return SKTexture(image: $0) }
		sleepSpriteArray = sprite.sleepAction.sprites().map { return SKTexture(image: $0) }
		wakeSpriteArray = sprite.wakeAction.sprites().map { return SKTexture(image: $0) }
		runSpriteArray = sprite.runAction.sprites().map { return SKTexture(image: $0) }
		touchSpriteArray = sprite.touchAction.sprites().map { return SKTexture(image: $0) }
		
		self.firstWakeTexture = wakeSpriteArray.removeFirst()
		self.firstTouchTexture = touchSpriteArray.removeFirst()
    }
    
    private func displayBackground() {
        self.background = SKSpriteNode(imageNamed: "background01-1.png")
        self.background.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.background.zPosition = -1
		self.background.position = CGPoint(x: 0, y: 80)
        self.addChild(self.background)
        self.background.setScale(self.frame.height / 1200)
        self.background.run(SKAction.repeatForever(SKAction.animate(with: self.backgroundArray, timePerFrame: 2, resize: false, restore: true)))
    }
    
    private func displayCharacter() {
		if self.character == nil {
			self.character = SKSpriteNode(texture: normalSpriteArray.first)
			self.character.size = CGSize(width: 400, height: 400)
			self.character.position = CGPoint(x: -20, y: -100)
			self.character.setScale(self.defaultScale)
			
			self.addChild(self.character)
		}
    }
	
    func animateNormalSprite() {
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
    
    private func animateTouchSprite() {
        if (self.isSleeping) {
            self.character.texture = self.firstWakeTexture
        } else {
			self.character.texture = self.firstTouchTexture
        }
        
        let waitSound = SKAction.playSoundFileNamed("shocked.mp3", waitForCompletion: false)
        let touchSound = SKAction.sequence([SKAction.playSoundFileNamed("sweat.mp3", waitForCompletion: false), SKAction.wait(forDuration: 0.1)])
        let soundSequence = SKAction.sequence([waitSound, SKAction.wait(forDuration: 0.4), SKAction.repeatForever(touchSound)])
        self.character.run(soundSequence)
        
        self.character.setScale(0.95 * self.defaultScale)
        let wait = SKAction.wait(forDuration: 0.4)
        let touchAction = SKAction.repeatForever(SKAction.animate(with: self.touchSpriteArray, timePerFrame: 0.15, resize: false, restore: true))
        let sequence = SKAction.sequence([wait, touchAction])
        self.character.run(sequence)
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.character.removeAllActions()
		self.animateTouchSprite()
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.character.removeAllActions()
		self.character.setScale(self.defaultScale)
		if (self.isSleeping) {
			self.animateWakeSprite()
		} else {
			self.animateNormalSprite()
		}
		self.isSleeping = false
	}
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
