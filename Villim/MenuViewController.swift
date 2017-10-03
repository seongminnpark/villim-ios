//
//  MenuViewController.swift
//  Villim
//
//  Created by Seongmin Park on 9/20/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Material
import Nuke

class MenuViewController: UIViewController {
    
    let PROFILE_IMAGE_SIZE = 150.0
    let MENU_OFFSET = 20.0
    let PULSE_COLOR = Material.Color.grey.base
    let BUTTON_INSET : CGFloat = 10.0
    let BUTTON_TITLE_SIZE: CGFloat = 15.0
    
    fileprivate var profileInfo: UIImageView!
    fileprivate var discoverButton: FlatButton!
    fileprivate var myRoomButton: FlatButton!
    fileprivate var myReservationsButton: FlatButton!
    fileprivate var profileButton: FlatButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten4
        
        prepareProfileInfo()
        prepareDiscoverButton()
        prepareMyRoomButton()
        prepareMyReservationsButton()
        prepareProfileButton()
    }
}

extension MenuViewController {
    fileprivate func prepareProfileInfo() {
        profileInfo = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileInfo))
        profileInfo.isUserInteractionEnabled = true
        profileInfo.addGestureRecognizer(tap)
        
        self.view.addSubview(profileInfo)
        
        profileInfo.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.width.equalTo(PROFILE_IMAGE_SIZE)
            make.height.equalTo(PROFILE_IMAGE_SIZE)
            make.top.equalTo(50)
        }
        
        /* Load image */
        if VillimSession.getLoggedIn() {
            let url = URL(string: VillimSession.getProfilePicUrl())
            if url != nil {
                Nuke.loadImage(with: url!, into: profileInfo)
            } else {
                profileInfo.image = #imageLiteral(resourceName: "img_default")
            }

        } else {
            profileInfo.image = #imageLiteral(resourceName: "img_default")
        }
        
    }
    
    fileprivate func prepareDiscoverButton() {
        discoverButton = FlatButton(title: NSLocalizedString("discover", comment: ""), titleColor: .black)
        discoverButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: BUTTON_TITLE_SIZE)
        discoverButton.setImage(#imageLiteral(resourceName: "icon_discover"), for: .normal)
        discoverButton.pulseColor = PULSE_COLOR
        discoverButton.contentEdgeInsets = UIEdgeInsetsMake(BUTTON_INSET, BUTTON_INSET, BUTTON_INSET, BUTTON_INSET)
        discoverButton.imageEdgeInsets = UIEdgeInsetsMake(0, BUTTON_INSET, 0, 0)
        discoverButton.titleEdgeInsets = UIEdgeInsetsMake(0, BUTTON_INSET*2, 0, 0)
        discoverButton.contentHorizontalAlignment = .left
        discoverButton.addTarget(self, action: #selector(handleDiscoverButton), for: .touchUpInside)
        
        self.view.addSubview(discoverButton)
        
        discoverButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(profileInfo.snp.bottom).offset(MENU_OFFSET)
        }
    }
    
    fileprivate func prepareMyRoomButton() {
        myRoomButton = FlatButton(title: NSLocalizedString("my_room", comment: ""), titleColor: .black)
        myRoomButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: BUTTON_TITLE_SIZE)
        myRoomButton.setImage(#imageLiteral(resourceName: "icon_my_room"), for: .normal)
        myRoomButton.pulseColor = PULSE_COLOR
        myRoomButton.contentEdgeInsets = UIEdgeInsetsMake(BUTTON_INSET, BUTTON_INSET, BUTTON_INSET, BUTTON_INSET)
        myRoomButton.imageEdgeInsets = UIEdgeInsetsMake(0, BUTTON_INSET, 0, 0)
        myRoomButton.titleEdgeInsets = UIEdgeInsetsMake(0, BUTTON_INSET*2, 0, 0)
        myRoomButton.contentHorizontalAlignment = .left
        myRoomButton.addTarget(self, action: #selector(handleMyRoomButton), for: .touchUpInside)
        
        self.view.addSubview(myRoomButton)
        myRoomButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(discoverButton.snp.bottom).offset(MENU_OFFSET)
        }
    }
    
    fileprivate func prepareMyReservationsButton() {
        myReservationsButton = FlatButton(title: NSLocalizedString("reservation_list", comment: ""), titleColor: .black)
        myReservationsButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: BUTTON_TITLE_SIZE)
        myReservationsButton.setImage(#imageLiteral(resourceName: "icon_visit_list"), for: .normal)
        myReservationsButton.pulseColor = PULSE_COLOR
        myReservationsButton.contentEdgeInsets = UIEdgeInsetsMake(BUTTON_INSET, BUTTON_INSET, BUTTON_INSET, BUTTON_INSET)
        myReservationsButton.imageEdgeInsets = UIEdgeInsetsMake(0, BUTTON_INSET, 0, 0)
        myReservationsButton.titleEdgeInsets = UIEdgeInsetsMake(0, BUTTON_INSET*2, 0, 0)
        myReservationsButton.contentHorizontalAlignment = .left
        myReservationsButton.addTarget(self, action: #selector(handleMyReservationsButton), for: .touchUpInside)
        
        self.view.addSubview(myReservationsButton)
        myReservationsButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(myRoomButton.snp.bottom).offset(MENU_OFFSET)
        }
    }
    
    fileprivate func prepareProfileButton() {
        profileButton = FlatButton(title: NSLocalizedString("profile", comment: ""), titleColor: .black)
        profileButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: BUTTON_TITLE_SIZE)
        profileButton.setImage(#imageLiteral(resourceName: "icon_view_profile"), for: .normal)
        profileButton.pulseColor = PULSE_COLOR
        profileButton.contentEdgeInsets = UIEdgeInsetsMake(BUTTON_INSET, BUTTON_INSET, BUTTON_INSET, BUTTON_INSET)
        profileButton.imageEdgeInsets = UIEdgeInsetsMake(0, BUTTON_INSET, 0, 0)
        profileButton.titleEdgeInsets = UIEdgeInsetsMake(0, BUTTON_INSET*2, 0, 0)
        profileButton.contentHorizontalAlignment = .left
        profileButton.addTarget(self, action: #selector(handleProfileButton), for: .touchUpInside)
        
        self.view.addSubview(profileButton)
        profileButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(myReservationsButton.snp.bottom).offset(MENU_OFFSET)
        }
    }
}

extension MenuViewController {
    @objc
    fileprivate func handleProfileInfo() {
        navigationDrawerController?.closeLeftView()
    }
    
    @objc
    fileprivate func handleDiscoverButton() {
        let appNavigationController = AppNavigationController(rootViewController: DiscoverViewController())
        
        navigationDrawerController?.closeLeftView()
        navigationDrawerController?.transition(to: appNavigationController)
    }
    
    @objc
    fileprivate func handleMyRoomButton() {
        let appNavigationController = AppNavigationController(rootViewController: MyRoomViewController())
        
        navigationDrawerController?.closeLeftView()
        navigationDrawerController?.transition(to: appNavigationController)
    }
    
    @objc
    fileprivate func handleMyReservationsButton() {
        let appNavigationController = AppNavigationController(rootViewController: VisitListViewController())
        
        navigationDrawerController?.closeLeftView()
        navigationDrawerController?.transition(to: appNavigationController)
    }
    
    @objc
    fileprivate func handleProfileButton() {
        let appNavigationController = AppNavigationController(rootViewController: ProfileViewController())
        
        navigationDrawerController?.closeLeftView()
        navigationDrawerController?.transition(to: appNavigationController)
    }
}

