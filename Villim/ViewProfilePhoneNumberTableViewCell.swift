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
        self.contentView.addSubview(title)
        
        title?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        content = UILabel()
        self.contentView.addSubview(content)
        
        content?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layoutNonEditMode() {
        
        if addButton != nil { addButton.removeFromSuperview() }
        
        content?.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    func layoutEditMode() {
        
        addButton = UIButton.init()
        addButton.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
        addButton.setTitleColor(VillimValues.themeColor, for: .normal)
        self.contentView.addSubview(addButton)
        
        addButton?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom)
            make.right.equalToSuperview()
//            make.width.height.equalTo(addButtonSize)
        }
        
        content?.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(addButton.snp.left)
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
