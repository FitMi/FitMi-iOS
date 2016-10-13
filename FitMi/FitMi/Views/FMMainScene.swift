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
    
    private var backgroundAtlas = SKTextureAtlas()
    private var backgroundArray = [SKTexture]()
    private var normalSpriteAtlas = SKTextureAtlas()
    private var normalSpriteArray = [SKTexture]()
    private var sleepSpriteAtlas = SKTextureAtlas()
    private var sleepSpriteArray = [SKTexture]()
    private var touchSpriteAtlas = SKTextureAtlas()
    private var touchSpriteArray = [SKTexture]()
	private var defaultScale: CGFloat = 0.0
	private var isInHomeScreen = false
	var character = SKSpriteNode()
    var background = SKSpriteNode()
	
	
    override func didMove(to view: SKView) {
        self.loadCharacterSprites()
        self.loadBackgroundSprites()
        self.displayBackground()
        self.displayCharacter()
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
        
        self.touchSpriteAtlas = SKTextureAtlas(named: "sprite-touch")
        for i in 2...self.touchSpriteAtlas.textureNames.count {
            let name = "touch1-\(i).png"
            touchSpriteArray.append(SKTexture(imageNamed: name))
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
        self.character.position = CGPoint(x: -20, y: -130)
        self.isInHomeScreen = view == FMHomeViewController.getDefaultController().spriteView
        self.defaultScale = self.isInHomeScreen ? 1 : 0.8
        self.character.setScale(self.defaultScale)
        
        self.addChild(self.character)
        
        self.character.run(SKAction.repeatForever(SKAction.animate(with: self.normalSpriteArray, timePerFrame: 0.5, resize: true, restore: true)))
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
