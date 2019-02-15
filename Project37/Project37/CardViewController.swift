//
//  CardViewController.swift
//  Project37
//
//  Created by Tanner Quesenberry on 2/14/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    weak var delegate: ViewController!
    
    var front: UIImageView!
    var back: UIImageView!
    
    var isCorrect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Give precise size, two image views
        view.bounds = CGRect(x: 0, y: 0, width: 100, height: 140)
        front = UIImageView(image: UIImage(named: "cardBack"))
        back = UIImageView(image: UIImage(named: "cardBack"))
        
        view.addSubview(front)
        view.addSubview(back)
        
        //Front hidden by default
        front.isHidden = true
        back.alpha = 0
        
        //Back fading animation
        UIView.animate(withDuration: 0.2) {
            self.back.alpha = 1
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
