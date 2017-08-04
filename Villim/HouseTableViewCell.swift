//
//  HouseTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/21/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Cosmos

class HouseTableViewCell: UITableViewCell {
    
    var container : UIView!
    var houseThumbnail: UIImageView!
    var houseName: UILabel!
    var houseRating: CosmosView!
    var houseReviewCount: UILabel!
    var houseRent: UILabel!
    var imageDim: UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        container = UIView()
        container.backgroundColor = UIColor.white
        self.contentView.addSubview(container)
        
        houseThumbnail = UIImageView()
        container.addSubview(houseThumbnail)
        
        houseName = UILabel()
        houseName.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        houseName.numberOfLines = 2
        houseName.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        container.addSubview(houseName)
        
        houseRating = CosmosView()
        houseRating.settings.updateOnTouch = false
        houseRating.settings.fillMode = .precise
        houseRating.settings.starSize = 15
        houseRating.settings.starMargin = 5
        houseRating.settings.filledImage = UIImage(named: "icon_star_on")
        houseRating.settings.emptyImage = UIImage(named: "icon_star_off")
        container.addSubview(houseRating)
        
        houseReviewCount = UILabel()
        houseReviewCount.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        houseReviewCount.textColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
        container.addSubview(houseReviewCount)
        
        houseRent = UILabel()
        houseRent.font = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        houseRent.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        container.addSubview(houseRent)
        
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
            make.left.equalTo(houseThumbnail.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        
        houseRating.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalTo(houseThumbnail.snp.right).offset(10)
        }
        
        houseReviewCount.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(houseRating.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        houseRent.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(houseThumbnail.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
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
