//
//  MyRoomHeaderView.swift
//  Villim
//
//  Created by Seongmin Park on 8/17/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class MyRoomHeaderView: UIView {

    let headerSize     : CGFloat = 360.0
    let houseImageSize : CGFloat = 250.0
    
    var houseImage     : UIImageView!
    var houseName      : UILabel!
    var instructions   : UILabel!
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    init() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerSize)
        super.init(frame:frame)
        
        /* House Imageview */
        houseImage = UIImageView()
        houseImage.clipsToBounds = true
        houseImage.contentMode = .scaleAspectFill
        houseImage.isUserInteractionEnabled = false
        self.addSubview(houseImage)
        
        houseImage?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(houseImageSize)
            make.top.equalToSuperview()
        }
        
        /* House Name */
        houseName = UILabel()
        houseName.textAlignment = .center
        houseName.font = UIFont(name: "NotoSansCJKkr-Bold", size: 20)
        houseName.textColor = UIColor.black
        self.addSubview(houseName)
        
        houseName?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(houseImage.snp.bottom).offset(VillimValues.sideMargin)
            make.left.right.equalToSuperview()
        }
        
        /* Instructions */
        instructions = UILabel()
        instructions.textAlignment = .center
        instructions.font = UIFont(name: "NotoSansCJKkr-Regular", size: 12)
        instructions.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        self.addSubview(instructions)
        
        instructions?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(houseName.snp.bottom).offset(VillimValues.sideMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-VillimValues.sideMargin)
        }
        instructions.text = NSLocalizedString("my_room_header_instructions", comment: "")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
