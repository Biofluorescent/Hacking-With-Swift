//
//  WhackSlot.swift
//  Porject14
//
//  Created by Tanner Quesenberry on 1/15/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//
import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        //Place slightly higher than hole an in front of other nodes
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        //Create penguin and "hide" in hole at -90
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        //Cropnode only crops nodes that are inside it
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    
    func show(hideTime: Double){
        if isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        }else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [unowned self] in
            self.hide()
        }
    }
    
    
    func hide(){
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit(){
        isHit = true
        //wait a moment, hide penguin, st invisible
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run{ [unowned self] in self.isVisible = false  }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
}
