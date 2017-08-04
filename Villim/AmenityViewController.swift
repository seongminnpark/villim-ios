//
//  AmenityViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/2/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class AmenityViewController: UIViewController {

    var amenities = [Int]()
    
    let sideMargin : CGFloat = 20.0
    
    private var amenityTitle : UILabel!
    private var amenityTableViewController : AmenityTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = VillimValues.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = VillimValues.backgroundColor
        
        /* Add Title */
        amenityTitle = UILabel()
        amenityTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        amenityTitle.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        amenityTitle.text = NSLocalizedString("amenity_title", comment: "")
        self.view.addSubview(amenityTitle)
        
        /* Populate tableview */
        amenityTableViewController = AmenityTableViewController()
        amenityTableViewController.amenities = self.amenities
        self.view.addSubview(amenityTableViewController.view)
        
        makeConstraints()

    }

    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Amenity title */
        amenityTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(sideMargin)
            make.top.equalTo(self.view).offset(topOffset + sideMargin * 0.3)
        }
        
        /* Tableview */
        amenityTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(sideMargin)
            make.right.equalToSuperview().offset(-sideMargin)
            make.top.equalTo(amenityTitle.snp.bottom).offset(sideMargin)
            make.bottom.equalTo(self.view)
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
