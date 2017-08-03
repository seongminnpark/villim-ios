//
//  ReservationPriceTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ReservationPriceTableViewCell: UITableViewCell {

    var priceTitle         : UILabel!
    var basePriceTitle     : UILabel!
    var utilityTitle       : UILabel!
    var cleaningFeeTitle   : UILabel!
    
    var priceContent       : UILabel!
    var basePriceContent   : UILabel!
    var utilityContent     : UILabel!
    var cleaningFeeContent : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        priceTitle = UILabel()
        priceTitle.text = NSLocalizedString("price", comment: "")
        self.contentView.addSubview(priceTitle)
        
        basePriceTitle = UILabel()
        basePriceTitle.text = NSLocalizedString("base_price", comment: "")
        self.contentView.addSubview(basePriceTitle)
        
        utilityTitle = UILabel()
        utilityTitle.text = NSLocalizedString("utility_fee", comment: "")
        self.contentView.addSubview(utilityTitle)
        
        cleaningFeeTitle = UILabel()
        cleaningFeeTitle.text = NSLocalizedString("cleaning_fee", comment: "")
        self.contentView.addSubview(cleaningFeeTitle)
        
        priceContent = UILabel()
        self.contentView.addSubview(priceContent)
        
        basePriceContent = UILabel()
        self.contentView.addSubview(basePriceContent)
        
        utilityContent = UILabel()
        self.contentView.addSubview(utilityContent)
        
        cleaningFeeContent = UILabel()
        self.contentView.addSubview(cleaningFeeContent)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        priceTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        basePriceTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(priceTitle.snp.bottom)
        }
        
        utilityTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(basePriceTitle.snp.bottom)
        }
        
        cleaningFeeTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(utilityTitle.snp.bottom)
        }
        
        priceContent?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        basePriceContent?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.top.equalTo(priceTitle.snp.bottom)
        }
        
        utilityContent?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.top.equalTo(basePriceTitle.snp.bottom)
        }
        
        cleaningFeeContent?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.top.equalTo(utilityTitle.snp.bottom)
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
