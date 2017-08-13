//
//  LocationSuggestionTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/30/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class LocationSuggestionTableViewCell: UITableViewCell {

    var locationName : UILabel!
    var locationDetail : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        locationName = UILabel()
        locationName.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        locationName.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        self.contentView.addSubview(locationName)
        
        locationDetail = UILabel()
        locationDetail.font = UIFont(name: "NotoSansCJKkr-Regular", size: 12        )
        locationDetail.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        self.contentView.addSubview(locationDetail)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeConstraints() {
        
        locationName?.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        locationDetail?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(locationName.snp.bottom)
            make.width.equalToSuperview()
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
