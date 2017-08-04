//
//  PricePolicyViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class PricePolicyViewController: UIViewController {

    let cellHeight         : CGFloat! = 100.0
    let sideMargin         : CGFloat! = 20
    
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
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = VillimValues.backgroundColor
//        self.title = NSLocalizedString("price_policy", comment:"")
        
        policyTitle = UILabel()
        policyTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        policyTitle.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        policyTitle.text = NSLocalizedString("price_policy", comment: "")
        self.view.addSubview(policyTitle)
        
        rentTitle = UILabel()
        rentTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        rentTitle.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        rentTitle.text = NSLocalizedString("rent_title", comment: "")
        self.view.addSubview(rentTitle)
        
        rentContent = UILabel()
        rentContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        rentContent.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        rentContent.lineBreakMode = .byWordWrapping
        rentContent.numberOfLines = 0
        rentContent.text = NSLocalizedString("rent_content", comment: "")
        self.view.addSubview(rentContent)
        
        utilityTitle = UILabel()
        utilityTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        utilityTitle.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        utilityTitle.text = NSLocalizedString("utility_fee_title", comment: "")
        self.view.addSubview(utilityTitle)
        
        utilityContent = UILabel()
        utilityContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        utilityContent.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        utilityContent.lineBreakMode = .byWordWrapping
        utilityContent.numberOfLines = 0
        utilityContent.text = NSLocalizedString("utility_fee_content", comment: "")
        self.view.addSubview(utilityContent)
        
        cleaningFeeTitle = UILabel()
        cleaningFeeTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        cleaningFeeTitle.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        cleaningFeeTitle.text = NSLocalizedString("cleaning_fee_title", comment: "")
        self.view.addSubview(cleaningFeeTitle)
        
        cleaningFeeContent = UILabel()
        cleaningFeeContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        cleaningFeeContent.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        cleaningFeeContent.lineBreakMode = .byWordWrapping
        cleaningFeeContent.numberOfLines = 0
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
            make.top.equalTo(topOffset + sideMargin * 0.3)
            make.left.equalToSuperview().offset(sideMargin)
        }
        
        rentTitle?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(policyTitle.snp.bottom).offset(sideMargin)
            make.left.equalToSuperview().offset(sideMargin)
        }
        
        rentContent?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(rentTitle.snp.bottom).offset(sideMargin * 0.2)
            make.right.equalToSuperview().offset(-sideMargin)
            make.left.equalToSuperview().offset(sideMargin)
            make.height.equalTo(100)
        }
        
        utilityTitle?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(rentContent.snp.bottom).offset(sideMargin * 0.75)
            make.left.equalToSuperview().offset(sideMargin)
        }
        
        utilityContent?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(utilityTitle.snp.bottom).offset(sideMargin * 0.2)
            make.right.equalToSuperview().offset(-sideMargin)
            make.height.equalTo(120)
            make.left.equalToSuperview().offset(sideMargin)
        }
        
        cleaningFeeTitle?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(utilityContent.snp.bottom).offset(sideMargin * 0.75)
            make.left.equalToSuperview().offset(sideMargin)
        }
        
        cleaningFeeContent?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cleaningFeeTitle.snp.bottom).offset(sideMargin * 0.2)
            make.right.equalToSuperview().offset(-sideMargin)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(sideMargin)
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
