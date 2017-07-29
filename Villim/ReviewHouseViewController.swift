//
//  ReviewHouseViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/29/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Cosmos

class ReviewHouseViewController: UIViewController, RatingSubmitListener, UITextFieldDelegate {

    var houseId              : Int! = 0
    
    var ratingOverall        : Double = 0.0
    var ratingAccuracy       : Double = 0.0
    var ratingLocation       : Double = 0.0
    var ratingCommunication  : Double = 0.0
    var ratingCheckin        : Double = 0.0
    var ratingCleanliness    : Double = 0.0
    var ratingValue          : Double = 0.0
    
    var ratingContainer      : UIView!
    var ratingLabel          : UILabel!
    var ratingBar            : CosmosView!
    var rateButton           : UIButton!
    var reviewLabel          : UILabel!
    var reviewContentField   : UITextField!
    var nextButton           : UIButton!
    
    var errorMessage         : UILabel!
    var loadingIndicator     : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.title = NSLocalizedString("review_house", comment: "")
        
        /* Rating container */
        ratingContainer = UIView()
        self.view.addSubview(ratingContainer)
        
        /* Rating Label */
        ratingLabel = UILabel()
        ratingLabel.text = NSLocalizedString("rating", comment: "")
        ratingContainer.addSubview(ratingLabel)
        
        /* Rating bar */
        ratingBar = CosmosView()
        ratingBar.settings.updateOnTouch = false
        ratingBar.settings.fillMode = .precise
        ratingBar.settings.starSize = 30
        ratingBar.settings.starMargin = 5
        ratingBar.rating = self.ratingOverall
        ratingContainer.addSubview(ratingBar)
        
        /* Rate button */
        rateButton = UIButton()
        rateButton.setTitle(NSLocalizedString("rate", comment: ""), for: .normal)
        rateButton.setTitleColor(UIColor.gray, for: .normal)
        rateButton.setTitleColor(UIColor.black, for: .highlighted)
        rateButton.addTarget(self, action:#selector(self.launchRateHouseViewController), for: .touchUpInside)
        ratingContainer.addSubview(rateButton)
        
        /* Review Label */
        reviewLabel = UILabel()
        reviewLabel.text = NSLocalizedString("review", comment: "")
        self.view.addSubview(reviewLabel)
        
        /* Review content field */
        reviewContentField = UITextField()
        reviewContentField.placeholder = NSLocalizedString("review_content_placeholder", comment: "")
        reviewContentField.autocapitalizationType = .none
        reviewContentField.returnKeyType = .done
        reviewContentField.delegate = self
        self.view.addSubview(reviewContentField)
        
        /* Next button */
        nextButton = UIButton()
        nextButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        nextButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
        nextButton.adjustsImageWhenHighlighted = true
        nextButton.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(self.sendReviewHouseRequest), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        /* Error message */
        errorMessage = UILabel()
        errorMessage.textAlignment = .center
        self.view.addSubview(errorMessage)
        
        /* Loading inidcator */
        let screenCenterX = UIScreen.main.bounds.width / 2
        let screenCenterY = UIScreen.main.bounds.height / 2
        let indicatorViewLeft = screenCenterX - VillimValues.loadingIndicatorSize / 2
        let indicatorViweRIght = screenCenterY - VillimValues.loadingIndicatorSize / 2
        let loadingIndicatorFrame = CGRect(x:indicatorViewLeft, y:indicatorViweRIght,
                                           width:VillimValues.loadingIndicatorSize, height: VillimValues.loadingIndicatorSize)
        loadingIndicator = NVActivityIndicatorView(
            frame: loadingIndicatorFrame,
            type: .orbit,
            color: VillimValues.themeColor)
        self.view.addSubview(loadingIndicator)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Rating Container */
        ratingContainer?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(topOffset)
            make.height.equalTo(80)
        }
        
        /* Rating label */
        ratingLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        /* Rating bar */
        ratingBar?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(ratingLabel.snp.right)
            make.centerY.equalToSuperview()
        }
        
        /* Rate button */
        rateButton?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        /* Review label */
        reviewLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(ratingContainer.snp.bottom)
        }
        
        /* Review content field */
        reviewContentField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(reviewLabel.snp.bottom)
        }
        
        /* Next button */
        nextButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(30)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = VillimValues.dividerColor.cgColor
        border.frame = CGRect(x: 0, y: ratingContainer.frame.size.height - width, width:  ratingContainer.frame.size.width, height: ratingContainer.frame.size.height)
        border.backgroundColor = UIColor.clear.cgColor
        border.borderWidth = width
        ratingContainer.layer.addSublayer(border)
        ratingContainer.layer.masksToBounds = true
    }

    @objc private func sendReviewHouseRequest() {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_HOUSE_ID             : houseId,
            VillimKeys.KEY_REVIEW_CONTENT       : (reviewContentField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
            VillimKeys.KEY_RATING_OVERALL       : 0.0,
            VillimKeys.KEY_RATING_ACCURACY      : 0.0,
            VillimKeys.KEY_RATING_LOCATION      : 0.0,
            VillimKeys.KEY_RATING_COMMUNICATION : 0.0,
            VillimKeys.KEY_RATING_CHECKIN       : 0.0,
            VillimKeys.KEY_RATING_CLEANLINESS   : 0.0,
            VillimKeys.KEY_RATING_VALUE         : 0.0,
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.HOUSE_REVIEW_URL)
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                
                if responseData[VillimKeys.KEY_CHANGE_SUCCESS].boolValue {
                    
                    
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }

    
    func launchRateHouseViewController() {
        let rateHouseViewController = RateHouseViewController()
        rateHouseViewController.listener            = self
        rateHouseViewController.ratingAccuracy      = self.ratingAccuracy
        rateHouseViewController.ratingLocation      = self.ratingLocation
        rateHouseViewController.ratingCommunication = self.ratingCommunication
        rateHouseViewController.ratingCheckin       = self.ratingCheckin
        rateHouseViewController.ratingCleanliness   = self.ratingCleanliness
        rateHouseViewController.ratingValue         = self.ratingValue
        self.navigationController?.pushViewController(rateHouseViewController, animated: true)
    }
    
    func onRatingSubmit(ratingAccuracy      : Double,
                     ratingLocation      : Double,
                     ratingCommunication : Double,
                     ratingCheckin       : Double,
                     ratingCleanliness   : Double,
                     ratingValue         : Double ){
        
        self.ratingAccuracy      = ratingAccuracy
        self.ratingLocation      = ratingLocation
        self.ratingCommunication = ratingCommunication
        self.ratingCheckin       = ratingCheckin
        self.ratingCleanliness   = ratingCleanliness
        self.ratingValue         = ratingValue
        
        self.recalculateOverallRating()
    }
    
    func recalculateOverallRating() {
        self.ratingOverall =
            (self.ratingAccuracy + self.ratingLocation + self.ratingCommunication +
                self.ratingCheckin + self.ratingCleanliness + self.ratingValue) / 6.0
       
        self.ratingBar.rating = ratingOverall
        
    }
    
    /* Text field listeners */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    private func showErrorMessage(message:String) {
        errorMessage.isHidden = false
        errorMessage.text = message
    }
    
    private func hideErrorMessage() {
        errorMessage.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideErrorMessage()
    }

}
