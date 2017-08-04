//
//  PasscodeChangeSuccessViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/4/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

protocol ChangePasscodeSuccessDelegate {
    func onDismiss()
}

class ChangePasscodeSuccessViewController: UIViewController {

    var dismissDelegate : ChangePasscodeSuccessDelegate!
    
    let imageWidth    : CGFloat = 96.0
    let imageHeight   : CGFloat = 76.0
    
    var lockImage   : UIImageView!
    var titleMain   : UILabel!
    var instruction : UILabel!
    var nextButton  : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("configure_doorlock", comment: "")
        
        /* Lock image */
        lockImage = UIImageView()
        self.view.addSubview(lockImage)
        
        /* Title */
        titleMain = UILabel()
        titleMain.font = UIFont(name: "NotoSansCJKkr-Medium", size: 25)
        titleMain.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        titleMain.textAlignment = .center
        titleMain.text = NSLocalizedString("passcode_change_success_title", comment: "")
        self.view.addSubview(titleMain)
        
        /* Instruction Field */
        instruction = UILabel()
        instruction.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        instruction.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        instruction.numberOfLines = 2
        instruction.textAlignment = .center
        instruction.text = NSLocalizedString("passcode_change_success_instruction", comment: "")
        self.view.addSubview(instruction)
        
        /* Confirm button */
        nextButton = UIButton()
        nextButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        nextButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
        nextButton.adjustsImageWhenHighlighted = true
        nextButton.titleLabel?.font = VillimValues.bottomButtonFont
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(VillimValues.whiteHighlightedColor, for: .highlighted)
        nextButton.setTitle(NSLocalizedString("confirm", comment: ""), for: .normal)
        nextButton.addTarget(self, action: #selector(self.onConfirm), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        makeConstraints()
        populateViews()
    }
 
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        
        /* ImageView */
        lockImage?.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
            make.top.equalTo(topOffset + VillimValues.titleOffset)
        }
        
        /* Title */
        titleMain?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(lockImage.snp.bottom).offset(VillimValues.sideMargin * 2)
        }
        
        /* Instruction field */
        instruction?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(titleMain.snp.bottom).offset(VillimValues.sideMargin * 2)
        }

        
        /* Next button */
        nextButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
    }
    
    func populateViews() {
        lockImage.image = #imageLiteral(resourceName: "img_lock")
    }

    func onConfirm() {
        self.dismiss(animated: true, completion: nil)
        dismissDelegate.onDismiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
