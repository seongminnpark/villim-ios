//
//  VillimDialog.swift
//  Villim
//
//  Created by Seongmin Park on 8/5/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class VillimDialog: UIView {

    var title : String = "" {
        didSet{
            dialogTitle.text = title
        }
    }
    
    var label : String = "" {
        didSet{
            dialogLabel.text = label
        }
    }
    
    var buttonText : String = "" {
        didSet{
            confirmButton.setTitle(buttonText, for: .normal)
        }
    }
    
    var onConfirm: (() -> Void)?
    
    var dimView       : UIView!
    var dialogView    : UIView!
    var dialogTitle   : UILabel!
    var dialogLabel   : UILabel!
    var confirmButton : UIButton!
    var dismissButton : UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    init() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        super.init(frame:frame)
        
        self.title = ""
        self.label = ""
        self.onConfirm = nil
        
        dimView = UIView(frame: self.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.addSubview(dimView)
        
        /* Dismiss on tap outside */
        let tapGestureRecognizer: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        dimView.addGestureRecognizer(tapGestureRecognizer)
        
        /* Dialog */
        let dialogView = UIView()
        dialogView.backgroundColor = UIColor.white
        dimView.addSubview(dialogView)
        
        /* Header separater */
        let seperator = CALayer()
        let width = CGFloat(1.0)
        seperator.borderColor = VillimValues.searchFilterContentColor.cgColor
        seperator.frame = CGRect(x: 0, y:  VillimValues.dialogHeaderHeight - width,
                                 width: VillimValues.dialogWidth, height: width)
        seperator.backgroundColor = UIColor.clear.cgColor
        seperator.borderWidth = width
        dialogView.layer.addSublayer(seperator)
        dialogView.layer.masksToBounds = true
        
        /* Dialog title */
        dialogTitle = UILabel()
        dialogTitle.font = UIFont(name: "NotoSansCJKkr-Medium", size: 20)
        dialogTitle.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        dialogTitle.textAlignment = .center
        dialogTitle.text = NSLocalizedString("logout", comment: "")
        dialogView.addSubview(dialogTitle)
        
        /* Dialog text */
        dialogLabel = UILabel()
        dialogLabel.lineBreakMode = .byClipping
        dialogLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        dialogLabel.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        dialogLabel.textAlignment = .center
        dialogView.addSubview(dialogLabel)
        
        /* Dismiss button */
        dismissButton = UIButton()
        dismissButton.setImage(#imageLiteral(resourceName: "button_close"), for: .normal)
        dismissButton.adjustsImageWhenHighlighted = true
        dismissButton.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
        dialogView.addSubview(dismissButton)
        
        /* Dialog button */
        confirmButton = UIButton()
        confirmButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        confirmButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
        confirmButton.adjustsImageWhenHighlighted = true
        confirmButton.titleLabel?.font = VillimValues.bottomButtonFont
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setTitleColor(VillimValues.whiteHighlightedColor, for: .highlighted)
        confirmButton.setTitle(NSLocalizedString("confirm", comment: ""), for: .normal)
        confirmButton.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        dialogView.addSubview(confirmButton)
        
        dialogView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(VillimValues.dialogWidth)
            make.height.equalTo(VillimValues.dialogHeight)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        dialogTitle.snp.makeConstraints { (make) -> Void in
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
        
        dialogLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.dialogMargin)
            make.right.equalToSuperview().offset(-VillimValues.dialogMargin)
            make.top.equalTo(dialogTitle.snp.bottom).offset(10)
            make.bottom.equalTo(confirmButton.snp.bottom).offset(-10)
        }
        
        confirmButton.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.dialogMargin)
            make.right.equalToSuperview().offset(-VillimValues.dialogMargin)
            make.height.equalTo(VillimValues.dialogHeaderHeight)
            make.bottom.equalToSuperview().offset(-VillimValues.dialogMargin)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func dismiss() {
        self.removeFromSuperview()
    }
    
    func confirm() {
        if onConfirm != nil {
            onConfirm!()
        }
        self.dismiss()
    }
    
    
}
