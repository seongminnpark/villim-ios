//
//  AppDelegate.swift
//  Villim
//
//  Created by Seongmin Park on 7/5/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Manually set push and vibration settings to true at first launch.
        
        if !VillimSession.getNotFirstLaunch() {
            VillimSession.setNotFirstLaunch(notFirstLaunch: true)
            VillimSession.setPushPref(pushPref: true)
            VillimSession.setVibrationOnUnlock(vibrationPref: true)
        }
        
        GMSServices.provideAPIKey("AIzaSyCKOyK9ajX3YahW1PE23EGcpC1nthF541M")
        
        UITabBar.appearance().tintColor = VillimValues.themeColor
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        self.window!.rootViewController = TabBarController()
//        self.window!.makeKeyAndVisible()
        
        let appNavigationController = AppNavigationController(rootViewController: DiscoverViewController())
        let leftViewController = MenuViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = AppNavigationDrawerController(rootViewController: appNavigationController, leftViewController: leftViewController)
        window!.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        guard let type = TouchActions(rawValue: shortcutItem.type) else {
            completionHandler(false)
            return
        }
        
        let selectedIndex = type.number
        (window?.rootViewController as? UITabBarController)?.selectedIndex = selectedIndex
        
        completionHandler(true)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

