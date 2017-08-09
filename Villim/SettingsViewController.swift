//
//  SettnigsViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/8/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsDelegate {

    var tableviewController : SettingsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Set up navigation bar */
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.title = NSLocalizedString("settings", comment: "")
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        /* Tableview controller */
        tableviewController = SettingsTableViewController()
        tableviewController.settingsDelegate = self
        self.view.addSubview(tableviewController.view)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Tableview */
        tableviewController.view.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(topOffset)
            make.bottom.equalToSuperview()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func launchViewController(viewController:UIViewController, animated:Bool) {
        self.navigationController?.pushViewController(viewController, animated:animated)
    }

}
