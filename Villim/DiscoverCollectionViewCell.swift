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
    
    let houseThumbnailHeight : CGFloat = 150.0

    var imageDim : UIView!
    
    var card: PresenterCard!
    
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
        
//        container = UIView()
//        container.backgroundColor = VillimValues.backgroundColor
//        container.clipsToBounds = true
//        
//        houseThumbnail = UIImageView()
//        houseThumbnail.contentMode = .scaleAspectFill
//        houseThumbnail.clipsToBounds = true
//        container.addSubview(houseThumbnail)
//        
//        houseName = UILabel()
//        houseName.font = UIFont(name: "NotoSansCJKkr-Bold", size: 13)
//        houseName.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
//        houseName.numberOfLines = 1
//        container.addSubview(houseName)
//        
//        houseRating = CosmosView()
//        houseRating.settings.updateOnTouch = false
//        houseRating.settings.fillMode = .precise
//        houseRating.settings.starSize = 13
//        houseRating.settings.starMargin = 5
//        houseRating.settings.filledImage = UIImage(named: "icon_star_on")
//        houseRating.settings.emptyImage = UIImage(named: "icon_star_off")
//        container.addSubview(houseRating)
//        
//        monthlyRent = UILabel()
//        monthlyRent.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
//        monthlyRent.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
//        container.addSubview(monthlyRent)
//        
//        address = UILabel()
//        address.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
//        address.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
//        container.addSubview(address)
//        
//        imageDim = UIView()
//        imageDim.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//        container.addSubview(imageDim)
//        
//        card = Card()
//        card.contentView = container
//        card.depthPreset = .depth3
//        mainView.addSubview(container)
//        mainView.layout(card).center()
//
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
        toolbar.backgroundColor = Color.grey.lighten5
        
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.grey.base
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
        card = PresenterCard()
        card.backgroundColor = Color.grey.lighten5
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .wideRectangle2
        
        card.presenterView = houseThumbnail
        card.contentViewEdgeInsetsPreset = .wideRectangle3
        
        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .wideRectangle2
        card.bottomBar?.height = 20.0
        
        card.depthPreset = .depth3
        
        mainView.layout(card).horizontally(left: 0, right: 0).center()
    }


}
