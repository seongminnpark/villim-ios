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
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        title = UILabel()
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
            noReviewLabel.text = NSLocalizedString("no_review", comment: "")
            self.contentView.addSubview(noReviewLabel)
            
            noReviewLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalToSuperview()
                make.top.equalTo(title.snp.bottom)
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
            }

            
        } else if houseReviewCount > 0 {
            
            var seeMoreButton : UIButton! = nil
            var houseRating   : CosmosView!  = nil
            
            let reviewerProfilePic : UIImageView = UIImageView()
            reviewerProfilePic.layer.cornerRadius = reviewerImageSize / 2.0
            reviewerProfilePic.layer.masksToBounds = true;
            self.contentView.addSubview(reviewerProfilePic)
            
            let reviewerName : UILabel = UILabel()
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
            reviewContent.text = lastReviewContent
            self.contentView.addSubview(reviewContent)
            
            if houseReviewCount > 1 {
                seeMoreButton = UIButton()
                seeMoreButton.setTitle(String(format: NSLocalizedString("review_see_more_format", comment: ""), houseReviewCount - 1), for: .normal)
                seeMoreButton.setTitleColor(VillimValues.themeColor, for: .normal)
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
                make.top.equalTo(title.snp.bottom)
                make.left.equalToSuperview()
            }
            
            reviewerName.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(title.snp.bottom)
                make.left.equalTo(reviewerProfilePic.snp.right)
            }
            
            reviewRating.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(title.snp.bottom)
                make.left.equalTo(reviewerName.snp.right)
            }
            
            
            if houseReviewCount > 1 {
            
                reviewContent.snp.makeConstraints { (make) -> Void in
                    make.height.equalTo(50)
                    make.top.equalTo(reviewerName.snp.bottom)
                    make.left.equalTo(reviewerProfilePic.snp.right)
                    make.right.equalToSuperview()
                }
                
                seeMoreButton.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(reviewContent.snp.bottom)
                    make.bottom.equalToSuperview()
                    make.left.equalTo(reviewerProfilePic.snp.right)
                }
                
                houseRating.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(reviewContent.snp.bottom)
                    make.bottom.equalToSuperview()
                    make.right.equalToSuperview()
                }
                
                
            } else {
                reviewContent.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(reviewerName.snp.bottom)
                    make.bottom.equalToSuperview()
                    make.left.equalTo(reviewerProfilePic.snp.right)
                    make.right.equalToSuperview()
                }
            }
            
            /* Load image */
            if lastReviewProfilePictureUrl == nil {
                reviewerProfilePic.image = #imageLiteral(resourceName: "img_default")
            } else {
                let url = URL(string: lastReviewProfilePictureUrl)
                if url != nil { Nuke.loadImage(with: url!, into: reviewerProfilePic) }
            }
            
        }
    }
    
    func makeConstraints() {
        
        title?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
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
