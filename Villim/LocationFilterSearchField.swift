//
//  LocationFilterSearchField.swift
//  Villim
//
//  Created by Seongmin Park on 8/4/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class LocationFilterSearchField: UITextField {
    
    static let iconSize : CGFloat = 25.0

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: LocationFilterSearchField.iconSize * 1.5, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: LocationFilterSearchField.iconSize * 1.5, dy: 0)
    }

    
}
