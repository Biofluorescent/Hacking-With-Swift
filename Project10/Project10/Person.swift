//
//  Person.swift
//  Project10
//
//  Created by Tanner Quesenberry on 1/9/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
