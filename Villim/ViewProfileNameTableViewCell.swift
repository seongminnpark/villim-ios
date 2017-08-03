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
        self.contentView.addSubview(title)
        
        title?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layoutNonEditMode() {
        
        if firstNameField != nil { firstNameField.removeFromSuperview() }
        if lastNameField  != nil { lastNameField.removeFromSuperview() }
        
        content = UILabel()
        self.contentView.addSubview(content)
        
        content?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(title.snp.bottom)
            make.left.equalToSuperview()
        }
        
    }
    
    func layoutEditMode() {
        
        if content != nil { content.removeFromSuperview() }
        
        /* Last name field */
        lastNameField = UITextField()
        lastNameField.placeholder = NSLocalizedString("last_name", comment: "")
        lastNameField.borderStyle = .roundedRect
        
        self.contentView.addSubview(lastNameField)
        
        lastNameField?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom)
            make.width.equalToSuperview().dividedBy(2)
            make.left.equalToSuperview()
        }
        
        
        /* First name field */
        firstNameField = UITextField()
        firstNameField.placeholder = NSLocalizedString("first_name", comment: "")
        firstNameField.borderStyle = .roundedRect
        
        self.contentView.addSubview(firstNameField)
        
        firstNameField?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom)
            make.width.equalToSuperview().dividedBy(2)
            make.left.equalTo(self.contentView.snp.centerX)
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
