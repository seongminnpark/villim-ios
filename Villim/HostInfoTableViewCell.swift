//
//  HostInfoTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Cosmos

class HostInfoTableViewCell: UITableViewCell {

    let hostImageSize   : CGFloat! = 40.0
    
    var hostImage       : UIImageView!
    var hostName        : UILabel!
    var hostRating      : CosmosView!
    var hostReviewCount : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        hostImage = UIImageView()
        self.contentView.addSubview(hostImage)
        
        hostName = UILabel()
        hostName.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        hostName.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        self.contentView.addSubview(hostName)
        
        hostRating = CosmosView()
        hostRating.settings.updateOnTouch = false
        hostRating.settings.fillMode = .precise
        hostRating.settings.starSize = 13
        hostRating.settings.starMargin = 5
        hostRating.settings.filledImage = UIImage(named: "icon_star_on")
        hostRating.settings.emptyImage = UIImage(named: "icon_star_off")
        self.contentView.addSubview(hostRating)
        
        hostReviewCount = UILabel()
        hostReviewCount.font = UIFont(name: "NotoSansCJKkr-Regular", size: 12)
        hostReviewCount.textColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
        self.contentView.addSubview(hostReviewCount)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        hostImage?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(hostImageSize)
            make.height.equalTo(hostImageSize)
            make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
            make.top.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
        }
        
        hostName?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().dividedBy(2)
            make.top.equalTo(hostImage)
            make.left.equalTo(hostImage.snp.right).offset(VillimValues.tableMargin)
        }
        
        hostRating?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(hostImage.snp.right).offset(VillimValues.tableMargin)
            make.bottom.equalTo(hostImage)
        }
        
        hostReviewCount.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(hostRating)
            make.left.equalTo(hostRating.snp.right).offset(VillimValues.tableMargin)
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
