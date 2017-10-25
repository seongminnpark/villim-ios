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
import Material

class ProfileViewController: ViewController, ProfileTableViewItemSelectedListener, LoginDelegate {
    
    let profileImageViewSize : CGFloat! = 100.0
    
    private var menuButton : FlatButton!
    private var profileTitle : UILabel!
    private var profileImageView : UIImageView!
    private var profileTableViewController : ProfileTableViewController!
    
    var logoutConfirmDialog : VillimDialog!
    
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
        
        setUpNavigationBar()
        populateViews()
        makeConstraints()
        
    }
    
    func setUpNavigationBar() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        /* Set title */
        self.navigationItem.titleLabel.text = NSLocalizedString("profile", comment: "")
//        self.navigationItem.titleLabel.textAlignment = .center
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        /* Add menu button */
        menuButton = FlatButton()
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.pulseAnimation = .center
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        
        self.navigationItem.leftViews = [menuButton]
    }
    
    func handleMenuButton() {
        self.navigationDrawerController?.toggleLeftView()
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
            profileImageView.image = #imageLiteral(resourceName: "img_default")
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
            make.right.equalTo(self.view).offset(-VillimValues.sideMargin)
            make.top.equalTo(self.view).offset(topOffset + VillimValues.sideMargin)
        }
        
        /* Profile title */
        profileTitle?.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(profileImageView)
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
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
            showLogoutConfirmDialog()
            break
        case NSLocalizedString("faq", comment: ""):
            self.tabBarController?.tabBar.isHidden = true
            launchFAQWebView()
            break
        case NSLocalizedString("settings", comment: ""):
            self.tabBarController?.tabBar.isHidden = true
            launchSettingsViewController()
            break
        case NSLocalizedString("privacy_policy", comment: ""):
            self.tabBarController?.tabBar.isHidden = true
            launchPrivacyPolicyWebView()
            break
        case NSLocalizedString("edit_profile", comment: ""):
            launchViewProfileViewController()
            self.tabBarController?.tabBar.isHidden = true
            break
        default:
            break
        }
    }
    
    func showLogoutConfirmDialog() {
        
        logoutConfirmDialog = VillimDialog()
        logoutConfirmDialog.title = NSLocalizedString("logout", comment: "")
        logoutConfirmDialog.label =
            String(format:NSLocalizedString("logout_confirm_format", comment: ""), VillimSession.getFullName())
        logoutConfirmDialog.onConfirm = { () -> Void in self.logout() }
        self.navigationController?.view.addSubview(logoutConfirmDialog)
    }
    
    public func launchLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.isRootView = false
        loginViewController.loginDelegate = self
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
    
    func launchFAQWebView() {
        let webViewController = WebViewController()
        webViewController.webViewTitle = NSLocalizedString("faq", comment: "")
        webViewController.urlString = VillimKeys.FAQ_URL
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func launchSettingsViewController() {
        let settingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    func launchPrivacyPolicyWebView() {
        let webViewController = WebViewController()
        webViewController.webViewTitle = NSLocalizedString("privacy_policy", comment: "")
        webViewController.urlString = VillimKeys.TERMS_OF_SERVICE_URL
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    public func onLogin(success: Bool) {
        if success {
            populateViews()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if logoutConfirmDialog != nil {
            logoutConfirmDialog.dismiss()
        }
    }
    
    
}
