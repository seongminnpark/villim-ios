//
//  CustomFormField.swift
//  Villim
//
//  Created by Seongmin Park on 8/4/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    static let iconSize : CGFloat = 25.0
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: CustomTextField.iconSize * 1.5, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: CustomTextField.iconSize * 1.5, dy: 0)
    }


}
