//
//  MyKeyViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/9/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import SwiftyJSON
import Nuke
import Toaster
import AudioToolbox
import SwiftDate

class MyKeyViewController: ViewController, SlideButtonDelegate {
    
    let houseImageSize       : CGFloat = 200.0
    
    var houseId              : Int!    = 0
    var houseName            : String! = ""
    var checkIn              : DateInRegion!
    var checkOut             : DateInRegion!
    var houseThumbnailUrl    : String! = ""
    
    let slideButtonWidth     : CGFloat = 300.0
    let slideButtonHeight    : CGFloat = 60.0
    
    var reviewButton         : UIButton!
    var changePasscodeButton : UIButton!
    var container            : UIView!
    var houseImage           : UIImageView!
    var houseNameLabel       : UILabel!
    var houseDateLabel       : UILabel!
    
    var slideButton          : SlideButton!
    var findRoomButton       : UIButton!
    
    var errorMessage         : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.view.backgroundColor = VillimValues.backgroundColor
        self.title = "내 열쇠"
        
        /* Text buttons */
        reviewButton = UIButton()
        reviewButton.setTitle(NSLocalizedString("review_house", comment: ""), for: .normal)
        reviewButton.setTitleColor(VillimValues.inactiveButtonColor, for: .normal)
        reviewButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        reviewButton.addTarget(self, action:#selector(self.launchReviewHouseViewController), for: .touchUpInside)
        reviewButton.isEnabled = false
        self.view.addSubview(reviewButton)
        
        changePasscodeButton = UIButton()
        changePasscodeButton.setTitle(NSLocalizedString("change_doorlock_passcode", comment: ""), for: .normal)
        changePasscodeButton.setTitleColor(VillimValues.inactiveButtonColor, for: .normal)
        changePasscodeButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        changePasscodeButton.addTarget(self, action:#selector(self.launcChangePasscodeViewController), for: .touchUpInside)
        changePasscodeButton.isEnabled = false
        self.view.addSubview(changePasscodeButton)
        
        /* Info container */
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(container)
        
        /* House picture */
        houseImage = UIImageView()
        houseImage.layer.cornerRadius = houseImageSize / 2
        houseImage.layer.masksToBounds = true;
        
        /* Labels */
        houseNameLabel = UILabel()
        houseNameLabel.textAlignment = .center
        houseNameLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 17)
        houseNameLabel.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        
        houseDateLabel = UILabel()
        houseDateLabel.textAlignment = .center
        houseDateLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        houseDateLabel.textColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
        
        container.addSubview(houseImage)
        container.addSubview(houseNameLabel)
        container.addSubview(houseDateLabel)
        
        /* Error message */
        let errorTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 2 - 60
        errorMessage = UILabel(frame:CGRect(x:0, y:errorTop, width:UIScreen.main.bounds.width, height:50))
        errorMessage.textAlignment = .center
        errorMessage.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        errorMessage.textColor = VillimValues.themeColor
        self.view.addSubview(errorMessage)
        
        makeConstraints()

    }
    
    @objc private func sendMyHouseRequest() {
        
        VillimUtils.showLoadingIndicator()
        
        let parameters = [String : Any]()
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.MY_HOUSE_URL)
      
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)

                if responseData[VillimKeys.KEY_QUERY_SUCCESS].boolValue {
                    self.houseId           = responseData[VillimKeys.KEY_HOUSE_ID].exists() ? responseData[VillimKeys.KEY_HOUSE_ID].intValue : 0
                    self.houseName         = responseData[VillimKeys.KEY_HOUSE_NAME].exists() ? responseData[VillimKeys.KEY_HOUSE_NAME].stringValue : ""
                    let checkInString      = responseData[VillimKeys.KEY_CHECKIN].exists() ? responseData[VillimKeys.KEY_CHECKIN].stringValue : ""
                    self.checkIn           = VillimUtils.dateFromString(dateString: checkInString)
                    let checkOutString     = responseData[VillimKeys.KEY_CHECKOUT].exists() ? responseData[VillimKeys.KEY_CHECKOUT].stringValue : ""
                    self.checkOut          = VillimUtils.dateFromString(dateString: checkOutString)
                    self.houseThumbnailUrl = responseData[VillimKeys.KEY_HOUSE_THUMBNAIL_URL].exists() ? responseData[VillimKeys.KEY_HOUSE_THUMBNAIL_URL].stringValue : ""
                    
                    self.setUpKeyLayout()
                    
//                    self.populateViews()
                } else {
                    self.setUpNoKeyLayout()
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
        }
    }
    
    @objc private func sendOpenDoorlockRequest() {
        
        VillimUtils.showLoadingIndicator()
        
        let parameters = [String : Any]()
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.OPEN_DOORLOCK_URL)
        
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_OPEN_AUTHORIZED].boolValue && responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    self.showErrorMessage(message: NSLocalizedString("doorlock_open_success", comment: ""))
                    if VillimSession.getVibrationOnUnlock() {
                        if #available(iOS 10, *) {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        } else {
                            // use another api
                        }
                    }
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
        }
    }
    
    
    func populateViews() {
        
    }
    
    func makeConstraints() {
        
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        let sidePadding = (UIScreen.main.bounds.width - slideButtonWidth) / 4
        
        /* Text Buttons */
        reviewButton?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(sidePadding)
            make.top.equalTo(topOffset + sidePadding)
        }
        
        changePasscodeButton?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-sidePadding)
            make.top.equalTo(topOffset + sidePadding)
        }
        
        /* Room Info */
        houseImage?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(houseImageSize)
            make.height.equalTo(houseImageSize)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        houseNameLabel?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(houseImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        houseDateLabel?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(houseNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        container?.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(houseImage)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-slideButtonHeight)
        }
        
        
    }
    
    func setUpKeyLayout() {
        
        /* Slide button */
        let sliderLeft = UIScreen.main.bounds.width/2 - slideButtonWidth/2
        let sliderTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 2
        slideButton = SlideButton(frame:CGRect(x:sliderLeft,y:sliderTop, width:slideButtonWidth, height:slideButtonHeight))
        slideButton.buttonColor = VillimValues.themeColor
        slideButton.imageName = #imageLiteral(resourceName: "slider_thumb")
        slideButton.buttonText = NSLocalizedString("unlock_doorlock", comment: "")
        slideButton.delegate = self
        self.view.addSubview(slideButton)
        
        /* Room Info */
        if houseThumbnailUrl.isEmpty {
            houseImage.image = #imageLiteral(resourceName: "img_default")
        } else {
            let url = URL(string:houseThumbnailUrl)
            Nuke.loadImage(with: url!, into: houseImage)
        }
        
        houseNameLabel.text = self.houseName
        
        if self.checkIn != nil && self.checkOut != nil {
            houseDateLabel.text = String(format:NSLocalizedString("valid_dates_format", comment: ""),
                                         self.checkIn.year, self.checkIn.month, self.checkIn.day,
                                         self.checkOut.year, self.checkOut.month, self.checkOut.day)
        } else {
            houseDateLabel.text = ""
        }
        
         /* Top buttons */
        self.reviewButton.isEnabled = true
        self.reviewButton.setTitleColor(VillimValues.themeColor, for: .normal)
        self.reviewButton.setTitleColor(VillimValues.themeColorHighlighted, for: .highlighted)
        
        self.changePasscodeButton.isEnabled = true
        self.changePasscodeButton.setTitleColor(VillimValues.themeColor, for: .normal)
        self.changePasscodeButton.setTitleColor(VillimValues.themeColorHighlighted, for: .highlighted)

    }
    
    func setUpNoKeyLayout() {
        
        /* Top buttons */
        self.reviewButton.isEnabled = false
        self.reviewButton.setTitleColor(VillimValues.inactiveButtonColor, for: .normal)
        
        self.changePasscodeButton.isEnabled = false
        self.changePasscodeButton.setTitleColor(VillimValues.inactiveButtonColor, for: .normal)
    
        /* Find room button */
        let buttonLeft = UIScreen.main.bounds.width/2 - slideButtonWidth/2
        let buttonTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 2
        findRoomButton = UIButton(frame:CGRect(x:buttonLeft,y:buttonTop, width:slideButtonWidth, height:slideButtonHeight))
        findRoomButton.backgroundColor = VillimValues.themeColor
        findRoomButton.setTitle(NSLocalizedString("find_house", comment: ""), for: .normal)
        findRoomButton.setTitleColor(UIColor.white, for: .normal)
        findRoomButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        findRoomButton.layer.cornerRadius  = 30
        findRoomButton.layer.masksToBounds = true
        findRoomButton.addTarget(self, action:#selector(self.showDiscoverTab), for: .touchUpInside)
        self.view.addSubview(findRoomButton)
        
        /* Room Info */
        houseImage.image = #imageLiteral(resourceName: "img_default")
        houseNameLabel.text = NSLocalizedString("no_rented_house", comment: "")
        houseDateLabel.text = ""
    }
    
    func launchReviewHouseViewController() {
        self.tabBarController?.tabBar.isHidden = true
        let reviewHouseViewController = ReviewHouseViewController()
        reviewHouseViewController.houseId = houseId
        self.navigationController?.pushViewController(reviewHouseViewController, animated: true)
    }
    
    func launcChangePasscodeViewController() {
        self.tabBarController?.tabBar.isHidden = true
        let changePasscodeViewController = ChangePasscodeViewController()
        self.navigationController?.pushViewController(changePasscodeViewController, animated: true)
    }
    
    func showDiscoverTab() {
        self.tabBarController?.selectedIndex = 0;
    }
    
    func unLocked() {
        sendOpenDoorlockRequest()
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
        VillimUtils.hideLoadingIndicator()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        if VillimSession.getLoggedIn() {
            sendMyHouseRequest()
        } else {
            setUpNoKeyLayout()
        }
    }
    
}
