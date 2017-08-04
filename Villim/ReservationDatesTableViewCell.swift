//
//  ReservationDatesTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ReservationDatesTableViewCell: UITableViewCell {

    var datesTitle    : UILabel!
    var checkInLabel  : UILabel!
    var checkOutLabel : UILabel!
    var separator     : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        datesTitle = UILabel()
        datesTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        datesTitle.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        datesTitle.text = NSLocalizedString("duration", comment: "")
        self.contentView.addSubview(datesTitle)
        
        checkInLabel = UILabel()
        checkInLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 25)
        checkInLabel.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        checkInLabel.numberOfLines = 2
        self.contentView.addSubview(checkInLabel)
        
        checkOutLabel = UILabel()
        checkOutLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 25)
        checkOutLabel.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        checkOutLabel.numberOfLines = 2
        self.contentView.addSubview(checkOutLabel)
        
        separator = UILabel()
        separator.font = UIFont(name: "NotoSansCJKkr-Regular", size: 25)
        separator.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        separator.text = "-"
        self.contentView.addSubview(separator)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        datesTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(ReservationTableViewController.SIDE_MARGIN)
            make.right.equalToSuperview().offset(-ReservationTableViewController.SIDE_MARGIN)
            make.top.equalToSuperview().offset(ReservationTableViewController.SIDE_MARGIN * 0.75)
        }
        
        checkInLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(ReservationTableViewController.SIDE_MARGIN)
            make.bottom.equalToSuperview().offset(-ReservationTableViewController.SIDE_MARGIN * 0.75)
        }
        
        checkOutLabel?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-ReservationTableViewController.SIDE_MARGIN)
            make.bottom.equalToSuperview().offset(-ReservationTableViewController.SIDE_MARGIN * 0.75)
        }
    
        separator?.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ReservationTableViewController.SIDE_MARGIN * 0.75)
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
