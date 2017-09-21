//
//  DiscoverCollectionViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 9/17/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import ScalingCarousel
import Cosmos
import Material

class DiscoverCollectionViewCell: ScalingCarouselCell {
    
    let houseThumbnailHeight : CGFloat = 200.0

    var imageDim : UIView!
    
    var card: ImageCard!
    
    var toolbar: Toolbar!
    
    var houseThumbnail: UIImageView!
    
    var bottomBar   : Bar!
    var monthlyRent : UILabel!
    var houseRating : CosmosView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.clear
        
        // Initialize the mainView property and add it to the cell's contentView
        mainView = UIView(frame: contentView.bounds)
        mainView.clipsToBounds = true
        mainView.backgroundColor = UIColor.clear
        self.contentView.addSubview(mainView)

        prepareRent()
        prepareRating()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        prepareImageCard()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func prepareRent() {
        monthlyRent = UILabel()
        monthlyRent.font = RobotoFont.regular(with: 12)
        monthlyRent.textColor = Color.grey.base
    }
    
    fileprivate func prepareRating() {
        houseRating = CosmosView()
        houseRating.settings.updateOnTouch = false
        houseRating.settings.fillMode = .precise
        houseRating.settings.starSize = 13
        houseRating.settings.starMargin = 5
        houseRating.settings.filledImage = UIImage(named: "icon_star_on")
        houseRating.settings.emptyImage = UIImage(named: "icon_star_off")
    }
    

    fileprivate func prepareToolbar() {
        toolbar = Toolbar()
//        toolbar.backgroundColor = Color.grey.lighten5
        toolbar.backgroundColor = UIColor.clear
        
        toolbar.titleLabel.textAlignment = .left
        toolbar.titleLabel.textColor = UIColor.white
        toolbar.titleLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: 20)
        
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = UIColor.white
    }
    
    fileprivate func prepareContentView() {
        houseThumbnail = UIImageView()
        houseThumbnail.contentMode = .scaleAspectFill
        houseThumbnail.image = #imageLiteral(resourceName: "img_default").resize(toHeight: houseThumbnailHeight)
        houseThumbnail.clipsToBounds = true

    }
    
    fileprivate func prepareBottomBar() {
        bottomBar = Bar()
        bottomBar.backgroundColor = Color.grey.lighten5
        bottomBar.contentViewAlignment = .center
        bottomBar.leftViews = [houseRating]
        bottomBar.rightViews = [monthlyRent]
    }
    
    fileprivate func prepareImageCard() {
        card = ImageCard()
        card.backgroundColor = Color.grey.lighten5
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .wideRectangle2
        
        card.imageView = houseThumbnail
        card.contentViewEdgeInsetsPreset = .wideRectangle3
        
        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .wideRectangle2
        card.bottomBar?.height = 20.0
        
        card.depthPreset = .depth3
        
        mainView.layout(card).horizontally(left: 0, right: 0).center()
        
        /* Dim image to make title more legible */
        imageDim = UIView()
        imageDim.backgroundColor = UIColor.gray
        imageDim.alpha = 0.2
        houseThumbnail.addSubview(imageDim)
        
        imageDim.snp.makeConstraints{ (make) -> Void in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(houseThumbnailHeight)
        }
    }


}
