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
    
    let profileImageViewSize : CGFloat! = 100.0
    let sideMargin  : CGFloat! = 20.0
    
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
        
        self.view.backgroundColor = VillimValues.backgroundColor
        self.title = NSLocalizedString("profile", comment: "")
        
        /* Add Title */
        profileTitle = UILabel()
        profileTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        profileTitle.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        self.view.addSubview(profileTitle!)
        
        /* Add profile image view */
        profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = profileImageViewSize / 2.0
        profileImageView.layer.masksToBounds = true;
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
            if VillimSession.getProfilePicUrl().isEmpty {
                profileImageView.image = #imageLiteral(resourceName: "img_default")
            } else {
                let url = URL(string: VillimSession.getProfilePicUrl())
                Nuke.loadImage(with: url!, into: profileImageView)
            }
            
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
        
        /* Profile image */
        profileImageView?.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(profileImageViewSize)
            make.right.equalTo(self.view).offset(-sideMargin)
            make.top.equalTo(self.view).offset(topOffset + sideMargin)
        }
        
        /* Profile title */
        profileTitle?.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(profileImageView)
            make.left.equalToSuperview().offset(sideMargin)
        }
        
        /* Tableview */
        profileTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view)
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
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
        switch item {
        case NSLocalizedString("login", comment: ""):
            self.tabBarController?.tabBar.isHidden = true
            launchLoginViewController()
            break
        case NSLocalizedString("logout", comment: ""):
            logout()
            break
        case NSLocalizedString("faq", comment: ""):
            self.tabBarController?.tabBar.isHidden = true
            break
        case NSLocalizedString("settings", comment: ""):
            self.tabBarController?.tabBar.isHidden = true
            break
        case NSLocalizedString("privacy_policy", comment: ""):
            self.tabBarController?.tabBar.isHidden = true
            break
        case NSLocalizedString("edit_profile", comment: ""):
            launchViewProfileViewController()
            self.tabBarController?.tabBar.isHidden = true
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
    
    public func logout() {
        VillimSession.setLoggedIn(loggedIn: false)
        populateViews()
    }
    
    public func launchViewProfileViewController() {
        let viewProfileViewController = ViewProfileViewController()
        self.navigationController?.pushViewController(viewProfileViewController, animated: true)
        //        self.present(loginViewController, animated: true, completion: nil)
    }
    
    public func onLogin(success: Bool) {
        if success {
            populateViews()
        }
    }
    
}
