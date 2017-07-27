//
//  SlideButton.swift
//  Villim
//
//  Created by Seongmin Park on 7/27/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation
import UIKit

protocol SlideButtonDelegate{
    func buttonStatus(status:String, sender:SlideButton)
}

class SlideButton: UIView {
    
    let sliderInset : CGFloat = 3.0 // Diff between slider thumb and slider.
    
    var delegate: SlideButtonDelegate?
    
    var dragPointWidth: CGFloat = 60 {
        didSet{
            setStyle()
        }
    }
    
    var dragPointColor: UIColor = UIColor.darkGray {
        didSet{
            setStyle()
        }
    }
    
    var buttonColor: UIColor = UIColor.gray {
        didSet{
            setStyle()
        }
    }
    
    var buttonText: String = "UNLOCK" {
        didSet{
            setStyle()
        }
    }
    
    var imageName: UIImage = UIImage() {
        didSet{
            setStyle()
        }
    }
    
    var buttonTextColor: UIColor = UIColor.white {
        didSet{
            setStyle()
        }
    }
    
    var dragPointTextColor: UIColor = UIColor.white {
        didSet{
            setStyle()
        }
    }
    
    var buttonUnlockedTextColor: UIColor = UIColor.white {
        didSet{
            setStyle()
        }
    }
    
    var buttonCornerRadius: CGFloat = 30 {
        didSet{
            setStyle()
        }
    }
    
    var buttonUnlockedText: String   = "UNLOCKED"
    var buttonUnlockedColor: UIColor = UIColor.black
    var buttonFont                   = UIFont.boldSystemFont(ofSize: 17)
    
    
    var dragPoint            = UIView()
    var buttonLabel          = UILabel()
    var imageView            = UIImageView()
    var unlocked             = false
    var layoutSet            = false
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func layoutSubviews() {
        if !layoutSet{
            self.setUpButton()
            self.layoutSet = true
        }
    }
    
    func setStyle(){
        self.buttonLabel.text               = self.buttonText
        self.dragPoint.frame.size.width     = self.dragPointWidth
        self.dragPoint.backgroundColor      = self.dragPointColor
        self.backgroundColor                = self.buttonColor
        self.imageView.image                = imageName
        self.buttonLabel.textColor          = self.buttonTextColor
        
        self.dragPoint.layer.cornerRadius   = buttonCornerRadius
        self.layer.cornerRadius             = buttonCornerRadius
    }
    
    func setUpButton(){
        print("setupbutton")
        self.backgroundColor              = self.buttonColor
        
        self.dragPoint                    = UIView(frame: CGRect(x: sliderInset, y: sliderInset, width: self.frame.size.height - sliderInset*2, height: self.frame.size.height - sliderInset*2))
        self.dragPoint.backgroundColor    = dragPointColor
        self.dragPoint.layer.cornerRadius = buttonCornerRadius
        self.addSubview(self.dragPoint)
        
        if !self.buttonText.isEmpty{
            
            self.buttonLabel               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.buttonLabel.textAlignment = .center
            self.buttonLabel.text          = buttonText
            self.buttonLabel.textColor     = UIColor.white
            self.buttonLabel.font          = self.buttonFont
            self.buttonLabel.textColor     = self.buttonTextColor
            self.addSubview(self.buttonLabel)
        }
        self.bringSubview(toFront: self.dragPoint)
        
        if self.imageName != UIImage(){
            self.imageView = UIImageView(frame: dragPoint.frame)
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.image = self.imageName
            self.dragPoint.addSubview(self.imageView)
        }
        
        self.layer.masksToBounds = true
        
        // start detecting pan gesture
        let panGestureRecognizer                    = UIPanGestureRecognizer(target: self, action: #selector(self.panDetected(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        self.dragPoint.addGestureRecognizer(panGestureRecognizer)
    }
    
    func panDetected(sender: UIPanGestureRecognizer){
        print("pandetected")
        var translatedPoint = sender.translation(in: self)
        translatedPoint     = CGPoint(x: translatedPoint.x, y: self.frame.size.height / 2)
        if dragPointWidth + translatedPoint.x > self.frame.size.width - dragPointWidth {
            sender.view?.frame.origin.x = self.frame.size.width - dragPointWidth
        } else {
            sender.view?.frame.origin.x = dragPointWidth + translatedPoint.x
        }
        
        if sender.state == .ended{
            
            let velocityX = sender.velocity(in: self).x * 0.2
            var finalX    = translatedPoint.x + velocityX
            if finalX < 0{
                finalX = 0
            } else if finalX + self.dragPointWidth  >  self.frame.size.width {
                unlocked = true
                self.unlock()
            }
            
            let animationDuration:Double = abs(Double(velocityX) * 0.0002) + 0.2
            UIView.transition(with: self, duration: animationDuration, options: UIViewAnimationOptions.curveEaseOut, animations: {
            }, completion: { (Status) in
                if Status{
                    self.animationFinished()
                }
            })
        }
    }
    
    func animationFinished(){
        self.reset()
    }
    
    //lock button animation (SUCCESS)
    func unlock(){
        print("unlock")
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.frame.size.width - self.dragPoint.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status{
//                self.imageView.isHidden               = true
//                self.dragPoint.backgroundColor      = self.buttonUnlockedColor
//                self.delegate?.buttonStatus(status: "Unlocked", sender: self)
            }
        }
    }
    
    //reset button animation (RESET)
    func reset(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: 0, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status{
//                self.imageView.isHidden               = false
//                self.dragPoint.backgroundColor      = self.dragPointColor
//                self.unlocked                       = false
                //self.delegate?.buttonStatus("Locked")
            }
        }
    }
}
