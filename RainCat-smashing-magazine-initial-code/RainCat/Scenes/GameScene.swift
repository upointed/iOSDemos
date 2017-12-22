//
//  GameScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit
import SceneKit

protocol GameSceneDelegate {
    func moveEnd();
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var interactionDelegate: GameSceneDelegate?
    
    private var lastUpdateTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.5

    private let backgroundNode = BackgroundNode()
    
    let raindropTexture = SKTexture(imageNamed: "rain_drop")
    private let umbrellaNode = UmbrellaSprite.newInstance()
    
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        
        var worldFrame = frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        
        self.physicsWorld.contactDelegate = self
        
        let skyNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: size))
        skyNode.fillColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)
        skyNode.strokeColor = SKColor.clear
        skyNode.zPosition = 0
        
        let groundSize = CGSize(width: size.width, height: size.height * 0.35)
        let groundNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: groundSize))
        groundNode.fillColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
        groundNode.strokeColor = SKColor.clear
        groundNode.zPosition = 1
        
        addChild(skyNode)
        addChild(groundNode)
        
//        umbrellaNode.position = CGPoint(x: frame.midX, y: frame.midY)
        umbrellaNode.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
        umbrellaNode.zPosition = 4
        addChild(umbrellaNode)

        
    }
    private func spawnRaindrop() {
        let raindrop = SKSpriteNode(texture: raindropTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
//        raindrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
        let yPosition = size.height + raindrop.size.height
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        
        raindrop.physicsBody?.categoryBitMask = RainDropCategory
        raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory
        
        raindrop.zPosition = 2
        
        addChild(raindrop)
    }
    


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        spawnRaindrop()
    
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
    
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.interactionDelegate?.moveEnd()
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
          self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        // Update the Spawn Timer
        currentRainDropSpawnTime += dt
    
        if currentRainDropSpawnTime > rainDropSpawnRate {
            currentRainDropSpawnTime = 0
            spawnRaindrop()
        }


        self.lastUpdateTime = currentTime
        
        umbrellaNode.update(deltaTime: dt)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == RainDropCategory) {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        if contact.bodyA.categoryBitMask == WorldCategory {
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
        } else if contact.bodyB.categoryBitMask == WorldCategory {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
        }
    }
}
