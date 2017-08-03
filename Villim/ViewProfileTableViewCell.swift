//
//  ViewProfileTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ViewProfileTableViewCell: UITableViewCell {

    var title        : UILabel!
    var content      : UILabel!
    var contentField : UITextField!
    
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
        
        if contentField != nil { contentField.removeFromSuperview() }
        
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
        
        contentField = UITextField()
        contentField.borderStyle = .roundedRect
        self.contentView.addSubview(contentField)
        
        contentField?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(title.snp.bottom)
            make.left.equalToSuperview()
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
