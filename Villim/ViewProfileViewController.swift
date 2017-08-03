//
//  ViewProfileViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ViewProfileViewController: UIViewController {

    var viewProfileTableViewController : ViewProfileTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = VillimValues.backgroundColor
        self.tabBarController?.title = NSLocalizedString("profile", comment: "")

        /* Tableview controller */
        viewProfileTableViewController = ViewProfileTableViewController()
        self.view.addSubview(viewProfileTableViewController.view)
        
        /* Set up edit button */
        self.setEditing(false, animated: false)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Tableview */
        viewProfileTableViewController.tableView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(topOffset)
            make.bottom.equalToSuperview()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        print("Here")
        super.setEditing(editing,animated:animated)
        if (self.isEditing) {
            self.editButtonItem.title = NSLocalizedString("done", comment:"")
        } else {
            self.editButtonItem.title = NSLocalizedString("edit", comment:"")
        }
    }

}
