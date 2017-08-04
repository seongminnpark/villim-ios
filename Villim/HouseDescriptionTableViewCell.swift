//
//  HouseDescriptionTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class HouseDescriptionTableViewCell: UITableViewCell {

    var title            : UILabel!
    var houseDescription : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        title = UILabel()
        title.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        title.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        title.text = NSLocalizedString("house_description", comment: "")
        self.contentView.addSubview(title)
        
        houseDescription = UILabel()
        houseDescription.font = UIFont(name: "NotoSansCJKkr-DemiLight", size: 14)
        houseDescription.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        self.contentView.addSubview(houseDescription)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        title?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
            make.top.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
        }
        
        houseDescription?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
            make.top.equalTo(title.snp.bottom).offset(HouseDetailTableViewController.SIDE_MARGIN*0.75)
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
