//
//  HouseReviewTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke
import Cosmos

protocol ReviewDelegate {
    func onReviewSeeMore()
}

class HouseReviewTableViewCell: UITableViewCell {
    
    let reviewerImageSize           : CGFloat! = 50.0
    
    var houseReviewCount            : Int!     = 0
    var houseReviewRating           : Float!   = 0.0
    var lastReviewContent           : String!  = ""
    var lastReviewReviewer          : String!  = ""
    var lastReviewProfilePictureUrl : String!  = ""
    var lastReviewRating            : Float!   = 0.0
    
    var reviewDelegate             : ReviewDelegate!
    
    var title : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        
        title = UILabel()
        title.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        title.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        title.text = NSLocalizedString("review", comment: "")
        self.contentView.addSubview(title)
        
        makeConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func populateViews() {
        if houseReviewCount <= 0 {
            
            let noReviewLabel : UILabel = UILabel()
            noReviewLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
            noReviewLabel.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
            noReviewLabel.text = NSLocalizedString("no_review", comment: "")
            self.contentView.addSubview(noReviewLabel)
            
            noReviewLabel.snp.makeConstraints { (make) -> Void in
                make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
                make.right.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN)
                make.bottom.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN * 3)
            }

            
        } else if houseReviewCount > 0 {
            
            var seeMoreButton : UIButton! = nil
            var houseRating   : CosmosView!  = nil
            
            let reviewerProfilePic : UIImageView = UIImageView()
            reviewerProfilePic.layer.cornerRadius = reviewerImageSize / 2.0
            reviewerProfilePic.layer.masksToBounds = true;
            self.contentView.addSubview(reviewerProfilePic)
            
            let reviewerName : UILabel = UILabel()
            reviewerName.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
            reviewerName.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
            reviewerName.text = lastReviewReviewer
            self.contentView.addSubview(reviewerName)
            
            let reviewRating : CosmosView = CosmosView()
            
            reviewRating.rating = Double(lastReviewRating)
            reviewRating.settings.updateOnTouch = false
            reviewRating.settings.fillMode = .precise
            reviewRating.settings.starSize = 15
            reviewRating.settings.starMargin = 5
            reviewRating.settings.filledImage = UIImage(named: "icon_star_on")
            reviewRating.settings.emptyImage = UIImage(named: "icon_star_off")
            self.contentView.addSubview(reviewRating)

            let reviewContent : UILabel = UILabel()
            reviewContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
            reviewContent.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
            reviewContent.text = lastReviewContent
            self.contentView.addSubview(reviewContent)
            
            if houseReviewCount > 1 {
                seeMoreButton = UIButton()
                seeMoreButton.setTitle(String(format: NSLocalizedString("review_see_more_format", comment: ""), houseReviewCount - 1), for: .normal)
                seeMoreButton.setTitleColor(VillimValues.themeColor, for: .normal)
                seeMoreButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 14)
                seeMoreButton.addTarget(self, action: #selector(seeMore), for: .touchUpInside)
                self.contentView.addSubview(seeMoreButton)

                houseRating = CosmosView()
                houseRating.rating = Double(self.houseReviewRating)
                houseRating.settings.updateOnTouch = false
                houseRating.settings.fillMode = .precise
                houseRating.settings.starSize = 15
                houseRating.settings.starMargin = 5
                houseRating.settings.filledImage = UIImage(named: "icon_star_on")
                houseRating.settings.emptyImage = UIImage(named: "icon_star_off")
                self.contentView.addSubview(houseRating)

            }
            
            /* Make constriaints */
            reviewerProfilePic.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(reviewerImageSize)
                make.height.equalTo(reviewerImageSize)
                make.top.equalTo(title.snp.bottom).offset(HouseDetailTableViewController.SIDE_MARGIN * 0.75)
                make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
            }
            
            reviewerName.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(reviewerProfilePic)
                make.left.equalTo(reviewerProfilePic.snp.right).offset(10)
            }
            
            reviewRating.snp.makeConstraints { (make) -> Void in
                make.centerY.equalTo(reviewerName)
                make.left.equalTo(reviewerName.snp.right).offset(10)
            }
            
            
            if houseReviewCount > 1 {
            
                reviewContent.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(reviewerName.snp.bottom).offset(10)
                    make.left.equalTo(reviewerProfilePic.snp.right).offset(10)
                    make.right.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN)
                }
                
                seeMoreButton.snp.makeConstraints { (make) -> Void in
                    make.bottom.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN * 0.75)
                    make.left.equalTo(reviewerProfilePic.snp.right).offset(10)
                }
                
                houseRating.snp.makeConstraints { (make) -> Void in
                    make.centerY.equalTo(seeMoreButton)
                    make.right.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN)
                }
                
                
            } else {
                reviewContent.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(reviewerName.snp.bottom).offset(10)
                    make.left.equalTo(reviewerProfilePic.snp.right).offset(10)
                    make.right.equalToSuperview().offset(-HouseDetailTableViewController.SIDE_MARGIN)
                }
            }
            
            /* Load image */
            if lastReviewProfilePictureUrl == nil {
                reviewerProfilePic.image = #imageLiteral(resourceName: "img_default")
            } else {
                let url = URL(string: lastReviewProfilePictureUrl)
                if url != nil {
                    Nuke.loadImage(with: url!, into: reviewerProfilePic)
                } else {
                    reviewerProfilePic.image = #imageLiteral(resourceName: "img_default")
                }
            }
            
        }
    }
    
    func makeConstraints() {
        
        title?.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN * 0.75)
            make.left.equalToSuperview().offset(HouseDetailTableViewController.SIDE_MARGIN)
        }
    }
    
    func seeMore() {
        reviewDelegate.onReviewSeeMore()
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
