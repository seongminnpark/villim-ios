//
//  DiscoverTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/15/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Cosmos

class DiscoverTableViewCell: UITableViewCell {

    let houseThumbnailHeight : CGFloat = 200.0
    
    var container      : UIView!
    var houseThumbnail : UIImageView!
    var houseName      : UILabel!
    var houseRating    : CosmosView!
    var monthlyRent    : UILabel!
    var dailyRent      : UILabel!
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
        
        houseRating = CosmosView()
        houseRating.settings.updateOnTouch = false
        houseRating.settings.fillMode = .precise
        houseRating.settings.starSize = 20
        houseRating.settings.starMargin = 5
        houseRating.settings.filledImage = UIImage(named: "icon_star_on")
        houseRating.settings.emptyImage = UIImage(named: "icon_star_off")
        container.addSubview(houseRating)
        
        monthlyRent = UILabel()
        monthlyRent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        monthlyRent.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        container.addSubview(monthlyRent)
        
        dailyRent = UILabel()
        dailyRent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
        dailyRent.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        container.addSubview(dailyRent)
        
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
            make.width.equalToSuperview()
            make.height.equalTo(houseThumbnailHeight)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        houseRating.snp.makeConstraints{ (make) -> Void in
            make.right.equalToSuperview()
            make.top.equalTo(houseThumbnail.snp.bottom).offset(10)
        }
        
        houseName?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalTo(houseRating.snp.left).offset(10)
            make.centerY.equalTo(houseRating)
        }
        
        monthlyRent.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(houseName.snp.bottom).offset(10)
        }
        
        dailyRent.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(monthlyRent.snp.bottom).offset(5)
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
