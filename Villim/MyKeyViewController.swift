//
//  MyKeyViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/9/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import Nuke

class MyKeyViewController: ViewController {
    
    var reviewButton : UIButton!
    var changePasscodeButton: UIButton!
    var roomName : UILabel!
    var roomDate : UILabel!
    
    var slideButton : SlideButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        self.title = "내 열쇠"
        
        slideButton = SlideButton(frame:CGRect(x:10,y:300, width:300, height:50))
        slideButton.backgroundColor = UIColor.black
        self.view.addSubview(slideButton)
        
//        makeConstraints()
    }
    
    func populateViews() {
        
    }
    
    func makeConstraints() {
        slideButton?.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
