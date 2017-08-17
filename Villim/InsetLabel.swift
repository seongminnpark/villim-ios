//
//  InsetLabel.swift
//  Villim
//
//  Created by Seongmin Park on 8/17/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {
    
    var insets = UIEdgeInsets()
    
    convenience init(insets: UIEdgeInsets) {
        self.init(frame: CGRect.zero)
        self.insets = insets
    }
    
    convenience init(dx: CGFloat, dy: CGFloat) {
        let insets = UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx)
        self.init(insets: insets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize  {
        var size = super.intrinsicContentSize
        size.width += insets.left + insets.right
        size.height += insets.top + insets.bottom
        return size
    }
}
