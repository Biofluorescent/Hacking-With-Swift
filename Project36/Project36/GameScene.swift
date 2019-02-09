//
//  GameScene.swift
//  Project36
//
//  Created by Tanner Quesenberry on 2/7/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//
// Composed Methods programming methodology

import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        createSky()
        createPlayer()
        createBackground()
        createGround()
        startRocks()
        createScore()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
 
    //MARK: - Creation Methods
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        
        addChild(scoreLabel)
    }
    
    
    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(player)
        
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame2], timePerFrame: 0.01)
        
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever)
    }
    
    
    func createSky(){
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        //Default anchorpoint is 0.5, 0.5. The vertical/horizontal center
        //This will measure from center top instead
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        
        addChild(topSky)
        addChild(bottomSky)
        
        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }
    
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            //Position itself from left edge
            background.anchorPoint = CGPoint.zero
            //First loop x = 0. Second loop x = width of text - 1. Avoids gaps in mountain
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
    
    
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")
        
        for i in 0 ... 1{
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
    
    
    func createRocks() {
        //1. Create top/bottom rocks
        let rockTexture = SKTexture(imageNamed: "rock")
        
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.zRotation = .pi
        //-1.0 flips it
        topRock.xScale = -1.0
        
        let bottomRock = SKSpriteNode(texture: rockTexture)
        
        topRock.zPosition = -20
        bottomRock.zPosition = -20
        
        //2. Create large rectangle, to track player passing rocks safely
        let rockCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 32, height: frame.height))
        rockCollision.name = "scoreDetect"
        
        addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision)
        
        //3. Random number generator for safe gap position
        let xPosition = frame.width + topRock.frame.width
        let max = CGFloat(frame.height / 3)
        let yPosition = CGFloat.random(in: -50...max)
        
        //affects distance between each new set of rocks. Change for difficulty settings
        let rockDistance: CGFloat = 70
        
        //4. Position rocks off right edge of screen, animate to the left until off screen then remove
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
    }
    
    
    func startRocks() {
        let create = SKAction.run { [unowned self] in
            self.createRocks()
        }
        
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
    }
}
