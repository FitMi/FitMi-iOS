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
    
    private var textureAtlas = SKTextureAtlas()
	private var textureArray = [SKTexture]()
	private var defaultScale: CGFloat = 0.0
	private var isInHomeScreen = false
	var character = SKSpriteNode()
    var background = SKSpriteNode()
	
	
    override func didMove(to view: SKView) {
        self.background = SKSpriteNode(imageNamed: "background-1.png")
        self.background.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.background.zPosition = -1
        self.addChild(self.background)
		
        self.textureAtlas = SKTextureAtlas(named: "sprite-relax")
		for i in 1...self.textureAtlas.textureNames.count {
			let name = "relax1-\(i).png"
			textureArray.append(SKTexture(imageNamed: name))
		}
		
		self.character = SKSpriteNode(imageNamed: "relax1-1.png")
		self.character.size = CGSize(width: 400, height: 400)
		self.character.position = CGPoint(x: -20, y: -130)
		self.isInHomeScreen = view == FMHomeViewController.getDefaultController().spriteView
		self.defaultScale = self.isInHomeScreen ? 1 : 0.8
		self.character.setScale(self.defaultScale)
		
		self.addChild(self.character)
		
		self.character.run(SKAction.repeatForever(SKAction.animate(with: self.textureArray, timePerFrame: 0.5, resize: true, restore: true)))
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.character.removeAllActions()
        self.textureAtlas = SKTextureAtlas(named: "sprite-touch")
        var touchTextureArray = [SKTexture]()
        
        for i in 2...self.textureAtlas.textureNames.count {
            let name = "touch1-\(i).png"
            touchTextureArray.append(SKTexture(imageNamed: name))
        }
        self.character.texture = SKTexture(imageNamed: "touch1-1.png")
		self.character.setScale(0.95 * self.defaultScale)
        let wait = SKAction.wait(forDuration: 0.4)
        let touchAction = SKAction.repeatForever(SKAction.animate(with: touchTextureArray, timePerFrame: 0.2, resize: true, restore: true))
        let sequence = SKAction.sequence([wait, touchAction])
        self.character.run(sequence)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.character.setScale(self.defaultScale)
		self.character.run(SKAction.repeatForever(SKAction.animate(with: self.textureArray, timePerFrame: 0.5, resize: true, restore: true)))
	}
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
