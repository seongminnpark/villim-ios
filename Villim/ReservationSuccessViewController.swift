//
//  ReservationSuccessViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/8/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

protocol ReservationSuccessDelegate {
    func onDismiss()
}

class ReservationSuccessViewController: UIViewController {

    var visit : VillimVisit!
    var successDelegate : ReservationSuccessDelegate!
    
    var titleMain : UILabel!
    var instructions : UILabel!
    var tableViewController : ReservationSuccessTableViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.backgroundColor = VillimValues.themeColor
        
        /* Set up navigation bar */
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = VillimValues.themeColor
        self.title = ""
    
        /* Set back button */
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "button_close"), style: .plain, target: self, action: #selector(self.close))
        self.navigationItem.rightBarButtonItem  = backButton
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        /* Title */
        titleMain = UILabel()
        titleMain.font = UIFont(name: "NotoSansCJKkr-Regular", size: 25)
        titleMain.textColor = UIColor.white
        titleMain.text = NSLocalizedString("visit_request_success", comment: "")
        self.view.addSubview(titleMain)
        
        /* Instructions */
        instructions = UILabel()
        instructions.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        instructions.textColor = UIColor.white
        instructions.text = NSLocalizedString("request_success_instructions", comment: "")
        instructions.numberOfLines = 2
        self.view.addSubview(instructions)
        
        /* Tableview controller */
        tableViewController = ReservationSuccessTableViewController()
        tableViewController.visit = self.visit
        self.view.addSubview(tableViewController.view)
        
        makeConstraints()

    }

    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Title */
        titleMain?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(topOffset + VillimValues.sideMargin)
        }
        
        /* Instruction Field */
        instructions?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(titleMain.snp.bottom).offset(VillimValues.sideMargin)
        }
        
        /* Tableview */
        tableViewController?.tableView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(instructions.snp.bottom).offset(VillimValues.sideMargin * 2)
            make.bottom.equalToSuperview()
        }


    }
    
    func close() {
        self.dismiss(animated:true, completion:nil)
        successDelegate.onDismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
