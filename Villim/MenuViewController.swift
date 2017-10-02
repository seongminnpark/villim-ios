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
        discoverButton.pulseColor = .white
        discoverButton.addTarget(self, action: #selector(handleDiscoverButton), for: .touchUpInside)
        
        self.view.addSubview(discoverButton)
        
        discoverButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileInfo.snp.bottom).offset(MENU_OFFSET)
        }
    }
    
    fileprivate func prepareMyRoomButton() {
        myRoomButton = FlatButton(title: NSLocalizedString("my_room", comment: ""), titleColor: .black)
        myRoomButton.pulseColor = .white
        myRoomButton.addTarget(self, action: #selector(handleMyRoomButton), for: .touchUpInside)
        
        self.view.addSubview(myRoomButton)
        myRoomButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(discoverButton.snp.bottom).offset(MENU_OFFSET)
        }
    }
    
    fileprivate func prepareMyReservationsButton() {
        myReservationsButton = FlatButton(title: NSLocalizedString("reservation_list", comment: ""), titleColor: .black)
        myReservationsButton.pulseColor = .white
        myReservationsButton.addTarget(self, action: #selector(handleMyReservationsButton), for: .touchUpInside)
        
        self.view.addSubview(myReservationsButton)
        myReservationsButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(myRoomButton.snp.bottom).offset(MENU_OFFSET)
        }
    }
    
    fileprivate func prepareProfileButton() {
        profileButton = FlatButton(title: NSLocalizedString("profile", comment: ""), titleColor: .black)
        profileButton.pulseColor = .white
        profileButton.addTarget(self, action: #selector(handleProfileButton), for: .touchUpInside)
        
        self.view.addSubview(profileButton)
        profileButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
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

