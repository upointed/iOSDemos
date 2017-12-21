//
//  BackgroundNode.swift
//  RainCat
//
//  Created by user on 2017/12/21.
//  Copyright © 2017年 Thirteen23. All rights reserved.
//

import SpriteKit

class BackgroundNode: SKNode {
    public func setup(size : CGSize) {
        let yPos : CGFloat = size.height * 0.10
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint = CGPoint(x: size.width, y: yPos)
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.restitution = 0.3
        
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = RainDropCategory
        
    }
}
