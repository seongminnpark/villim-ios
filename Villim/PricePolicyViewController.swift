//
//  PricePolicyViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class PricePolicyViewController: UIViewController {

    let cellHeight         : CGFloat! = 150.0
    
    var cleaningFee        : Int!
    
    var policyTitle        : UILabel!
    var rentTitle          : UILabel!
    var rentContent        : UILabel!
    var utilityTitle       : UILabel!
    var utilityContent     : UILabel!
    var cleaningFeeTitle   : UILabel!
    var cleaningFeeContent : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = VillimValues.backgroundColor
        self.tabBarController?.title = NSLocalizedString("login", comment: "")
        
        policyTitle = UILabel()
        policyTitle.text = NSLocalizedString("price_policy", comment: "")
        self.view.addSubview(policyTitle)
        
        rentTitle = UILabel()
        rentTitle.text = NSLocalizedString("rent_title", comment: "")
        self.view.addSubview(rentTitle)
        
        rentContent = UILabel()
        rentContent.lineBreakMode = .byWordWrapping
        rentContent.numberOfLines = 0;
        rentContent.text = NSLocalizedString("rent_content", comment: "")
        self.view.addSubview(rentContent)
        
        utilityTitle = UILabel()
        utilityTitle.text = NSLocalizedString("utility_fee_title", comment: "")
        self.view.addSubview(utilityTitle)
        
        utilityContent = UILabel()
        utilityContent.lineBreakMode = .byWordWrapping
        utilityContent.numberOfLines = 0;
        utilityContent.text = NSLocalizedString("utility_fee_content", comment: "")
        self.view.addSubview(utilityContent)
        
        cleaningFeeTitle = UILabel()
        cleaningFeeTitle.text = NSLocalizedString("cleaning_fee_title", comment: "")
        self.view.addSubview(cleaningFeeTitle)
        
        cleaningFeeContent = UILabel()
        cleaningFeeContent.lineBreakMode = .byWordWrapping
        cleaningFeeContent.numberOfLines = 0;
        cleaningFeeContent.text = VillimUtils.getCurrencyString(price: cleaningFee)
        self.view.addSubview(cleaningFeeContent)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        policyTitle?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(topOffset)
            make.left.equalToSuperview()
        }
        
        rentTitle?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(policyTitle.snp.bottom)
            make.left.equalToSuperview()
        }
        
        rentContent?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(rentTitle.snp.bottom)
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(cellHeight)
        }
        
        utilityTitle?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(rentContent.snp.bottom)
            make.left.equalToSuperview()
        }
        
        utilityContent?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(utilityTitle.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(cellHeight)
            make.left.equalToSuperview()
        }
        
        cleaningFeeTitle?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(utilityContent.snp.bottom)
            make.left.equalToSuperview()
        }
        
        cleaningFeeContent?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cleaningFeeTitle.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(cellHeight)
            make.left.equalToSuperview()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = CGFloat(1.0)
        
        /* Rent bottom border */
        let rentBorder = CALayer()
        rentBorder.borderColor = VillimValues.dividerColor.cgColor
        rentBorder.frame = CGRect(x: 0, y: rentContent.frame.size.height - width, width:  rentContent.frame.size.width, height: rentContent.frame.size.height)
        rentBorder.backgroundColor = UIColor.clear.cgColor
        rentBorder.borderWidth = width
        rentContent.layer.addSublayer(rentBorder)
        rentContent.layer.masksToBounds = true
        
        /* Utility fee bottom border */
        let utilityBorder = CALayer()
        utilityBorder.borderColor = VillimValues.dividerColor.cgColor
        utilityBorder.frame = CGRect(x: 0, y: utilityContent.frame.size.height - width, width:  utilityContent.frame.size.width, height: utilityContent.frame.size.height)
        utilityBorder.backgroundColor = UIColor.clear.cgColor
        utilityBorder.borderWidth = width
        utilityContent.layer.addSublayer(utilityBorder)
        utilityContent.layer.masksToBounds = true
        
        /* Cleaning fee bottom border */
        let cleaningFeeBorder = CALayer()
        cleaningFeeBorder.borderColor = VillimValues.dividerColor.cgColor
        cleaningFeeBorder.frame = CGRect(x: 0, y: cleaningFeeContent.frame.size.height - width,
                                    width:  cleaningFeeContent.frame.size.width, height: cleaningFeeContent.frame.size.height)
        cleaningFeeBorder.backgroundColor = UIColor.clear.cgColor
        cleaningFeeBorder.borderWidth = width
        cleaningFeeContent.layer.addSublayer(cleaningFeeBorder)
        cleaningFeeContent.layer.masksToBounds = true
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
