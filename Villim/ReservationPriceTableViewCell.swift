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
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        priceTitle = UILabel()
        priceTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        priceTitle.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        priceTitle.text = NSLocalizedString("price", comment: "")
        self.contentView.addSubview(priceTitle)
        
        basePriceTitle = UILabel()
        basePriceTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        basePriceTitle.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        basePriceTitle.text = NSLocalizedString("base_price", comment: "")
        self.contentView.addSubview(basePriceTitle)
        
        utilityTitle = UILabel()
        utilityTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        utilityTitle.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        utilityTitle.text = NSLocalizedString("utility_fee", comment: "")
        self.contentView.addSubview(utilityTitle)
        
        cleaningFeeTitle = UILabel()
        cleaningFeeTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        cleaningFeeTitle.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        cleaningFeeTitle.text = NSLocalizedString("cleaning_fee", comment: "")
        self.contentView.addSubview(cleaningFeeTitle)
        
        priceContent = UILabel()
        priceContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        priceContent.textColor = VillimValues.themeColor
        self.contentView.addSubview(priceContent)
        
        basePriceContent = UILabel()
        basePriceContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        basePriceContent.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        self.contentView.addSubview(basePriceContent)
        
        utilityContent = UILabel()
        utilityContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        utilityContent.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        self.contentView.addSubview(utilityContent)
        
        cleaningFeeContent = UILabel()
        cleaningFeeContent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        cleaningFeeContent.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        self.contentView.addSubview(cleaningFeeContent)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        priceTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(ReservationTableViewController.SIDE_MARGIN)
            make.top.equalToSuperview().offset(ReservationTableViewController.SIDE_MARGIN * 0.75)
        }
        
        basePriceTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(ReservationTableViewController.SIDE_MARGIN)
            make.top.equalTo(priceTitle.snp.bottom).offset(ReservationTableViewController.SIDE_MARGIN)
        }
        
        utilityTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(ReservationTableViewController.SIDE_MARGIN)
            make.top.equalTo(basePriceTitle.snp.bottom).offset(5)
        }
        
        cleaningFeeTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(ReservationTableViewController.SIDE_MARGIN)
            make.top.equalTo(utilityTitle.snp.bottom).offset(5)
        }
        
        priceContent?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-ReservationTableViewController.SIDE_MARGIN)
            make.top.equalTo(priceTitle)
        }
        
        basePriceContent?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-ReservationTableViewController.SIDE_MARGIN)
            make.top.equalTo(basePriceTitle)
        }
        
        utilityContent?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-ReservationTableViewController.SIDE_MARGIN)
            make.top.equalTo(utilityTitle)
        }
        
        cleaningFeeContent?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-ReservationTableViewController.SIDE_MARGIN)
            make.top.equalTo(cleaningFeeTitle)
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
