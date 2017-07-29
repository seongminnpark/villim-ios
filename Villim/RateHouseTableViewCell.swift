//
//  RateHouseTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/29/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Cosmos


class RateHouseTableViewCell: UITableViewCell {

    var category      : Int!
    var categoryName  : String!
    var rating        : Double = 0.0
    
    var tableViewController : RateHouseTableViewController!
    
    var categoryLabel : UILabel!
    var ratingBar     : CosmosView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        categoryLabel = UILabel()
        self.contentView.addSubview(categoryLabel)
        
        ratingBar = CosmosView()
        ratingBar.settings.updateOnTouch = true
        ratingBar.settings.fillMode = .precise
        ratingBar.settings.starSize = 30
        ratingBar.settings.starMargin = 10
        ratingBar.rating = self.rating
        ratingBar.settings.filledImage = UIImage(named: "icon_star_on")
        ratingBar.settings.emptyImage = UIImage(named: "icon_star_off")
        self.contentView.addSubview(ratingBar)
        
        ratingBar.didFinishTouchingCosmos = { rating in
            self.rating = rating
            self.tableViewController.setRating(category: self.category, value: rating)
        }
        
        makeConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        categoryLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        ratingBar?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
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
