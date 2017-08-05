//
//  ViewProfilePhoneNumberTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ViewProfilePhoneNumberTableViewCell: UITableViewCell {

//    let addButtonSize : CGFloat! = 25.0
    
    var title         : UILabel!
    var content       : UILabel!
    var addButton     : UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        title = UILabel()
        title.font = UIFont(name: "NotoSansCJKkr-DemiLight", size: 13)
        title.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        self.contentView.addSubview(title)
        
        title?.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(VillimValues.sideMargin)
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(VillimValues.sideMargin)
        }
        
        
        content = UILabel()
        content.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        content.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        self.contentView.addSubview(content)
        
        content?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(title.snp.bottom).offset(10)
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layoutNonEditMode() {
        
        if addButton != nil { addButton.removeFromSuperview() }
        
        content?.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
        }
        
    }
    
    func layoutEditMode() {
        
        addButton = UIButton.init()
        addButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        addButton.setTitleColor(VillimValues.themeColor, for: .normal)
        addButton.setTitleColor(VillimValues.themeColorHighlighted, for: .highlighted)
        addButton.setTitle(NSLocalizedString("change", comment: ""), for: .normal)
        self.contentView.addSubview(addButton)
        
        addButton?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
        }
        
        content?.snp.remakeConstraints { (make) -> Void in
            make.centerY.equalTo(addButton)
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalTo(addButton.snp.left).offset(-VillimValues.sideMargin)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
