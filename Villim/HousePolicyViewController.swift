//
//  HouseRulesViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class HousePolicyViewController: UIViewController {

    let sideMargin : CGFloat = 20.0
    
    var housePolicy   : String! = ""
    
    var policyTitle   : UILabel!
    var policyContent : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = VillimValues.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = VillimValues.backgroundColor

        policyTitle = UILabel()
        policyTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        policyTitle.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        policyTitle.text = NSLocalizedString("house_policy", comment: "")
        self.view.addSubview(policyTitle)
        
        policyContent = UILabel()
        policyContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        policyContent.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        policyContent.lineBreakMode = .byWordWrapping
        policyContent.numberOfLines = 0
        policyContent.text = housePolicy
        policyContent.sizeToFit()
        self.view.addSubview(policyContent)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        policyTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(sideMargin)
            make.top.equalTo(self.view).offset(topOffset + sideMargin * 0.3)
            make.height.equalTo(20)
        }
        
        policyContent?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(sideMargin)
            make.right.equalToSuperview().offset(-sideMargin)
            make.top.equalTo(policyTitle.snp.bottom).offset(sideMargin)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }


}
