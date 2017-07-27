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
    
    let slideButtonWidth  : CGFloat = 300.0
    let slideButtonHeight : CGFloat = 60.0
    
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
        
        let sliderLeft = UIScreen.main.bounds.width/2 - slideButtonWidth/2
        let sliderTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 1.5
        slideButton = SlideButton(frame:CGRect(x:sliderLeft,y:sliderTop, width:slideButtonWidth, height:slideButtonHeight))
        slideButton.backgroundColor = VillimUtils.themeColor
        slideButton.imageName = #imageLiteral(resourceName: "slider_thumb")
        slideButton.buttonText = NSLocalizedString("unlock_doorlock", comment: "")
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
