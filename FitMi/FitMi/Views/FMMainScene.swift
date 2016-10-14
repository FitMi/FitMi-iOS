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
	private var defaultScale: CGFloat = 0.0
	private var isInHomeScreen = false
	var character = SKSpriteNode()
    var background = SKSpriteNode()
    let healthIcon = SKSpriteNode(imageNamed: "health_icon.png")
    let healthBar = SKSpriteNode()
	
	
    override func didMove(to view: SKView) {
		self.isInHomeScreen = view == FMHomeViewController.getDefaultController().spriteView
		
        self.loadCharacterSprites()
        self.loadBackgroundSprites()
		
		if isInHomeScreen {
			self.displayBackground()
		}
		
        self.displayCharacter()
        self.initializeStatusBar()
        self.initializeHealthBar()
	}
    
    private func initializeStatusBar() {
        let statusBar = SKSpriteNode()
        let height = CGFloat(80)
        statusBar.size = CGSize(width: self.frame.width, height: height)
        statusBar.position = CGPoint(x: 0, y: self.frame.height / 2 - height / 2)
        statusBar.color = UIColor.secondaryColor
        statusBar.zPosition = 0
        self.addChild(statusBar)
    }
    
    private func initializeHealthBar() {
        let healthBarY = self.frame.height / 2 - 40
        let HPColour = UIColor(red: 133 / 255.0, green: 239 / 255.0, blue: 163 / 255.0, alpha: 1)
        
        self.healthIcon.zPosition = 2
        self.healthIcon.position = CGPoint(x: -130, y: healthBarY)
        self.addChild(healthIcon)
        
        self.healthBar.color = HPColour
        self.healthBar.zPosition = 2
        self.addChild(healthBar)
        
        let healthBarBorder = SKSpriteNode(imageNamed: "bar_border.png")
        healthBarBorder.position = CGPoint(x: 40, y: healthBarY)
        healthBarBorder.zPosition = 1
        self.addChild(healthBarBorder)
    }
    
    func updateHealthBar(health: Int) {
        let maxHP = 100
        let healthBarMaxLength = 256
        let healthBarLength = healthBarMaxLength * health / maxHP
        let healthBarX = (CGFloat(healthBarLength) - 256) / 2 + 40
        let healthBarY = self.frame.height / 2 - 40
        healthBar.size = CGSize(width: healthBarLength, height: 20)
        healthBar.position = CGPoint(x: healthBarX, y: healthBarY)
    }
    
    private func loadBackgroundSprites() {
        self.backgroundAtlas = SKTextureAtlas(named: "background-01")
        for i in 1...self.backgroundAtlas.textureNames.count {
            let name = "background01-\(i).png"
            self.backgroundArray.append(SKTexture(imageNamed: name))
        }
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
        for i in 1...self.wakeSpriteAtlas.textureNames.count {
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
    
    private func displayBackground() {
        self.background = SKSpriteNode(imageNamed: "background01-1.png")
        self.background.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.background.zPosition = -1
        self.addChild(self.background)
        self.background.setScale(self.frame.height / 1200)
        self.background.run(SKAction.repeatForever(SKAction.animate(with: self.backgroundArray, timePerFrame: 2, resize: true, restore: true)))
    }
    
    private func displayCharacter() {
        self.character = SKSpriteNode(imageNamed: "relax1-1.png")
        self.character.size = CGSize(width: 400, height: 400)
		
		if isInHomeScreen {
			self.character.position = CGPoint(x: -20, y: -180)
		} else {
			self.character.position = CGPoint(x: -20, y: 40)
		}
		
        self.defaultScale = self.isInHomeScreen ? 1 : 0.8
        self.character.setScale(self.defaultScale)
        
        self.addChild(self.character)
        
        self.animateNormalSprite()
    }
    
    private func animateNormalSprite() {
        self.character.run(SKAction.repeat(SKAction.animate(with: self.normalSpriteArray, timePerFrame: 0.5, resize: true, restore: true), count: 5))
    }
    
    private func animateSleepSprite() {
        //self.character.run(SKAction.animate(with: self))
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.character.removeAllActions()

        self.character.texture = SKTexture(imageNamed: "touch1-1.png")
		self.character.setScale(0.95 * self.defaultScale)
        let wait = SKAction.wait(forDuration: 0.4)
        let touchAction = SKAction.repeatForever(SKAction.animate(with: self.touchSpriteArray, timePerFrame: 0.2, resize: true, restore: true))
        let sequence = SKAction.sequence([wait, touchAction])
        self.character.run(sequence)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.character.setScale(self.defaultScale)
		self.character.run(SKAction.repeatForever(SKAction.animate(with: self.normalSpriteArray, timePerFrame: 0.5, resize: true, restore: true)))
	}
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
