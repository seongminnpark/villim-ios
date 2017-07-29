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

class ReviewHouseViewController: UIViewController, UITextFieldDelegate {

    var houseId              : Int! = 0
    
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
        
        /* Rating Label */
        ratingLabel = UILabel()
        ratingLabel.text = NSLocalizedString("rating", comment: "")
        self.view.addSubview(ratingLabel)
        
        /* Rating bar */
        ratingBar = CosmosView()
        ratingBar.settings.updateOnTouch = false
        ratingBar.settings.fillMode = .precise
        ratingBar.settings.starSize = 30
        ratingBar.settings.starMargin = 5
        self.view.addSubview(ratingBar)
        
        /* Rate button */
        rateButton = UIButton()
        rateButton.setTitle(NSLocalizedString("rate", comment: ""), for: .normal)
        rateButton.setTitleColor(UIColor.gray, for: .normal)
        rateButton.setTitleColor(UIColor.black, for: .highlighted)
        rateButton.addTarget(self, action:#selector(self.rateHouseActivity), for: .touchUpInside)
        self.view.addSubview(rateButton)
        
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
        nextButton.setBackgroundColor(color: VillimUtils.themeColor, forState: .normal)
        nextButton.setBackgroundColor(color: VillimUtils.themeColorHighlighted, forState: .highlighted)
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
        let indicatorViewLeft = screenCenterX - VillimUtils.loadingIndicatorSize / 2
        let indicatorViweRIght = screenCenterY - VillimUtils.loadingIndicatorSize / 2
        let loadingIndicatorFrame = CGRect(x:indicatorViewLeft, y:indicatorViweRIght,
                                           width:VillimUtils.loadingIndicatorSize, height: VillimUtils.loadingIndicatorSize)
        loadingIndicator = NVActivityIndicatorView(
            frame: loadingIndicatorFrame,
            type: .orbit,
            color: VillimUtils.themeColor)
        self.view.addSubview(loadingIndicator)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Rating label */
        ratingLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(topOffset)
        }
        
        /* Rating bar */
        ratingBar?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(ratingLabel.snp.right)
            make.top.equalTo(topOffset)
        }
        
        /* Rate button */
        rateButton?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.top.equalTo(topOffset)
        }
        
        /* Review label */
        reviewLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(ratingLabel.snp.bottom)
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


    @objc private func sendReviewHouseRequest() {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_HOUSE_ID             : houseId,
            VillimKeys.KEY_REVIEW_CONTENT       : 0.0,
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

    
    func rateHouseActivity() {
        
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
