//
//  HouseDetailViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Toaster


class HouseDetailViewController: UIViewController, HouseDetailScrollListener {
    
    static let MAX_AMENITY_ICONS = 6
    
    var house : VillimHouse! = nil
    var lastReviewContent : String = ""
    var lastReviewReviewer : String = ""
    var lastReviewProfilePictureUrl : String = ""
    var lastReviewRating : Float = 0
    
    var houseDetailTableViewController : HouseDetailTableViewController!
    
    var houseImageView : UIImageView!
    
    var loadingIndicator : NVActivityIndicatorView!
    
    let originalHouseImageViewHeight : CGFloat! = 300
    var navControllerHeight : CGFloat!
    var statusBarHeight : CGFloat!
    var topOffset : CGFloat!
    var prevContentOffset : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        navControllerHeight = self.navigationController!.navigationBar.frame.height
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        topOffset = navControllerHeight + statusBarHeight
        prevContentOffset = 0
        
        /* Remove title */
        
        /* Make navbar transparent */
        
        /* Make navbar transparent */
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        /* House ImageView */
        houseImageView = UIImageView()
        self.view.addSubview(houseImageView!)
        
        /* House Table View */
        houseDetailTableViewController = HouseDetailTableViewController()
        houseDetailTableViewController.houseDetailScrollListener = self
        houseDetailTableViewController.house = self.house
        self.view.addSubview(houseDetailTableViewController.view)
        
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
        
        sendHouseInfoRequest()
    }
    
    func makeConstraints() {
        /* House ImageView */
        houseImageView?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(originalHouseImageViewHeight)
            make.top.equalTo(self.view)
        }
        
        /* Tableview */
        houseDetailTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(houseImageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func sendHouseInfoRequest() {
        
        showLoadingIndicator()
        
        let parameters = [VillimKeys.KEY_PREFERENCE_CURRENCY : VillimSession.getCurrencyPref(),
                          VillimKeys.KEY_HOUSE_ID : house.houseId] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.HOUSE_INFO_URL)

        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    self.house = VillimHouse.init(houseInfo: responseData[VillimKeys.KEY_HOUSE_INFO])
                    self.lastReviewContent =
                        responseData[VillimKeys.KEY_REVIEW_LAST_CONTENT].exists() ? responseData[VillimKeys.KEY_REVIEW_LAST_CONTENT].stringValue : ""
                    self.lastReviewReviewer =
                        responseData[VillimKeys.KEY_REVIEW_LAST_REVIEWER].exists() ? responseData[VillimKeys.KEY_REVIEW_LAST_REVIEWER].stringValue : ""
                    self.lastReviewProfilePictureUrl =
                        responseData[VillimKeys.KEY_REVIEW_LAST_PROFILE_PIC_URL].exists() ? responseData[VillimKeys.KEY_REVIEW_LAST_PROFILE_PIC_URL].stringValue : ""
                    self.lastReviewRating =
                        responseData[VillimKeys.KEY_REVIEW_LAST_RATING].exists() ? responseData[VillimKeys.KEY_REVIEW_LAST_RATING].floatValue : 0.0

                    self.houseDetailTableViewController.house = self.house
                    self.houseDetailTableViewController.lastReviewContent = self.lastReviewContent
                    self.houseDetailTableViewController.lastReviewReviewer = self.lastReviewReviewer
                    self.houseDetailTableViewController.lastReviewProfilePictureUrl = self.lastReviewProfilePictureUrl
                    self.houseDetailTableViewController.lastReviewRating = self.lastReviewRating
                    self.houseDetailTableViewController.tableView.reloadData()
                    
                    self.populateView()
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }
    
    func populateView() {
        /* Add house image */
        let url = URL(string: house.houseThumbnailUrl)
        Nuke.loadImage(with: url!, into: self.houseImageView)
        
    }
    
    func onScroll(contentOffset:CGPoint) {
        let contentVector = contentOffset.y - prevContentOffset
        prevContentOffset = contentOffset.y
        var newHeight = houseImageView.bounds.height - contentVector
        
        if newHeight < topOffset {
            newHeight = topOffset
        } else if newHeight > originalHouseImageViewHeight {
            newHeight = originalHouseImageViewHeight
        }
        
        houseImageView?.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(newHeight)
        }
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
    }
}
