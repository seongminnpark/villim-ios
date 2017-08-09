//
//  PushNotificationsTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/9/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    var title   : UILabel!
    var button  : UISwitch!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        title = UILabel()
        title.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        title.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        self.contentView.addSubview(title)
        
        button = UISwitch()
//        button.addTarget(self, action:#selector(self.onSwitchChanged(_:)), for: .valueChanged)
        self.contentView.addSubview(button)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        title?.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN * 0.75)
        }
        
        button?.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN * 0.75)
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
