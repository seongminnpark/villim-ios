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
    var instructions     : InsetLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        
        title = UILabel()
        title.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        title.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        title.text = NSLocalizedString("house_description", comment: "")
        self.contentView.addSubview(title)
        
        houseDescription = UILabel()
        houseDescription.font = UIFont(name: "NotoSansCJKkr-DemiLight", size: 14)
        houseDescription.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        self.contentView.addSubview(houseDescription)
        
        instructions = InsetLabel(dx: 10.0, dy: 10.0)
        instructions.font = UIFont(name: "NotoSansCJKkr-DemiLight", size: 14)
        instructions.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        instructions.numberOfLines = 3
        instructions.layer.borderWidth = 0.5
        instructions.layer.borderColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0).cgColor
        instructions.lineBreakMode = .byWordWrapping
        instructions.text = NSLocalizedString("house_description_instructions", comment: "")
        self.contentView.addSubview(instructions)
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
            make.right.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN)
            make.top.equalTo(title.snp.bottom).offset(HouseDetailTableViewController.SIDE_MARGIN*0.75)
        }
        
        instructions?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
            make.right.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN)
            make.top.equalTo(houseDescription.snp.bottom).offset(HouseDetailTableViewController.SIDE_MARGIN*0.75)
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
