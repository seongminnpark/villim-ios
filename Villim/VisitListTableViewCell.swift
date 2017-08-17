//
//  VisitListTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/16/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class VisitListTableViewCell: UITableViewCell {

    var container      : UIView!
    var houseThumbnail : UIImageView!
    var houseName      : UILabel!
    var housePrice     : UILabel!
    var dateCount      : UILabel!
    var dateLabel      : UILabel!
    var imageDim       : UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        container = UIView()
        container.backgroundColor = UIColor.white
        self.contentView.addSubview(container)
        
        houseThumbnail = UIImageView()
        container.addSubview(houseThumbnail)
        
        houseName = UILabel()
        houseName.font = UIFont(name: "NotoSansCJKkr-Bold", size: 20)
        houseName.numberOfLines = 2
        houseName.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        container.addSubview(houseName)
        
        housePrice = UILabel()
        housePrice.font = UIFont(name: "NotoSansCJKkr-Bold", size: 20)
        housePrice.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        container.addSubview(housePrice)
        
        dateCount = UILabel()
        dateCount.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        dateCount.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        container.addSubview(dateCount)
        
        dateLabel = UILabel()
        dateLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        dateLabel.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        dateLabel.numberOfLines = 2
        container.addSubview(dateLabel)
        
        imageDim = UIView()
        imageDim.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        container.addSubview(imageDim)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        
        container?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(VillimValues.tableMargin)
            make.bottom.equalToSuperview()
        }
        
        houseThumbnail?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().dividedBy(2)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        houseName?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(houseThumbnail.snp.right).offset(VillimValues.sideMargin)
            make.right.equalToSuperview()
            make.top.equalTo(houseThumbnail)
        }
        
        housePrice.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(houseName)
            make.top.equalTo(houseName.snp.bottom).offset(10)
            make.right.equalToSuperview()
        }
        
        dateCount.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(housePrice.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.equalTo(housePrice)
        }
        
        dateLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(houseName)
            make.right.equalToSuperview()
            make.bottom.equalTo(houseThumbnail)
        }
        
        imageDim.snp.makeConstraints{ (make) -> Void in
            make.width.height.top.left.equalTo(houseThumbnail)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setSelected(highlighted, animated: animated)
        
        /* Logic to dim imageview */
        if highlighted {
            imageDim.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        } else {
            imageDim.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
    }


}
