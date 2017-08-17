//
//  MyRoomTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/17/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class MyRoomTableViewCell: UITableViewCell {

    var title : UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        title = UILabel()
        title.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        title.textColor = UIColor.black
        title.textAlignment = .center
        self.contentView.addSubview(title)
        
        makeConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        
        title?.snp.makeConstraints { (make) -> Void in
            make.width.height.equalToSuperview()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
