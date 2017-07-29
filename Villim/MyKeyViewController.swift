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
import NVActivityIndicatorView
import AudioToolbox

class MyKeyViewController: ViewController, SlideButtonDelegate {
    
    let houseImageSize       : CGFloat = 200.0
    
    var houseId              : Int!    = 0
    var houseName            : String! = ""
    var checkIn              : String! = ""
    var checkOut             : String! = ""
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
    
    var loadingIndicator     : NVActivityIndicatorView!
    var errorMessage         : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        self.title = "내 열쇠"
        
        /* Text buttons */
        reviewButton = UIButton()
        reviewButton.setTitle(NSLocalizedString("review_house", comment: ""), for: .normal)
        reviewButton.setTitleColor(UIColor.gray, for: .normal)
        reviewButton.setTitleColor(UIColor.black, for: .highlighted)
        reviewButton.addTarget(self, action:#selector(self.launchReviewHouseViewController), for: .touchUpInside)
        self.view.addSubview(reviewButton)
        
        changePasscodeButton = UIButton()
        changePasscodeButton.setTitle(NSLocalizedString("change_doorlock_passcode", comment: ""), for: .normal)
        changePasscodeButton.setTitleColor(UIColor.gray, for: .normal)
        changePasscodeButton.setTitleColor(UIColor.black, for: .highlighted)
        changePasscodeButton.addTarget(self, action:#selector(self.launcChangePasscodeViewController), for: .touchUpInside)
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
        houseDateLabel = UILabel()
        houseDateLabel.textAlignment = .center
        
        container.addSubview(houseImage)
        container.addSubview(houseNameLabel)
        container.addSubview(houseDateLabel)
        
        /* Loading inidcator */
        let screenCenterX = UIScreen.main.bounds.width / 2
        let screenCenterY = UIScreen.main.bounds.height / 2
        let indicatorViewLeft = screenCenterX - VillimUtils.loadingIndicatorSize / 2
        let indicatorViweRight = screenCenterY - VillimUtils.loadingIndicatorSize / 2
        let loadingIndicatorFrame = CGRect(x:indicatorViewLeft, y:indicatorViweRight,
                                           width:VillimUtils.loadingIndicatorSize, height: VillimUtils.loadingIndicatorSize)
        loadingIndicator = NVActivityIndicatorView(
            frame: loadingIndicatorFrame,
            type: .orbit,
            color: VillimUtils.themeColor)
        self.view.addSubview(loadingIndicator)
        
        /* Error message */
        let errorTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 2.5
        errorMessage = UILabel(frame:CGRect(x:0, y:errorTop, width:UIScreen.main.bounds.width, height:50))
        errorMessage.textAlignment = .center
        self.view.addSubview(errorMessage)
        
        makeConstraints()
        
        if VillimSession.getLoggedIn() {
            sendMyHouseRequest()
        } else {
            setUpNoKeyLayout()
        }
    }
    
    @objc private func sendMyHouseRequest() {
        
        showLoadingIndicator()
        
        let parameters = [String : Any]()
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.MY_HOUSE_URL)
      
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_QUERY_SUCCESS].boolValue {
                    self.houseId           = responseData[VillimKeys.KEY_HOUSE_ID].exists() ? responseData[VillimKeys.KEY_HOUSE_ID].intValue : 0
                    self.houseName         = responseData[VillimKeys.KEY_HOUSE_NAME].exists() ? responseData[VillimKeys.KEY_HOUSE_NAME].stringValue : ""
                    self.checkIn           = responseData[VillimKeys.KEY_CHECKIN].exists() ? responseData[VillimKeys.KEY_CHECKIN].stringValue : ""
                    self.checkOut          = responseData[VillimKeys.KEY_CHECKOUT].exists() ? responseData[VillimKeys.KEY_CHECKOUT].stringValue : ""
                    self.houseThumbnailUrl = responseData[VillimKeys.KEY_HOUSE_THUMBNAIL_URL].exists() ? responseData[VillimKeys.KEY_HOUSE_THUMBNAIL_URL].stringValue : ""
                    self.setUpKeyLayout()
                } else {
                    self.setUpNoKeyLayout()
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }
    
    @objc private func sendOpenDoorlockRequest() {
        
        showLoadingIndicator()
        
        let parameters = [String : Any]()
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.OPEN_DOORLOCK_URL)
        
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_OPEN_AUTHORIZED].boolValue && responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    self.showErrorMessage(message: NSLocalizedString("doorlock_open_success", comment: ""))
                    if #available(iOS 10, *) {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    } else {
                        // use another api
                    }
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }
    
    
    func populateViews() {
        
    }
    
    func makeConstraints() {
        
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Text Buttons */
        reviewButton?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(topOffset)
        }
        
        changePasscodeButton?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.top.equalTo(topOffset)
        }
        
        /* Room Info */
        houseImage?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(houseImageSize)
            make.height.equalTo(houseImageSize)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        houseNameLabel?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(houseImage.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        houseDateLabel?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(houseNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        container?.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(houseImage)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        
    }
    
    func setUpKeyLayout() {
        
        /* Slide button */
        let sliderLeft = UIScreen.main.bounds.width/2 - slideButtonWidth/2
        let sliderTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 1.5
        slideButton = SlideButton(frame:CGRect(x:sliderLeft,y:sliderTop, width:slideButtonWidth, height:slideButtonHeight))
        slideButton.backgroundColor = VillimUtils.themeColor
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
        
        houseNameLabel.text = houseName
        houseDateLabel.text = checkIn

    }
    
    func setUpNoKeyLayout() {
    
        /* Find room button */
        let buttonLeft = UIScreen.main.bounds.width/2 - slideButtonWidth/2
        let buttonTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 1.5
        findRoomButton = UIButton(frame:CGRect(x:buttonLeft,y:buttonTop, width:slideButtonWidth, height:slideButtonHeight))
        findRoomButton.backgroundColor = VillimUtils.themeColor
        findRoomButton.setTitle(NSLocalizedString("find_house", comment: ""), for: .normal)
        findRoomButton.setTitleColor(UIColor.white, for: .normal)
        findRoomButton.setTitleColor(UIColor.gray, for: .highlighted)
        findRoomButton.layer.cornerRadius  = 30
        findRoomButton.layer.masksToBounds = true
        findRoomButton.addTarget(self, action:#selector(self.showDiscoverTab), for: .touchUpInside)
        self.view.addSubview(findRoomButton)
        
        /* Room Info */
        houseImage.image = #imageLiteral(resourceName: "img_default")
        houseNameLabel.text = NSLocalizedString("no_rented_house", comment: "")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
