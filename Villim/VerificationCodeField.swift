//
//  VerificationCodeField.swift
//  Villim
//
//  Created by Seongmin Park on 8/4/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class VerificationCodeField: UITextField {

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
}
