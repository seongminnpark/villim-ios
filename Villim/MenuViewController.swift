//
//  MenuViewController.swift
//  Villim
//
//  Created by Seongmin Park on 9/20/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Material

class MenuViewController: UIViewController {
    fileprivate var transitionButton: FlatButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.blue.base
        
        prepareTransitionButton()
    }
}

extension MenuViewController {
    fileprivate func prepareTransitionButton() {
        transitionButton = FlatButton(title: "Transition VC", titleColor: .white)
        transitionButton.pulseColor = .white
        transitionButton.addTarget(self, action: #selector(handleTransitionButton), for: .touchUpInside)
        
        view.layout(transitionButton).horizontally().center()
    }
}

extension MenuViewController {
    @objc
    fileprivate func handleTransitionButton() {
        navigationDrawerController?.closeLeftView()
    }
}

