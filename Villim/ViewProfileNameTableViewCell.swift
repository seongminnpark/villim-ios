//
//  ViewProfileNameTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ViewProfileNameTableViewCell: UITableViewCell {

    var title   : UILabel!
    
    /* Non edit mode */
    var content : UILabel!
    
    /* Edit mode */
    var firstNameField : UITextField!
    var lastNameField  : UITextField!
    
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
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layoutNonEditMode() {
        
        if firstNameField != nil { firstNameField.removeFromSuperview() }
        if lastNameField  != nil { lastNameField.removeFromSuperview() }
        
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
    
    func layoutEditMode() {
        
        if content != nil { content.removeFromSuperview() }
        
        /* Last name field */
        lastNameField = UITextField()
        lastNameField.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        lastNameField.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        lastNameField.borderStyle = .roundedRect
        lastNameField.placeholder = NSLocalizedString("last_name", comment: "")
        
        self.contentView.addSubview(lastNameField)
        
        lastNameField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalTo(self.contentView.snp.centerX).offset(-VillimValues.sideMargin)
            make.top.equalTo(title.snp.bottom).offset(10)
        }
        
        
        /* First name field */
        firstNameField = UITextField()
        firstNameField.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        firstNameField.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        firstNameField.borderStyle = .roundedRect
        firstNameField.placeholder = NSLocalizedString("first_name", comment: "")
        
        self.contentView.addSubview(firstNameField)
        
        firstNameField?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.centerX).offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(title.snp.bottom).offset(10)
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
