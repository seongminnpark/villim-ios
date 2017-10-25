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
    
    var content : String! = "" {
        didSet{
            setLabel()
        }
    }
    
    var color : UIColor = Color.grey.lighten4 {
        didSet{
            setColor()
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
        
        triangle = TriangleView()
        triangle.depthPreset = .depth3
        triangle.backgroundColor = .clear
        triangle.color = Color.grey.lighten4
        self.addSubview(triangle)
        
        label.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        triangle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(label.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
            make.width.equalTo(20)
        }

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
    
    func setColor() {
        if label != nil {
            label.backgroundColor = color
            triangle = TriangleView()
            triangle.depthPreset = .depth3
            triangle.backgroundColor = .clear
            triangle.color = color
        }
    }

}
