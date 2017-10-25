//
//  NetworkErrorView.swift
//  Villim
//
//  Created by Seongmin on 10/25/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Material

protocol NetworkErrorViewDelegate {
    func retry()
}

class NetworkErrorView: UIView {

    let CONTAINER_HEIGHT = 200.0
    let COLOR =  Color.grey.darken2
    
    var delegate : NetworkErrorViewDelegate!
    
    var container   : UIView!
    var errorIcon   : UIImageView!
    var errorLabel  : UILabel!
    var retryButton : FlatButton!

    override init (frame : CGRect) {
        super.init(frame : frame)
        
        self.backgroundColor = Color.grey.lighten4
        
        /* Container */
        container = UIView()
        self.addSubview(container)
        container.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(CONTAINER_HEIGHT)
        }
        
        /* Network error icon */
        errorIcon = UIImageView()
        errorIcon.image = #imageLiteral(resourceName: "icon_network_error").withRenderingMode(.alwaysTemplate).tint(with: COLOR)
        container.addSubview(errorIcon)
        
        errorIcon.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        /* Network error label */
        errorLabel = UILabel()
        errorLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
        errorLabel.textColor = COLOR
        errorLabel.textAlignment = .center
        errorLabel.text = NSLocalizedString("network_error", comment: "")
        container.addSubview(errorLabel)
        
        errorLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(errorIcon.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        /* Retry button */
        retryButton = FlatButton(title: NSLocalizedString("retry", comment: ""), titleColor: COLOR)
        retryButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        retryButton.titleLabel?.textColor = COLOR
        retryButton.contentHorizontalAlignment = .center
        retryButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        retryButton.borderWidth = 2.0
        retryButton.cornerRadius = 10.0
        retryButton.borderColor = COLOR
        retryButton.pulseAnimation = .center
        retryButton.setBackgroundColor(color: Color.grey.lighten3, forState: .normal)
        retryButton.setBackgroundColor(color: Color.grey.lighten3, forState: .highlighted)
        retryButton.sizeToFit()
        retryButton.addTarget(self, action: #selector(self.retry), for: .touchUpInside)
        container.addSubview(retryButton)
        
        retryButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(errorLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func retry() {
        if delegate != nil {
            delegate.retry()
        }
    }

}
