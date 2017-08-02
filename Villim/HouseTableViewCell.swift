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
    
    var houseThumbnail: UIImageView!
    var houseName: UILabel!
    var houseRating: CosmosView!
    var houseReviewCount: UILabel!
    var houseRent: UILabel!
    var imageDim: UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        houseThumbnail = UIImageView()
        self.contentView.addSubview(houseThumbnail)
        
        houseName = UILabel()
        self.contentView.addSubview(houseName)
        
        houseRating = CosmosView()
        houseRating.settings.updateOnTouch = false
        houseRating.settings.fillMode = .precise
        houseRating.settings.starSize = 15
        houseRating.settings.starMargin = 5
        houseRating.settings.filledImage = UIImage(named: "icon_star_on")
        houseRating.settings.emptyImage = UIImage(named: "icon_star_off")
        self.contentView.addSubview(houseRating)
        
        houseReviewCount = UILabel()
        self.contentView.addSubview(houseReviewCount)
        
        houseRent = UILabel()
        self.contentView.addSubview(houseRent)
        
        imageDim = UIView()
        imageDim.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.contentView.addSubview(imageDim)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func makeConstraints() {
        
        houseThumbnail?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        houseName?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(30)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        houseRating.snp.makeConstraints{ (make) -> Void in

            make.top.equalTo(houseName.snp.bottom)
            make.left.equalTo(self.snp.centerX)
        }
        
        houseReviewCount.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(houseName.snp.bottom)
            make.right.equalToSuperview()
        }
        
        houseRent.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(30)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
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
