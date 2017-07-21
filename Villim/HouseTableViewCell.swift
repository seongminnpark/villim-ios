//
//  HouseTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/21/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class HouseTableViewCell: UITableViewCell {
    
    var houseThumbnail: UIImageView!
    var houseName: UILabel!
    var houseRating: UILabel!
    var houseReviewCount: UILabel!
    var houseRent: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        houseThumbnail = UIImageView()
        self.addSubview(houseThumbnail)
        
        houseName = UILabel()
        self.addSubview(houseName)
        
        houseRating = UILabel()
        self.addSubview(houseRating)
        
        houseReviewCount = UILabel()
        self.addSubview(houseReviewCount)
        
        houseRent = UILabel()
        self.addSubview(houseRent)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
