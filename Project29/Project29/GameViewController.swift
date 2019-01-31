//
//  GameViewController.swift
//  Project29
//
//  Created by Tanner Quesenberry on 1/30/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var currentGame: GameScene!
    
    //Outlets
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var angleSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initial labels
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                //Set to initial game scene to use
                currentGame = scene as? GameScene
                //Let game scene know about view controller
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        velocitySlider.isHidden = true
        
        angleLabel.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        
        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    
    func activatePlayer(number: Int){
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        angleSlider.isHidden = false
        velocitySlider.isHidden = false
        
        angleLabel.isHidden = false
        velocityLabel.isHidden = false
        
        launchButton.isHidden = false
    }
    
}
