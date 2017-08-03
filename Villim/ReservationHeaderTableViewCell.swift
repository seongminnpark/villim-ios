//
//  ReservationHeaderTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ReservationHeaderTableViewCell: UITableViewCell {

    var houseName : UILabel!
    var houseAddr : UILabel!
    var houseInfo : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        houseName = UILabel()
        self.contentView.addSubview(houseName)
        
        houseAddr = UILabel()
        self.contentView.addSubview(houseAddr)
        
        houseInfo = UILabel()
        self.contentView.addSubview(houseInfo)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        houseName?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        houseAddr?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(houseName.snp.bottom)
        }
        
        houseInfo?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(houseAddr.snp.bottom)
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
