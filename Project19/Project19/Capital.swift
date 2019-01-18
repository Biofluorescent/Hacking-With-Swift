//
//  Capital.swift
//  Project19
//
//  Created by Tanner Quesenberry on 1/17/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import MapKit

//Map annotations described as a protocol. Must have coordinate
class Capital: NSObject, MKAnnotation {

    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String){
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
