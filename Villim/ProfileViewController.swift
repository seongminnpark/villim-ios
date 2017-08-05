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

class ProfileViewController: ViewController, ProfileTableViewItemSelectedListener, LoginDelegate {
    
    let profileImageViewSize : CGFloat! = 100.0
    
    private var profileTitle : UILabel!
    private var profileImageView : UIImageView!
    private var profileTableViewController : ProfileTableViewController!
    
    var dimView : UIView!
    
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
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
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
            showLogoutConfirmAlert()
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
    
    func showLogoutConfirmAlert() {
        dimView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        dimView.alpha = 0.6
        self.view.addSubview(dimView)
        
        let dialogView = UIView()
        dialogView.backgroundColor = UIColor.white
        self.view.addSubview(dialogView)
        
        let dialogTitleLabel = UILabel()
        dialogTitleLabel.font = UIFont(name: "NotoSansCJKkr-Medium", size: 20)
        dialogTitleLabel.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        dialogTitleLabel.textAlignment = .center
        dialogTitleLabel.text = NSLocalizedString("logout", comment: "")
        dialogView.addSubview(dialogTitleLabel)
        
        let dialogMainLabel = UILabel()
        dialogMainLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        dialogMainLabel.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        dialogMainLabel.textAlignment = .center
        dialogMainLabel.text = String(format:NSLocalizedString("logout_confirm_format", comment: ""),
                                      VillimSession.getFullName())
        dialogView.addSubview(dialogMainLabel)
        
        let dismissButton = UIButton()
        dismissButton.setImage(#imageLiteral(resourceName: "button_close"), for: .normal)
        dismissButton.adjustsImageWhenHighlighted = true
        dismissButton.addTarget(self, action: #selector(self.dismissDialog), for: .touchUpInside)
        dialogView.addSubview(dismissButton)
        
        let confirmButton = UIButton()
        confirmButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        confirmButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
        confirmButton.adjustsImageWhenHighlighted = true
        confirmButton.titleLabel?.font = VillimValues.bottomButtonFont
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setTitleColor(VillimValues.whiteHighlightedColor, for: .highlighted)
        confirmButton.setTitle(NSLocalizedString("confirm", comment: ""), for: .normal)
        confirmButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        dialogView.addSubview(confirmButton)
        
        dialogView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(VillimValues.dialogWidth)
            make.height.equalTo(VillimValues.dialogHeight)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        dialogTitleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.dialogMargin)
            make.right.equalToSuperview().offset(-VillimValues.dialogMargin)
            make.top.equalToSuperview()
            make.height.equalTo(VillimValues.dialogHeaderHeight)
        }
        
        dismissButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(VillimValues.dialogMargin)
            make.right.equalToSuperview().offset(-VillimValues.dialogMargin)
            make.height.equalTo(VillimValues.dialogHeaderHeight - VillimValues.dialogMargin * 2)
            make.width.equalTo(VillimValues.dialogHeaderHeight - VillimValues.dialogMargin * 2)
        }
        
        dialogMainLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.dialogMargin)
            make.right.equalToSuperview().offset(-VillimValues.dialogMargin)
            make.top.equalTo(dialogTitleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(confirmButton.snp.bottom).offset(-10)
        }
        
        confirmButton.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.dialogMargin)
            make.right.equalToSuperview().offset(-VillimValues.dialogMargin)
            make.height.equalTo(VillimValues.dialogHeaderHeight)
            make.bottom.equalToSuperview().offset(-VillimValues.dialogMargin)
         }
        

    }
    
    func dismissDialog() {
        if dimView != nil {
            dimView.removeFromSuperview()
        }
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
        dismissDialog()
        populateViews()
    }
    
    public func launchViewProfileViewController() {
        let viewProfileViewController = ViewProfileViewController()
        self.navigationController?.pushViewController(viewProfileViewController, animated: true)
        //        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func launchFAQWebView() {
        let webViewController = WebViewController()
        webViewController.urlString = VillimKeys.FAQ_URL
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func launchSettingsViewController() {
        let webViewController = WebViewController()
        webViewController.urlString = VillimKeys.TERMS_OF_SERVICE_URL
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func launchPrivacyPolicyWebView() {
        let webViewController = WebViewController()
        webViewController.urlString = VillimKeys.TERMS_OF_SERVICE_URL
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    public func onLogin(success: Bool) {
        if success {
            populateViews()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissDialog()
    }
    
    
}
