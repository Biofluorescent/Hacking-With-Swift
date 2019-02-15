//
//  ViewController.swift
//  Project37
//
//  Created by Tanner Quesenberry on 2/14/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cardContainer: UIView!
    
    var allCards = [CardViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCards()
    }

    @objc func loadCards() {
        //Clear out for new cards
        for card in allCards {
            card.view.removeFromSuperview()
            card.removeFromParent()
        }
        
        allCards.removeAll(keepingCapacity: true)
        
        //create an array of card positions
        let positions = [
            CGPoint(x: 75, y: 85),
            CGPoint(x: 185, y: 85),
            CGPoint(x: 295, y: 85),
            CGPoint(x: 405, y: 85),
            CGPoint(x: 75, y: 235),
            CGPoint(x: 185, y: 235),
            CGPoint(x: 295, y: 235),
            CGPoint(x: 405, y: 235)
        ]
        
        //load and unwrap our Zener card images
        let circle = UIImage(named: "cardCircle")
        let cross = UIImage(named: "cardCross")
        let lines = UIImage(named: "cardLines")
        let square = UIImage(named: "cardSquare")
        let star = UIImage(named: "cardStar")
        
        //create an empty array of the images, one for each card, then shuffle it
        var images = [circle, circle, cross, cross, lines, lines, square, star]
        images.shuffle()
        
        for (index, position) in positions.enumerated() {
            // loop over each card position and create a new card view controller
            let card = CardViewController()
            card.delegate = self
            
            //use view controller containment and also add the card's view to our cardContainer view
            addChild(card)
            cardContainer.addSubview(card.view)
            card.didMove(toParent: self)
            
            //position the card appropriately, then give it an image from our array
            card.view.center = position
            card.front.image = images[index]
            
            //if we just gave the new card the star image, mark this as the correct answer
            if card.front.image == star {
                card.isCorrect = true
            }
            
            //add the new card view controller to our array for easier tracking
            allCards.append(card)
        }
        
    }

}

