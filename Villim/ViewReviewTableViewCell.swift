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
        
        reviewerImageView = UIImageView()
        reviewerImageView.layer.cornerRadius = reviewerImageSize / 2.0
        reviewerImageView.layer.masksToBounds = true;
        self.contentView.addSubview(reviewerImageView)
        
        reviewerName = UILabel()
        self.contentView.addSubview(reviewerName)
        
        reviewContent = UILabel()
        self.contentView.addSubview(reviewContent)
        
        reviewDate = UILabel()
        self.contentView.addSubview(reviewDate)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func makeConstraints() {
        
        reviewerImageView?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(reviewerImageSize)
        }
        
        reviewerName?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewerImageView.snp.right)
            make.top.equalToSuperview()
        }
        
        reviewDate?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewerImageView.snp.right)
            make.top.equalTo(reviewerName.snp.bottom)
        }
        
        reviewContent?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(reviewerImageView.snp.bottom)
        }
        
    }
    

}
