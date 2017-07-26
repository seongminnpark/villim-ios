//
//  HouseReviewTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class HouseReviewTableViewCell: UITableViewCell {

    var title     : UILabel!
    var stackView : UIStackView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        title = UILabel()
        title.text = NSLocalizedString("amenities", comment: "")
        self.contentView.addSubview(title)
        
        stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.distribution = UIStackViewDistribution.fillEqually
        stackView.alignment = UIStackViewAlignment.center
        self.contentView.addSubview(stackView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func populateViews() {

    }
    
    func makeConstraints() {
        
        title?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
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
