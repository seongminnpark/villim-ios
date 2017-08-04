//
//  ViewReviewTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/2/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ViewReviewTableViewCell: UITableViewCell {
    
    let reviewerImageSize : CGFloat! = 50.0
    
    let sideMargin : CGFloat = 20.0
    
    var reviewerImageView : UIImageView!
    var reviewerName      : UILabel!
    var reviewContent     : UILabel!
    var reviewDate        : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        reviewerImageView = UIImageView()
        reviewerImageView.layer.cornerRadius = reviewerImageSize / 2.0
        reviewerImageView.layer.masksToBounds = true;
        self.contentView.addSubview(reviewerImageView)
        
        reviewerName = UILabel()
        reviewerName.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        reviewerName.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        self.contentView.addSubview(reviewerName)
        
        reviewContent = UILabel()
        reviewContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        reviewContent.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        reviewContent.lineBreakMode = .byWordWrapping
        reviewContent.numberOfLines = 0
        self.contentView.addSubview(reviewContent)
        
        reviewDate = UILabel()
        reviewDate.font = UIFont(name: "NotoSansCJKkr-Regular", size: 10.2)
        reviewDate.textColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
        self.contentView.addSubview(reviewDate)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func makeConstraints() {
        
        reviewerImageView?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(sideMargin * 0.75)
            make.width.height.equalTo(reviewerImageSize)
        }
        
        reviewerName?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewerImageView.snp.right).offset(10)
            make.top.equalTo(reviewerImageView)
        }
        
        reviewDate?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewerImageView.snp.right).offset(10)
            make.bottom.equalTo(reviewerImageView)
        }
        
        reviewContent?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(reviewerImageView.snp.bottom).offset(10)
        }
        
    }
    

}
