//
//  HouseInfographicTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke

class HouseInfographicTableViewCell: UITableViewCell {

    var stackView           : UIStackView!
    
    var guestContainer      : UIView!
    var guestCountLabel     : UILabel!
    var guestCountImage     : UIImageView!
    
    var roomContainer      : UIView!
    var roomCountLabel      : UILabel!
    var roomCountImage      : UIImageView!
    
    var bedContainer        : UIView!
    var bedCountLabel       : UILabel!
    var bedCountImage       : UIImageView!
    
    var bathroomContainer   : UIView!
    var bathroomCountLabel  : UILabel!
    var bathroomCountImage  : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.distribution = UIStackViewDistribution.fillEqually
        stackView.alignment = UIStackViewAlignment.center
        self.contentView.addSubview(stackView)
    
        /* Number of guests */
        guestContainer = UIView()
        stackView.addArrangedSubview(guestContainer)
        
        guestCountLabel = UILabel()
        guestContainer.addSubview(guestCountLabel)
        
        guestCountImage = UIImageView()
        guestContainer.addSubview(guestCountImage)
        
        /* Number of rooms */
        roomContainer = UIView()
        stackView.addArrangedSubview(roomContainer)
        
        roomCountLabel = UILabel()
        roomContainer.addSubview(roomCountLabel)
        
        roomCountImage = UIImageView()
        roomContainer.addSubview(roomCountImage)
        
        /* Number of beds */
        bedContainer = UIView()
        stackView.addArrangedSubview(bedContainer)
        
        bedCountLabel = UILabel()
        bedContainer.addSubview(bedCountLabel)
        
        bedCountImage = UIImageView()
        bedContainer.addSubview(bedCountImage)
        
        /* Number of bathrooms */
        bathroomContainer = UIView()
        stackView.addArrangedSubview(bathroomContainer)
        
        bathroomCountLabel = UILabel()
        bathroomContainer.addSubview(bathroomCountLabel)
        
        bathroomCountImage = UIImageView()
        bathroomContainer.addSubview(bathroomCountImage)
        
        makeConstraints()
        populateViews()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeConstraints() {
        
        stackView?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        /* Number of guests */
        guestCountImage?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        guestCountLabel?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(guestCountImage.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        /* Number of rooms */
        roomCountImage?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        roomCountLabel?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(roomCountImage.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        /* Number of beds */
        bedCountImage?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        bedCountLabel?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(bedCountImage.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        /* Number of bathrooms */
        bathroomCountImage?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        bathroomCountLabel?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(bathroomCountImage.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    func populateViews() {
        /* Number of guests */
        guestCountImage.image = #imageLiteral(resourceName: "icon_guest")
        
        /* Number of rooms */
        guestCountImage.image = #imageLiteral(resourceName: "icon_door")
        
        /* Number of beds */
        guestCountImage.image = #imageLiteral(resourceName: "icon_bed")
        
        /* Number of bathrooms */
        guestCountImage.image = #imageLiteral(resourceName: "icon_bath")
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
