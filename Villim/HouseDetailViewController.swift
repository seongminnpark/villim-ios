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
import SwiftDate

protocol HouseDetailDelegate {
    func onCollapse()
    func onOpen()
}

class HouseDetailViewController: UIViewController, HouseDetailTableViewDelegate {
    
    static let MAX_AMENITY_ICONS = 6
    
    var houseDetailDelegate : HouseDetailDelegate!
    
    var house : VillimHouse! = nil
    var lastReviewContent : String = ""
    var lastReviewReviewer : String = ""
    var lastReviewProfilePictureUrl : String = ""
    var lastReviewRating : Float = 0
    
    var dateSet : Bool = false
    var checkIn : DateInRegion!
    var checkOut : DateInRegion!
    
    let houseImageViewMaxHeight : CGFloat! = 300
    var navControllerHeight : CGFloat!
    var statusBarHeight : CGFloat!
    var topOffset : CGFloat!
    var prevContentOffset : CGFloat!
    let tableViewInset : CGFloat! = 20.0
    
    var houseDetailTableViewController : HouseDetailTableViewController!
    var houseImageView : UIImageView!
    var leftButton : UIButton!
    var leftButtonStackView : UIStackView!
    var leftButtonImageView : UIImageView!
    var leftButtonLabel     : UILabel!
    var rightButton : UIButton!
    var loadingIndicator : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        navControllerHeight = self.navigationController!.navigationBar.frame.height
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        topOffset = navControllerHeight + statusBarHeight
        prevContentOffset = 0
        
        /* House ImageView */
        houseImageView = UIImageView()
        self.view.addSubview(houseImageView!)
        
        /* House Table View */
        houseDetailTableViewController = HouseDetailTableViewController()
        houseDetailTableViewController.houseDetailDelegate = self
        houseDetailTableViewController.house = self.house
        self.view.addSubview(houseDetailTableViewController.view)
        
        /* Bottom Buttons */
        leftButton = UIButton()
        leftButton.setBackgroundColor(color: VillimValues.darkBottomButtonColor, forState: .normal)
        self.view.addSubview(leftButton)
        
        leftButtonStackView = UIStackView()
        leftButtonStackView.axis = UILayoutConstraintAxis.horizontal
        leftButtonStackView.distribution = UIStackViewDistribution.fillProportionally
        leftButtonStackView.alignment = UIStackViewAlignment.center
        leftButtonStackView.spacing = 10.0
        
        leftButtonImageView = UIImageView()
        leftButtonImageView.image = #imageLiteral(resourceName: "icon_coin")
        leftButtonStackView.addArrangedSubview(leftButtonImageView)
        
        leftButtonLabel = UILabel()
        leftButtonLabel.textColor = UIColor.white
        leftButtonLabel.font = UIFont(name: "NotoSansCJKkr-Medium", size: 17)
        leftButtonStackView.addArrangedSubview(leftButtonLabel)
        
        leftButton.addTarget(self, action: #selector(self.launchReservationViewController), for: .touchUpInside)
        leftButton.addSubview(leftButtonStackView)
    
        rightButton = UIButton.init(type: .custom)
        rightButton.setTitle(NSLocalizedString("request_visit", comment: ""), for: .normal)
        rightButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        rightButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 17)
        rightButton.addTarget(self, action: #selector(self.launchReservationViewController), for: .touchUpInside)
        self.view.addSubview(rightButton)
 
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
        
        sendHouseInfoRequest()
    }
    
    func makeConstraints() {
        /* House ImageView */
        houseImageView?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(houseImageViewMaxHeight)
            make.top.equalTo(self.view)
        }
        
        /* Tableview */
        houseDetailTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(houseImageView.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        /* Bottom buttons */
        let screenWidth = UIScreen.main.bounds.width
        // 1.7 : 1 ratio
        let leftButtonWidth = screenWidth * 0.63
        let rightButtonWidth = screenWidth * 0.37
        
        leftButton.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(leftButtonWidth)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        leftButtonStackView.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(rightButtonWidth)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.right.equalToSuperview()
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

                let successExists : Bool = responseData[VillimKeys.KEY_SUCCESS].exists()
                let success       : Bool = successExists ? responseData[VillimKeys.KEY_SUCCESS].boolValue : false
                let hosueExists   : Bool = responseData[VillimKeys.KEY_HOUSE_INFO].exists()
                
                if successExists && success && hosueExists {
                    let houseInfo : JSON = responseData[VillimKeys.KEY_HOUSE_INFO]
                    self.house = VillimHouse.init(houseInfo: houseInfo)
                    self.lastReviewContent =
                        houseInfo[VillimKeys.KEY_REVIEW_LAST_CONTENT].exists() ? houseInfo[VillimKeys.KEY_REVIEW_LAST_CONTENT].stringValue : ""
                    self.lastReviewReviewer =
                        houseInfo[VillimKeys.KEY_REVIEW_LAST_REVIEWER].exists() ? houseInfo[VillimKeys.KEY_REVIEW_LAST_REVIEWER].stringValue : ""
                    self.lastReviewProfilePictureUrl =
                        houseInfo[VillimKeys.KEY_REVIEW_LAST_PROFILE_PIC_URL].exists() ? houseInfo[VillimKeys.KEY_REVIEW_LAST_PROFILE_PIC_URL].stringValue : ""
                    self.lastReviewRating =
                        houseInfo[VillimKeys.KEY_REVIEW_LAST_RATING].exists() ? houseInfo[VillimKeys.KEY_REVIEW_LAST_RATING].floatValue : 0.0

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
        
        /* Populate bottom button */
        leftButtonLabel.text = VillimUtils.getRentString(rent: house.ratePerMonth)
        
    }
    
    func onScroll(contentOffset:CGPoint) {
        let contentVector = contentOffset.y - prevContentOffset
        prevContentOffset = contentOffset.y
        var newHeight = houseImageView.bounds.height - contentVector
        
        if newHeight <= topOffset {
            newHeight = topOffset
            houseDetailDelegate.onCollapse()
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else if newHeight > houseImageViewMaxHeight {
            newHeight = houseImageViewMaxHeight
        } else {
            houseDetailDelegate.onOpen()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController!.navigationBar.barTintColor = UIColor.clear
        }
        
        houseImageView?.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(newHeight)
        }

    }
    
    func launchViewController(viewController:UIViewController, animated:Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }

    func launchReservationViewController() {
        let reservationViewController = ReservationViewController()
        reservationViewController.house = self.house
        reservationViewController.dateSet = self.dateSet
        reservationViewController.checkIn = self.checkIn
        reservationViewController.checkOut = self.checkOut
        self.navigationController?.pushViewController(reservationViewController, animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        /* Make navbar transparent */
        self.navigationController?.navigationBar.isTranslucent = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
    }
}
