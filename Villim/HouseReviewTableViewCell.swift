//
//  HouseReviewTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke

class HouseReviewTableViewCell: UITableViewCell {
    
    var houseReviewCount            : Int!
    var houseReviewRating           : Float!
    var lastReviewContent           : String!
    var lastReviewReviewer          : String!
    var lastReviewProfilePictureUrl : String!
    var lastReviewRating            : Float!
    
    var title : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        title = UILabel()
        title.text = NSLocalizedString("amenities", comment: "")
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
            var houseRating   : UILabel!  = nil
            
            let reviewerProfilePic : UIImageView = UIImageView()
            self.contentView.addSubview(reviewerProfilePic)
            
            let reviewerName : UILabel = UILabel()
            reviewerName.text = lastReviewReviewer
            self.contentView.addSubview(reviewerName)
            
            let reviewRating : UILabel = UILabel()
            reviewRating.text = lastReviewReviewer
            self.contentView.addSubview(reviewRating)
            
            let reviewContent : UILabel = UILabel()
            reviewContent.text = lastReviewContent
            self.contentView.addSubview(reviewContent)
            
            if houseReviewCount > 1 {
                seeMoreButton = UIButton()
                seeMoreButton.titleLabel?.text = String(format: NSLocalizedString("review_see_more_format", comment: ""), houseReviewCount - 1)
                self.contentView.addSubview(seeMoreButton)
                
                houseRating = UILabel()
                houseRating.text = self.lastReviewReviewer
                self.contentView.addSubview(houseRating)

            }
            
            /* Make constriaints */
            reviewerProfilePic.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(50)
                make.height.equalTo(50)
                make.top.equalTo(title.snp.bottom)
                make.left.equalToSuperview()
            }
            
            reviewerName.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(150)
                make.height.equalTo(50)
                make.top.equalTo(title.snp.bottom)
                make.left.equalTo(reviewerProfilePic.snp.right)
            }
            
            reviewRating.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(150)
                make.height.equalTo(150)
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
                    make.width.equalTo(150)
                    make.top.equalTo(reviewContent.snp.bottom)
                    make.bottom.equalToSuperview()
                    make.left.equalTo(reviewerProfilePic.snp.right)
                }
                
                houseRating.snp.makeConstraints { (make) -> Void in
                    make.width.equalTo(150)
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
            if lastReviewProfilePictureUrl.isEmpty {
                reviewerProfilePic.image = #imageLiteral(resourceName: "img_default")
            } else {
                let url = URL(string: VillimSession.getProfilePicUrl())
                Nuke.loadImage(with: url!, into: reviewerProfilePic)
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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
