//
//  TriangleView.swift
//  Villim
//
//  Created by Seongmin Park on 9/21/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Material

class TriangleView : UIView {
    
    var color : UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        context.closePath()
        if color != nil {
            print(color)
            color.setFill()
        } else {
            Color.grey.lighten4.setFill()
        }
        context.fillPath()
    }
}
