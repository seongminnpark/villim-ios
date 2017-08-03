//
//  HouseRulesViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class HousePolicyViewController: UIViewController {

    var housePolicy   : String! = ""
    
    var policyTitle   : UILabel!
    var policyContent : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = VillimValues.backgroundColor
        self.tabBarController?.title = NSLocalizedString("", comment: "")

        policyTitle = UILabel()
        policyTitle.text = NSLocalizedString("house_policy", comment: "")
        self.view.addSubview(policyTitle)
        
        policyContent = UILabel()
        policyContent.lineBreakMode = .byWordWrapping
        policyContent.numberOfLines = 0
        policyContent.text = housePolicy
        self.view.addSubview(policyContent)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        policyTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(topOffset)
        }
        
        policyContent?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(policyTitle.snp.bottom)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
