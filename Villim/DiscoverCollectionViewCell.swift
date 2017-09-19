//
//  DiscoverCollectionViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 9/17/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import ScalingCarousel
import Cosmos

class DiscoverCollectionViewCell: ScalingCarouselCell {
    
    let houseThumbnailHeight : CGFloat = 200.0
    
    var container      : UIView!
    var houseThumbnail : UIImageView!
    var houseName      : UILabel!
    var houseRating    : CosmosView!
    var monthlyRent    : UILabel!
    var address        : UILabel!
    var imageDim       : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.clear
        
        // Initialize the mainView property and add it to the cell's contentView
        mainView = UIView(frame: contentView.bounds)
        mainView.clipsToBounds = true
        mainView.backgroundColor = UIColor.clear
        self.contentView.addSubview(mainView)
        
        container = UIView()
        container.backgroundColor = VillimValues.backgroundColor
        container.layer.cornerRadius = 30
        container.layer.borderWidth = 1.0
        container.layer.borderColor = UIColor.clear.cgColor
        container.layer.masksToBounds = true
        container.clipsToBounds = true
        mainView.addSubview(container)
        
        houseThumbnail = UIImageView()
        houseThumbnail.clipsToBounds = true
        container.addSubview(houseThumbnail)
        
        houseName = UILabel()
        houseName.font = UIFont(name: "NotoSansCJKkr-Bold", size: 18)
        houseName.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        houseName.numberOfLines = 1
        container.addSubview(houseName)
        
        houseRating = CosmosView()
        houseRating.settings.updateOnTouch = false
        houseRating.settings.fillMode = .precise
        houseRating.settings.starSize = 18
        houseRating.settings.starMargin = 5
        houseRating.settings.filledImage = UIImage(named: "icon_star_on")
        houseRating.settings.emptyImage = UIImage(named: "icon_star_off")
        container.addSubview(houseRating)
        
        monthlyRent = UILabel()
        monthlyRent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        monthlyRent.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        container.addSubview(monthlyRent)
        
        address = UILabel()
        address.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
        address.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        container.addSubview(address)
        
        imageDim = UIView()
        imageDim.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        container.addSubview(imageDim)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        
        container?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-VillimValues.tableMargin*2)
        }
        
        houseThumbnail?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(houseThumbnailHeight)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        houseRating.snp.makeConstraints{ (make) -> Void in
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(houseThumbnail.snp.bottom).offset(10)
        }
        
        houseName?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().dividedBy(2)
            make.centerY.equalTo(houseRating)
        }
        
        monthlyRent.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(houseName.snp.bottom).offset(5)
        }
        
        address.snp.makeConstraints{ (make) -> Void in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(monthlyRent)
        }
        
        imageDim.snp.makeConstraints{ (make) -> Void in
            make.width.height.top.left.equalTo(houseThumbnail)
        }
    }

}
