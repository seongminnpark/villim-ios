//
//  AppSnackbarController.swift
//  Villim
//
//  Created by Seongmin on 10/24/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Material

class AppSnackbarController: SnackbarController {
    open override func prepare() {
        super.prepare()
        delegate = self
        self.view.backgroundColor = UIColor.clear
    }
}

extension AppSnackbarController: SnackbarControllerDelegate {
//    func snackbarController(snackbarController: SnackbarController, willShow snackbar: Snackbar) {
//        print("snackbarController will show")
//    }
//
//    func snackbarController(snackbarController: SnackbarController, willHide snackbar: Snackbar) {
//        print("snackbarController will hide")
//    }
//
//    func snackbarController(snackbarController: SnackbarController, didShow snackbar: Snackbar) {
//        print("snackbarController did show")
//    }
//
//    func snackbarController(snackbarController: SnackbarController, didHide snackbar: Snackbar) {
//        print("snackbarController did hide")
//    }
}
