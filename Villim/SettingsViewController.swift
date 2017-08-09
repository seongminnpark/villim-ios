//
//  SettnigsViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/8/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var tableviewController : SettingsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Set up navigation bar */
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        
        self.title = NSLocalizedString("settings", comment: "")
        
        /* Tableview controller */
        tableviewController = SettingsTableViewController()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
