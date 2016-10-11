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
	
	
    override func didMove(to view: SKView) {
		self.textureAtlas = SKTextureAtlas(named: "sprite-relax")
		
		for i in 1...self.textureAtlas.textureNames.count {
			let name = "relax1-\((i + 6) % self.textureAtlas.textureNames.count + 1).png"
			textureArray.append(SKTexture(imageNamed: name))
		}
		
		self.character = SKSpriteNode(imageNamed: "relax1-8.png")
		self.character.size = CGSize(width: 400, height: 400)
		self.character.position = CGPoint(x: -15, y: 30)
		self.isInHomeScreen = view == FMHomeViewController.getDefaultController().spriteView
		self.defaultScale = self.isInHomeScreen ? 1 : 0.8
		self.character.setScale(self.defaultScale)
		
		self.addChild(self.character)
		
		self.character.run(SKAction.repeatForever(SKAction.animate(with: self.textureArray, timePerFrame: 0.5, resize: true, restore: true)))
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.character.removeAllActions()
		self.character.setScale(0.95 * self.defaultScale)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.character.setScale(self.defaultScale)
		self.character.run(SKAction.repeatForever(SKAction.animate(with: self.textureArray, timePerFrame: 0.5, resize: true, restore: true)))
	}
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
