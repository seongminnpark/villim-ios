//
//  AppNavigationController.swift
//  Villim
//
//  Created by Seongmin Park on 9/20/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Material

class AppNavigationController: NavigationController {
    
    open override func prepare() {
        super.prepare()
        guard navigationBar is NavigationBar else {
            return
        }
    }
}
