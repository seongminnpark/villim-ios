//
//  ProfileViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/9/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SnapKit
import Nuke

class ProfileViewController: ViewController, ProfileTableViewItemSelectedListener, LoginListener {
    
    private var profileTitle : UILabel!
    private var profileImageView : UIImageView!
    private var profileTableViewController : ProfileTableViewController!
    
    private let loggedOutTableViewItems = [NSLocalizedString("login", comment: ""),
                                           NSLocalizedString("faq", comment: ""),
                                           NSLocalizedString("settings", comment: ""),
                                           NSLocalizedString("privacy_policy", comment: "")]
    private let loggedInTableViewItems = [NSLocalizedString("logout", comment: ""),
                                          NSLocalizedString("edit_profile", comment: ""),
                                          NSLocalizedString("faq", comment: ""),
                                          NSLocalizedString("settings", comment: ""),
                                          NSLocalizedString("privacy_policy", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(VillimSession.getLoggedIn())
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("profile", comment: "")
        
        /* Add Title */
        profileTitle = UILabel()
        self.view.addSubview(profileTitle!)
        
        /* Add profile image view */
        profileImageView = UIImageView()
        self.view.addSubview(profileImageView!)
        
        /* Populate tableview */
        profileTableViewController = ProfileTableViewController()
        profileTableViewController.itemSelectedListener = self
        self.view.addSubview(profileTableViewController.view)
        
        populateViews()
        makeConstraints()
        
    }
    
    func populateViews() {
        if VillimSession.getLoggedIn() {
            
            /* Update name */
            profileTitle.text = VillimSession.getFullName()
            
            /* Load profile photo */
            let url = URL(string: VillimSession.getProfilePicUrl())
            Nuke.loadImage(with: url!, into: profileImageView)
            
            /* Populate tableview */
            profileTableViewController.profileTableViewItems = loggedInTableViewItems
            profileTableViewController.tableView.reloadData()
            
        } else {
            profileTitle.text = self.title
            profileImageView.image = #imageLiteral(resourceName: "icon_profile")
            profileTableViewController.profileTableViewItems = loggedOutTableViewItems
            profileTableViewController.tableView.reloadData()
        }
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Profile title */
        profileTitle?.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(topOffset)
        }
        
        /* Profile image */
        profileImageView?.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(topOffset)
        }
        
        /* Tableview */
        profileTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view)
            make.top.equalTo(profileTitle.snp.bottom)
            make.bottom.equalTo(self.view)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func profileItemSelected(item:String) {
        self.tabBarController?.tabBar.isHidden = true
        switch item {
        case NSLocalizedString("login", comment: ""):
            launchLoginViewController()
            break
        case NSLocalizedString("faq", comment: ""):
            break
        case NSLocalizedString("settings", comment: ""):
            break
        case NSLocalizedString("privacy_policy", comment: ""):
            break
        case NSLocalizedString("edit_profile", comment: ""):
            break
        default:
            break
        }
    }
    
    public func launchLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.loginListener = self
        self.navigationController?.pushViewController(loginViewController, animated: true)
        //        self.present(loginViewController, animated: true, completion: nil)
    }
    
    public func onLogin(success: Bool) {
        if success {
            populateViews() 
        }
    }
    
}
