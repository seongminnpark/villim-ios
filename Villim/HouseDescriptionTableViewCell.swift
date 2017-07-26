//
//  HouseDescriptionTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class HouseDescriptionTableViewCell: UITableViewCell {

    var title            : UILabel!
    var houseDescription : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        title = UILabel()
        title.text = NSLocalizedString("house_description", comment: "")
        self.contentView.addSubview(title)
        
        houseDescription = UILabel()
        self.contentView.addSubview(houseDescription)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        title?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
        }
        
        houseDescription?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(title.snp.bottom)
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
