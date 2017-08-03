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
        
        datesTitle = UILabel()
        datesTitle.text = NSLocalizedString("duration", comment: "")
        self.contentView.addSubview(datesTitle)
        
        checkInLabel = UILabel()
        checkInLabel.numberOfLines = 2
        self.contentView.addSubview(checkInLabel)
        
        checkOutLabel = UILabel()
        checkOutLabel.numberOfLines = 2
        self.contentView.addSubview(checkOutLabel)
        
        separator = UILabel()
        separator.text = "-"
        self.contentView.addSubview(separator)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        datesTitle?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        checkInLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        checkOutLabel?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    
        separator?.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
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
