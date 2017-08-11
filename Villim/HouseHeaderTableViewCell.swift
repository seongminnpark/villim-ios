//
//  HouseHeaderTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class HouseHeaderTableViewCell: UITableViewCell {

    var houseName        : UILabel!
    var houseAddress      : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        
        houseName = UILabel()
        houseName.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        houseName.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        self.contentView.addSubview(houseName)
        
        houseAddress = UILabel()
        houseAddress.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        houseAddress.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        self.contentView.addSubview(houseAddress)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        houseName?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
            make.right.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN)
            make.top.equalToSuperview()
        }
        
        houseAddress?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
            make.right.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN)
            make.top.equalTo(houseName.snp.bottom).offset(HouseDetailTableViewController.SIDE_MARGIN / 2)
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
