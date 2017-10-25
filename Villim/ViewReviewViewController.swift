//
//  ViewReviewViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/2/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON
import Toaster

class ViewReviewViewController: UIViewController {

    var houseId              : Int! = 0
    
    var ratingOverall        : Double = 0.0
    var ratingAccuracy       : Double = 0.0
    var ratingLocation       : Double = 0.0
    var ratingCommunication  : Double = 0.0
    var ratingCheckin        : Double = 0.0
    var ratingCleanliness    : Double = 0.0
    var ratingValue          : Double = 0.0
    
    var reviews              : [VillimReview] = []
    
    let starSize             : Double = 13.0
    let starMargin           : Double = 5.0
    let sideMargin           : CGFloat = 20.0
    let verticalMargin       : CGFloat = 10.0
    
    var reviewTitle            : UILabel!
    
    var reviewContainer        : UIView!
    var reviewCountLabel       : UILabel!
    
    var accuracyLabel          : UILabel!
    var locationLabel          : UILabel!
    var communicationLabel     : UILabel!
    var checkinLabel           : UILabel!
    var cleanlinessLabel       : UILabel!
    var valueLabel             : UILabel!
    
    var ratingBarOverall       : CosmosView!
    var ratingBarAccuracy      : CosmosView!
    var ratingBarLocation      : CosmosView!
    var ratingBarCommunication : CosmosView!
    var ratingBarCheckin       : CosmosView!
    var ratingBarCleanliness   : CosmosView!
    var ratingBarValue         : CosmosView!
    
    var reviewTableViewController : ViewReviewTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = VillimValues.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = VillimValues.backgroundColor
        
        /* Add Title */
        reviewTitle = UILabel()
        reviewTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        reviewTitle.textColor = UIColor(red:0.02, green:0.05, blue:0.08, alpha:1.0)
        reviewTitle.text = NSLocalizedString("review", comment: "")
        self.view.addSubview(reviewTitle)
        
        /* Review overview */
        reviewContainer = UIView()
        self.view.addSubview(reviewContainer)
    
        initRatingLabels()
        initRatingBars()
        
        /* Populate tableview */
        reviewTableViewController = ViewReviewTableViewController()
        self.view.addSubview(reviewTableViewController.view)
        
        populateViews()
        makeConstraints()
        
//        sendHouseReviewRequest()
    }

    func initRatingLabels() {
        reviewCountLabel = UILabel()
        reviewTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        reviewTitle.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        reviewContainer.addSubview(reviewCountLabel)
        
        accuracyLabel = UILabel()
        accuracyLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        accuracyLabel.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        accuracyLabel.text = NSLocalizedString("accuracy", comment: "")
        reviewContainer.addSubview(accuracyLabel)
    
        locationLabel = UILabel()
        locationLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        locationLabel.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        locationLabel.text = NSLocalizedString("location", comment: "")
        reviewContainer.addSubview(locationLabel)
    
        communicationLabel = UILabel()
        communicationLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        communicationLabel.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        communicationLabel.text = NSLocalizedString("communication", comment: "")
        reviewContainer.addSubview(communicationLabel)
    
        checkinLabel = UILabel()
        checkinLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        checkinLabel.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        checkinLabel.text = NSLocalizedString("checkin", comment: "")
        reviewContainer.addSubview(checkinLabel)
    
        cleanlinessLabel = UILabel()
        cleanlinessLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        cleanlinessLabel.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        cleanlinessLabel.text = NSLocalizedString("cleanliness", comment: "")
        reviewContainer.addSubview(cleanlinessLabel)
    
        valueLabel = UILabel()
        valueLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        valueLabel.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        valueLabel.text = NSLocalizedString("value", comment: "")
        reviewContainer.addSubview(valueLabel)
    }
    
    func initRatingBars() {
        ratingBarOverall = CosmosView()
        ratingBarOverall.settings.updateOnTouch = false
        ratingBarOverall.settings.fillMode = .precise
        ratingBarOverall.settings.starSize = starSize
        ratingBarOverall.settings.starMargin = starMargin
        ratingBarOverall.rating = self.ratingOverall
        ratingBarOverall.settings.filledImage = UIImage(named: "icon_star_on")
        ratingBarOverall.settings.emptyImage = UIImage(named: "icon_star_off")
        reviewContainer.addSubview(ratingBarOverall)
        
        ratingBarAccuracy = CosmosView()
        ratingBarAccuracy.settings.updateOnTouch = false
        ratingBarAccuracy.settings.fillMode = .precise
        ratingBarAccuracy.settings.starSize = starSize
        ratingBarAccuracy.settings.starMargin = starMargin
        ratingBarAccuracy.rating = self.ratingAccuracy
        ratingBarAccuracy.settings.filledImage = UIImage(named: "icon_star_on")
        ratingBarAccuracy.settings.emptyImage = UIImage(named: "icon_star_off")
        reviewContainer.addSubview(ratingBarAccuracy)
        
        ratingBarLocation = CosmosView()
        ratingBarLocation.settings.updateOnTouch = false
        ratingBarLocation.settings.fillMode = .precise
        ratingBarLocation.settings.starSize = starSize
        ratingBarLocation.settings.starMargin = starMargin
        ratingBarLocation.rating = self.ratingLocation
        ratingBarLocation.settings.filledImage = UIImage(named: "icon_star_on")
        ratingBarLocation.settings.emptyImage = UIImage(named: "icon_star_off")
        reviewContainer.addSubview(ratingBarLocation)
        
        ratingBarCommunication = CosmosView()
        ratingBarCommunication.settings.updateOnTouch = false
        ratingBarCommunication.settings.fillMode = .precise
        ratingBarCommunication.settings.starSize = starSize
        ratingBarCommunication.settings.starMargin = starMargin
        ratingBarCommunication.rating = self.ratingCommunication
        ratingBarCommunication.settings.filledImage = UIImage(named: "icon_star_on")
        ratingBarCommunication.settings.emptyImage = UIImage(named: "icon_star_off")
        reviewContainer.addSubview(ratingBarCommunication)
        
        ratingBarCheckin = CosmosView()
        ratingBarCheckin.settings.updateOnTouch = false
        ratingBarCheckin.settings.fillMode = .precise
        ratingBarCheckin.settings.starSize = starSize
        ratingBarCheckin.settings.starMargin = starMargin
        ratingBarCheckin.rating = self.ratingCheckin
        ratingBarCheckin.settings.filledImage = UIImage(named: "icon_star_on")
        ratingBarCheckin.settings.emptyImage = UIImage(named: "icon_star_off")
        reviewContainer.addSubview(ratingBarCheckin)
        
        ratingBarCleanliness = CosmosView()
        ratingBarCleanliness.settings.updateOnTouch = false
        ratingBarCleanliness.settings.fillMode = .precise
        ratingBarCleanliness.settings.starSize = starSize
        ratingBarCleanliness.settings.starMargin = starMargin
        ratingBarCleanliness.rating = self.ratingCleanliness
        ratingBarCleanliness.settings.filledImage = UIImage(named: "icon_star_on")
        ratingBarCleanliness.settings.emptyImage = UIImage(named: "icon_star_off")
        reviewContainer.addSubview(ratingBarCleanliness)
        
        ratingBarValue = CosmosView()
        ratingBarValue.settings.updateOnTouch = false
        ratingBarValue.settings.fillMode = .precise
        ratingBarValue.settings.starSize = starSize
        ratingBarValue.settings.starMargin = starMargin
        ratingBarValue.rating = self.ratingValue
        ratingBarValue.settings.filledImage = UIImage(named: "icon_star_on")
        ratingBarValue.settings.emptyImage = UIImage(named: "icon_star_off")
        reviewContainer.addSubview(ratingBarValue)
        
    }
    
    func populateViews() {
        
        /* Review count */
        reviewCountLabel.text = String(format: NSLocalizedString("review_count_format", comment: ""), self.reviews.count)
        
        /* Rating bars */
        ratingBarOverall.rating = self.ratingOverall
        ratingBarAccuracy.rating = self.ratingOverall
        ratingBarLocation.rating = self.ratingOverall
        ratingBarCommunication.rating = self.ratingOverall
        ratingBarCheckin.rating = self.ratingOverall
        ratingBarCleanliness.rating = self.ratingOverall
        ratingBarValue.rating = self.ratingOverall
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Review title */
        reviewTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(sideMargin)
            make.top.equalTo(self.view).offset(topOffset + sideMargin * 0.3)
        }
        
        /* Review overview */
        reviewContainer?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(sideMargin)
            make.right.equalToSuperview().offset(-sideMargin)
            make.top.equalTo(reviewTitle.snp.bottom).offset(sideMargin)
            make.height.equalTo(150.0)
        }
        
        reviewCountLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        ratingBarOverall?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.centerY.equalTo(reviewCountLabel)
        }
        
        accuracyLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(reviewCountLabel.snp.bottom).offset(verticalMargin)
        }
        
        ratingBarAccuracy?.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(reviewContainer.snp.centerX).offset(-sideMargin/2)
            make.centerY.equalTo(accuracyLabel)
        }
        
        locationLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewContainer.snp.centerX).offset(sideMargin/2)
            make.top.equalTo(reviewCountLabel.snp.bottom).offset(verticalMargin)
        }
        
        ratingBarLocation?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.centerY.equalTo(locationLabel)
        }
        
        communicationLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(accuracyLabel.snp.bottom).offset(verticalMargin)
        }
        
        ratingBarCommunication?.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(reviewContainer.snp.centerX).offset(-sideMargin/2)
            make.centerY.equalTo(communicationLabel)
        }
        
        checkinLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewContainer.snp.centerX).offset(sideMargin/2)
            make.top.equalTo(accuracyLabel.snp.bottom).offset(verticalMargin)
        }
        
        ratingBarCheckin?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.centerY.equalTo(checkinLabel)
        }
        
        cleanlinessLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(communicationLabel.snp.bottom).offset(verticalMargin)
        }
        
        ratingBarCleanliness?.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(reviewContainer.snp.centerX).offset(-sideMargin/2)
            make.centerY.equalTo(cleanlinessLabel)
        }
        
        valueLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(reviewContainer.snp.centerX).offset(sideMargin/2)
            make.top.equalTo(communicationLabel.snp.bottom).offset(verticalMargin)
        }
        
        ratingBarValue?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.centerY.equalTo(valueLabel)
        }
        
        /* Tableview */
        reviewTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(sideMargin)
            make.right.equalToSuperview().offset(-sideMargin)
            make.top.equalTo(reviewContainer.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
    }
    
    @objc private func sendHouseReviewRequest() {
        
        VillimUtils.showLoadingIndicator()
        
        let parameters = [VillimKeys.KEY_HOUSE_ID : self.houseId] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.HOUSE_REVIEW_URL)
        
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                
                let successExists : Bool = responseData[VillimKeys.KEY_SUCCESS].exists()
                let success       : Bool = successExists ? responseData[VillimKeys.KEY_SUCCESS].boolValue : false
                
                if successExists && success {

                    self.ratingOverall = responseData[VillimKeys.KEY_RATING_OVERALL].exists() ? responseData[VillimKeys.KEY_RATING_OVERALL].doubleValue : 0.0
                    self.ratingAccuracy = responseData[VillimKeys.KEY_RATING_ACCURACY].exists() ? responseData[VillimKeys.KEY_RATING_ACCURACY].doubleValue : 0.0
                    self.ratingLocation = responseData[VillimKeys.KEY_RATING_LOCATION].exists() ? responseData[VillimKeys.KEY_RATING_LOCATION].doubleValue : 0.0
                    self.ratingCommunication = responseData[VillimKeys.KEY_RATING_COMMUNICATION].exists() ? responseData[VillimKeys.KEY_RATING_COMMUNICATION].doubleValue : 0.0
                    self.ratingCheckin = responseData[VillimKeys.KEY_RATING_CHECKIN].exists() ? responseData[VillimKeys.KEY_RATING_CHECKIN].doubleValue : 0.0
                    self.ratingCleanliness = responseData[VillimKeys.KEY_RATING_CLEANLINESS].exists() ? responseData[VillimKeys.KEY_RATING_CLEANLINESS].doubleValue : 0.0
                    self.ratingValue = responseData[VillimKeys.KEY_RATING_VALUE].exists() ? responseData[VillimKeys.KEY_RATING_VALUE].doubleValue : 0.0
                    
                    self.reviews = responseData[VillimKeys.KEY_REVIEWS].exists() ? VillimReview.reviewArrayFromJsonArray(jsonReviews: responseData[VillimKeys.KEY_REVIEWS].arrayValue) : []
                    
                    self.reviewTableViewController.reviews = self.reviews
                    self.reviewTableViewController.tableView.reloadData()
                    
                    self.populateViews()
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = CGFloat(1.0)
        
        let reviewBorder = CALayer()
        reviewBorder.borderColor = VillimValues.dividerColor.cgColor
        reviewBorder.frame = CGRect(x: 0, y: reviewContainer.frame.size.height - width, width:  reviewContainer.frame.size.width, height: reviewContainer.frame.size.height)
        reviewBorder.backgroundColor = UIColor.clear.cgColor
        reviewBorder.borderWidth = width
        reviewContainer.layer.addSublayer(reviewBorder)
        reviewContainer.layer.masksToBounds = true
    }
    
    private func showErrorMessage(message:String) {
        let toast = Toast(text: message, duration: Delay.long)
        
        ToastView.appearance().bottomOffsetPortrait = (tabBarController?.tabBar.frame.size.height)! + 30
        ToastView.appearance().bottomOffsetLandscape = (tabBarController?.tabBar.frame.size.height)! + 30
        ToastView.appearance().font = UIFont.systemFont(ofSize: 17.0)
        
        toast.show()
    }
    
    private func hideErrorMessage() {
        ToastCenter.default.cancelAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideErrorMessage()
        VillimUtils.hideLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
