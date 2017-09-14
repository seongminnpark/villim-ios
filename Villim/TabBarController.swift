//
//  TabBarController.swift
//  Villim
//
//  Created by Seongmin Park on 7/9/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Initialize tab bar viewcontrollers. */
        
        let discoverController = DiscoverViewController()
        discoverController.tabBarItem = UITabBarItem(title: NSLocalizedString("discover", comment: ""), image: #imageLiteral(resourceName: "icon_discover"), tag: 0)
        
        let myRoomController = MyRoomViewController()
        myRoomController.tabBarItem = UITabBarItem(title: NSLocalizedString("my_room", comment: ""), image: #imageLiteral(resourceName: "icon_my_room"), tag: 0)
        
        let visitListController = VisitListViewController()
        visitListController.tabBarItem = UITabBarItem(title: NSLocalizedString("visit_list", comment: ""), image: #imageLiteral(resourceName: "icon_visit_list"), tag: 0)
        
        let profileController = ProfileViewController()
        profileController.tabBarItem = UITabBarItem(title: NSLocalizedString("profile", comment: ""), image: #imageLiteral(resourceName: "icon_profile"), tag: 0)
        
        
        let viewControllerList = [ discoverController, myRoomController, visitListController, profileController ]
        self.viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
