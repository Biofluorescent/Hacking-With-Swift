//
//  GradientView.swift
//  Project37
//
//  Created by Tanner Quesenberry on 2/14/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

//Build class and make it draw in interface builder whenever changes are made.
@IBDesignable class GradientView: UIView {
    //exposes a property from your class as an editable value inside interface builder
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
