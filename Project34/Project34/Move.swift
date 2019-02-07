//
//  Move.swift
//  Project34
//
//  Created by Tanner Quesenberry on 2/7/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int){
        self.column = column
    }
    
}
