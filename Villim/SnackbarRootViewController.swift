//
//  SnackbarRootViewController.swift
//  Villim
//
//  Created by Seongmin on 10/24/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Material

class SnackbarRootViewController: UIViewController {

    fileprivate var confirmButton: FlatButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        guard let snackbar = snackbarController?.snackbar else {
            self.view.frame = CGRect(x: 0.0, y: 0.0, width: 0, height: 0.0)
            return
        }
        
        prepareConfirmButton()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareSnackbar()
        animateSnackbar()
    }
}

extension SnackbarRootViewController {
    fileprivate func prepareConfirmButton() {
        confirmButton = FlatButton(title: NSLocalizedString("confirm", comment: ""), titleColor: Color.yellow.base)
        confirmButton.pulseAnimation = .backing
        confirmButton.titleLabel?.font = snackbarController?.snackbar.textLabel.font
        confirmButton.addTarget(self, action: #selector(self.dismissSnackbar), for: .touchUpInside)
    }
    
    fileprivate func prepareSnackbar() {
        guard let snackbar = snackbarController?.snackbar else {
            return
        }
        
        snackbar.text = snackbarController?.title
        snackbar.rightViews = [confirmButton]
    }
    
}

extension SnackbarRootViewController {
    @objc
    func animateSnackbar() {
        guard let sc = snackbarController else {
            return
        }
        
        _ = sc.animate(snackbar: .visible, delay: 0)
        _ = sc.animate(snackbar: .hidden, delay: 3)
    }
    
    @objc
    func dismissSnackbar() {
        guard let sc = snackbarController else {
            return
        }
        
        _ = sc.animate(snackbar: .hidden, delay: 0)
    }
}
