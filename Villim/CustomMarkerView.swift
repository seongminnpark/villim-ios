//
//  CustomMarkerView.swift
//  Villim
//
//  Created by Seongmin Park on 9/21/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Material

class CustomMarkerView: UIView {
    
    let COLOR_HIGHLIGHTED = Color.teal.base
    let COLOR_NORMAL      = Color.grey.lighten4
    
    var content : String! = "" {
        didSet{
            setLabel()
        }
    }
    
    var highlighted : Bool = false {
        didSet{
            setHighlighted()
        }
    }
    
    var label    : InsetLabel!
    var triangle : TriangleView!

    override init (frame : CGRect) {
        super.init(frame : frame)
        
        self.backgroundColor = .clear
        
        label = InsetLabel(dx: 10, dy: 10)
        label.text = content
        label.font = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        label.backgroundColor = Color.grey.lighten4
        label.textAlignment = .center
        label.depthPreset = .depth3
//        label.layer.cornerRadius = 10
//        label.layer.masksToBounds = true
        self.addSubview(label)
        
        label.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        setUpTriangleView(color:COLOR_NORMAL)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    func setLabel() {
        if label != nil {
            label.text = content
            label.sizeToFit()
            self.sizeToFit()
        }
    }
    
    func setHighlighted() {
        let color = self.highlighted ? COLOR_HIGHLIGHTED : COLOR_NORMAL
        
        if label != nil {
            label.backgroundColor = color
            setUpTriangleView(color:color)
        }
    }
    
    func setUpTriangleView(color:UIColor) {
        if triangle != nil {
            triangle.removeFromSuperview()
        }
        
        triangle = TriangleView()
        triangle.depthPreset = .depth3
        triangle.backgroundColor = .clear
        triangle.color = color
        self.addSubview(triangle)
        
        triangle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(label.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
            make.width.equalTo(20)
        }
    }

}
