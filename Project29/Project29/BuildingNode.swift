//
//  BuildingNode.swift
//  Project29
//
//  Created by Tanner Quesenberry on 1/30/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import SpriteKit

class BuildingNode: SKSpriteNode {

    var currentImage: UIImage!
    
    
    //Basic building setup
    func setup() {
        name = "building"
        
        currentImage = drawBuilding(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    
    //Set sprites per-pixel physics
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    
    func drawBuilding(size: CGSize) -> UIImage {
        //1. Create a new Core Graphics context the size of our building
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { (ctx) in
            
            //2. Fill with rectangle of 3 different colors
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            var color: UIColor
            
            switch Int.random(in: 0...2){
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            //3. Draw windows on building in two colors
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            for row in stride(from: 10, to: Int(size.height - 10), by: 40){
                for col in stride(from: 10, to: Int(size.width - 10), by: 40){
                    if Bool.random() {
                        ctx.cgContext.setFillColor(lightOnColor.cgColor)
                    }else {
                        ctx.cgContext.setFillColor(lightOffColor.cgColor)
                    }
                    
                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }
            
            //4. Return UIImage result for use elsewhere
        }
        
        return img
    }
    
    
}
