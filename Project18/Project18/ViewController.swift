//
//  ViewController.swift
//  Project18
//
//  Created by Tanner Quesenberry on 1/16/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Simple debug
        print(1, 2, 3, 4, 5, separator: "-")
        
        //Debug with assert. Use liberally. Automatically disable in release build
        assert(1 == 1, "Maths failure!")
        // assert(1 == 2, "Maths failure!")
        
        //Breakpoint debugging.
        //Press Fn+F6 to Step Over
        // (Ctrl+Cmd+Y) to continue until another breakpoint
        for i in 1 ... 100 {
            print("Got number \(i)")
        }
        
        //Breakpoints can be made conditional. Right click on breakpoint.
        //Breakpoints can be automatically triggered when an exception is thrown.
        // - Press Cmd+8 to choose breakpoint navigator, press + button in bottom left corner
        // and choose "Exception Breakpoint"
        
        
        //View Debugging
        //Option 1. View Debugging > Show View Frames
        //Option 2. Capture View Hierarchy
    }


}

