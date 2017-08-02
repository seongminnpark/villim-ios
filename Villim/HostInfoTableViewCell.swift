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

    var hostImage       : UIImageView!
    var hostName        : UILabel!
    var hostRating      : CosmosView!
    var hostReviewCount : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)

        hostImage = UIImageView()
        self.contentView.addSubview(hostImage)
        
        hostName = UILabel()
        self.contentView.addSubview(hostName)
        
        hostRating = CosmosView()
        hostRating.settings.updateOnTouch = false
        hostRating.settings.fillMode = .precise
        hostRating.settings.starSize = 15
        hostRating.settings.starMargin = 5
        hostRating.settings.filledImage = UIImage(named: "icon_star_on")
        hostRating.settings.emptyImage = UIImage(named: "icon_star_off")
        self.contentView.addSubview(hostRating)
        
        hostReviewCount = UILabel()
        self.contentView.addSubview(hostReviewCount)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        hostImage?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        hostName?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(50)
            make.top.equalToSuperview()
            make.left.equalTo(hostImage.snp.right)
        }
        
        hostRating?.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.top.equalTo(hostName.snp.bottom)
            make.left.equalTo(hostImage.snp.right)
            make.bottom.equalToSuperview()
        }
        
        hostReviewCount.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(50)
            make.top.equalTo(hostName.snp.bottom)
            make.left.equalTo(hostRating.snp.right)
            make.bottom.equalToSuperview()
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
