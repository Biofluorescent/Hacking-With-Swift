//
//  GameScene.swift
//  Project20
//
//  Created by Tanner Quesenberry on 1/17/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var gameTimer: Timer!
    var fireworks = [SKNode]()
    var scoreLabel: SKLabelNode!
    
    //Where fireworks launch from
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 50, y: 25)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }

    
    override func update(_ currentTime: TimeInterval) {
        //Loop backwards when removing so objects are not skipped over
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                //High position so rockets explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    
    func checkTouches(_ touches: Set<UITouch>){
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node is SKSpriteNode {
                let sprite = node as! SKSpriteNode
                
                if sprite.name == "firework" {
                    
                    //Deselect fireworks that are a different color than currently tapped firework
                    for parent in fireworks {
                        let firework = parent.children[0] as! SKSpriteNode
                        
                        if firework.name == "selected" && firework.color != sprite.color {
                            firework.name = "firework"
                            firework.colorBlendFactor = 1
                        }
                    }
                    sprite.name = "selected"
                    sprite.colorBlendFactor = 0
                }
            }
        }
        
    }
    
    
    @objc func launchFireworks(){
        let movementAmount:  CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            //fire five up
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            //fire five in a fan
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFireworks(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFireworks(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFireworks(xMovement: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            //Fire five left to right
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            
        case 3:
            //Fire five right to left
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
    }
    
    
    func createFireworks(xMovement: CGFloat, x: Int, y: Int){
        //1. Create and position firework container
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        //2. Create rocket sprite node, add to container
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        //3. Give random color
        switch Int.random(in: 0 ... 2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        default:
            break
        }
        
        //4. Create bezier path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        //5. Tell container to follow path
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        //6. Create particle behind firework
        let emitter = SKEmitterNode(fileNamed: "fuse")!
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)
        
        //7. Add firework container to array and scene
        fireworks.append(node)
        addChild(node)
    }
    
    
    func explode(firework: SKNode){
        let emitter = SKEmitterNode(fileNamed: "explode")!
        emitter.position = firework.position
        addChild(emitter)
        
        firework.removeFromParent()
    }
    
    
    func explodeFireworks(){
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            let firework = fireworkContainer.children[0] as! SKSpriteNode
            
            if firework.name == "selected" {
                //destroy it!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
    
    
}
