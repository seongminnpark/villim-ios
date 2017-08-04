//
//  RateHouseViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/29/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

protocol RatingSubmitListener {
    func onRatingSubmit(ratingAccuracy      : Double,
                        ratingLocation      : Double,
                        ratingCommunication : Double,
                        ratingCheckin       : Double,
                        ratingCleanliness   : Double,
                        ratingValue         : Double )
}

class RateHouseViewController: UIViewController, RatingSetListener {

    static let RATING_CATEGORY_ACCURACY      = 0
    static let RATING_CATEGORY_LOCATION      = 1
    static let RATING_CATEGORY_COMMUNICATION = 2
    static let RATING_CATEGORY_CHECKIN       = 3
    static let RATING_CATEGORY_CLEANLINESS   = 4
    static let RATING_CATEGORY_VALUE         = 5
    
    var ratingAccuracy       : Double = 0.0
    var ratingLocation       : Double = 0.0
    var ratingCommunication  : Double = 0.0
    var ratingCheckin        : Double = 0.0
    var ratingCleanliness    : Double = 0.0
    var ratingValue          : Double = 0.0
    
    var listener : RatingSubmitListener!
    
    var rateHouseTableViewController : RateHouseTableViewController!
    var applyButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("rate", comment: "")
        
        /* Populate tableview */
        rateHouseTableViewController = RateHouseTableViewController()
        rateHouseTableViewController.listener = self
        self.view.addSubview(rateHouseTableViewController.view)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        /* Apply button */
        applyButton = UIButton()
        applyButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        applyButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
        applyButton.adjustsImageWhenHighlighted = true
        applyButton.titleLabel?.font = VillimValues.bottomButtonFont
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.setTitleColor(VillimValues.whiteHighlightedColor, for: .highlighted)
        applyButton.setTitle(NSLocalizedString("apply", comment: ""), for: .normal)
        applyButton.addTarget(self, action: #selector(self.applyRating), for: .touchUpInside)
        self.view.addSubview(applyButton)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Tableview */
        rateHouseTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view)
            make.top.equalTo(self.view).offset(topOffset)
            make.bottom.equalTo(self.view)
        }
        
        /* Apply button */
        applyButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
    }
    
    func applyRating() {
        listener.onRatingSubmit(ratingAccuracy:      self.ratingAccuracy,
                                ratingLocation:      self.ratingLocation,
                                ratingCommunication: self.ratingCommunication,
                                ratingCheckin:       self.ratingCheckin,
                                ratingCleanliness:   self.ratingCleanliness,
                                ratingValue:         self.ratingCleanliness)
        self.navigationController?.popViewController(animated: true)
    }

    
    func onRatingSet(category:Int, value:Double) {
        switch category {
        case RateHouseViewController.RATING_CATEGORY_ACCURACY:
            self.ratingAccuracy = value
            break
        case RateHouseViewController.RATING_CATEGORY_LOCATION:
            self.ratingLocation = value
            break
        case RateHouseViewController.RATING_CATEGORY_COMMUNICATION:
            self.ratingCommunication = value
            break
        case RateHouseViewController.RATING_CATEGORY_CHECKIN:
            self.ratingCheckin = value
            break
        case RateHouseViewController.RATING_CATEGORY_CLEANLINESS:
            self.ratingCleanliness = value
            break
        case RateHouseViewController.RATING_CATEGORY_VALUE:
            self.ratingValue = value
            break
        default:
            break
        }
    }

    func getRating(category:Int) -> Double {
        switch category {
        case RateHouseViewController.RATING_CATEGORY_ACCURACY:
            return self.ratingAccuracy
        case RateHouseViewController.RATING_CATEGORY_LOCATION:
            return self.ratingLocation
        case RateHouseViewController.RATING_CATEGORY_COMMUNICATION:
            return self.ratingCommunication
        case RateHouseViewController.RATING_CATEGORY_CHECKIN:
            return self.ratingCheckin
        case RateHouseViewController.RATING_CATEGORY_CLEANLINESS:
            return self.ratingCleanliness
        case RateHouseViewController.RATING_CATEGORY_VALUE:
            return self.ratingValue

        default:
            return self.ratingAccuracy
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
