//
//  VisitDetailViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/28/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import SwiftyJSON
import Nuke
import Toaster
import NVActivityIndicatorView

class VisitDetailViewController: UIViewController {

    var house             : VillimHouse! = nil
    var visit             : VillimVisit! = nil
    
    let houseImageSize       : CGFloat = 200.0
    
    var houseId              : Int!    = 0
    var houseName            : String! = ""
    var visitDate            : String! = ""
    var houseThumbnailUrl    : String! = ""
    
    let slideButtonWidth     : CGFloat = 300.0
    let slideButtonHeight    : CGFloat = 60.0
    
    var locationButton       : UIButton!
    var cancelButton         : UIButton!
    var container            : UIView!
    var houseImage           : UIImageView!
    var houseNameLabel       : UILabel!
    var houseDateLabel       : UILabel!
    
    var bookButton           : UIButton!
    
    var loadingIndicator     : NVActivityIndicatorView!
    var errorMessage         : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "방문 정보"
        
        /* Text buttons */
        locationButton = UIButton()
        locationButton.setTitle(NSLocalizedString("show_location", comment: ""), for: .normal)
        locationButton.setTitleColor(UIColor.gray, for: .normal)
        locationButton.setTitleColor(UIColor.black, for: .highlighted)
        self.view.addSubview(locationButton)
        cancelButton = UIButton()
        cancelButton.setTitle(NSLocalizedString("cancel_visit", comment: ""), for: .normal)
        cancelButton.setTitleColor(UIColor.gray, for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .highlighted)
        self.view.addSubview(cancelButton)
        
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
        
        /* Find room button */
        let buttonLeft = UIScreen.main.bounds.width/2 - slideButtonWidth/2
        let buttonTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 1.5
        bookButton = UIButton(frame:CGRect(x:buttonLeft,y:buttonTop, width:slideButtonWidth, height:slideButtonHeight))
        bookButton.backgroundColor = VillimUtils.themeColor
        bookButton.setTitle(NSLocalizedString("book", comment: ""), for: .normal)
        bookButton.setTitleColor(UIColor.white, for: .normal)
        bookButton.setTitleColor(UIColor.gray, for: .highlighted)
        bookButton.layer.cornerRadius  = 30
        bookButton.layer.masksToBounds = true
        
        self.view.addSubview(bookButton)
        
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
        
        sendVisitInfoRequest()

    }

    @objc private func sendVisitInfoRequest() {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_VISIT_ID : VillimSession.getCurrencyPref(),
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.OPEN_DOORLOCK_URL)
        
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_QUERY_SUCCESS].boolValue {
                    let visitInfo = responseData[VillimKeys.KEY_VISIT_INFO].exists() ? responseData[VillimKeys.KEY_VISIT_INFO] : nil
                    self.visit = VillimVisit(visitInfo: visitInfo)
                    
                    let houseInfo = responseData[VillimKeys.KEY_HOUSE_INFO].exists() ? responseData[VillimKeys.KEY_HOUSE_INFO] : nil
                    self.house = VillimHouse(houseInfo: houseInfo)
                    
                    
                    self.populateViews()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func populateViews() {
        
        /* Room Info */
        if house.houseThumbnailUrl.isEmpty {
            houseImage.image = #imageLiteral(resourceName: "img_default")
        } else {
            let url = URL(string: house.houseThumbnailUrl)
            Nuke.loadImage(with: url!, into: houseImage)
        }
        houseNameLabel.text = visit.visitTime
    }

    func makeConstraints() {
        
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Text Buttons */
        locationButton?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(topOffset)
        }
        
        cancelButton?.snp.makeConstraints { (make) -> Void in
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
