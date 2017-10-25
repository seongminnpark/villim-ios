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
    
    var visitCancelDialog    : VillimDialog!

    var errorMessage         : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = VillimValues.backgroundColor
        self.title = "방문 정보"

//        self.extendedLayoutIncludesOpaqueBars = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem

        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        /* Text buttons */
        locationButton = UIButton()
        locationButton.setTitle(NSLocalizedString("show_location", comment: ""), for: .normal)
        locationButton.setTitleColor(VillimValues.inactiveButtonColor, for: .normal)
        locationButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        locationButton.addTarget(self, action: #selector(self.launchMapViewController), for: .touchUpInside)
        locationButton.isEnabled = false
        self.view.addSubview(locationButton)
        
        cancelButton = UIButton()
        cancelButton.setTitle(NSLocalizedString("cancel_visit", comment: ""), for: .normal)
        cancelButton.setTitleColor(VillimValues.inactiveButtonColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        cancelButton.addTarget(self, action: #selector(self.cancelVisit), for: .touchUpInside)
        cancelButton.isEnabled = false
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
        houseNameLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 17)
        houseNameLabel.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        
        houseDateLabel = UILabel()
        houseDateLabel.textAlignment = .center
        houseDateLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        houseDateLabel.textColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
        
        container.addSubview(houseImage)
        container.addSubview(houseNameLabel)
        container.addSubview(houseDateLabel)
        
        /* Find room button */
        let buttonLeft = UIScreen.main.bounds.width/2 - slideButtonWidth/2
        let buttonTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 2
        bookButton = UIButton(frame:CGRect(x:buttonLeft,y:buttonTop, width:slideButtonWidth, height:slideButtonHeight))
        bookButton.backgroundColor = VillimValues.themeColor
        bookButton.setTitle(NSLocalizedString("book", comment: ""), for: .normal)
        bookButton.setTitleColor(UIColor.white, for: .normal)
        bookButton.setTitleColor(VillimValues.whiteHighlightedColor, for: .highlighted)
        bookButton.layer.cornerRadius  = 30
        bookButton.layer.masksToBounds = true
        
        self.view.addSubview(bookButton)
        
        /* Error message */
        let errorTop = UIScreen.main.bounds.height - tabBarController!.tabBar.bounds.height - slideButtonHeight * 2 - 60
        errorMessage = UILabel(frame:CGRect(x:0, y:errorTop, width:UIScreen.main.bounds.width, height:50))
        errorMessage.textAlignment = .center
        errorMessage.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        errorMessage.textColor = VillimValues.themeColor
        self.view.addSubview(errorMessage)
        
        makeConstraints()
        
//        sendVisitInfoRequest()

    }

    @objc private func sendVisitInfoRequest() {
        
        VillimUtils.showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_VISIT_ID : self.visit.visitId,
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.VISIT_INFO_URL)
        
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                
                if responseData[VillimKeys.KEY_QUERY_SUCCESS].boolValue {
                    let visitInfo = responseData[VillimKeys.KEY_VISIT_INFO].exists() ? responseData[VillimKeys.KEY_VISIT_INFO] : nil
                    self.visit = VillimVisit(visitInfo: visitInfo)
                    
                    let houseInfo = responseData[VillimKeys.KEY_HOUSE_INFO].exists() ? responseData[VillimKeys.KEY_HOUSE_INFO] : nil
                    self.house = VillimHouse(houseInfo: houseInfo)
                    
                    self.locationButton.isEnabled = true
                    self.locationButton.setTitleColor(VillimValues.themeColor, for: .normal)
                    self.locationButton.setTitleColor(VillimValues.themeColorHighlighted, for: .highlighted)
                    
                    self.cancelButton.isEnabled = true
                    self.cancelButton.setTitleColor(VillimValues.themeColor, for: .normal)
                    self.cancelButton.setTitleColor(VillimValues.themeColorHighlighted, for: .highlighted)
                    
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
    

    func populateViews() {
        
        /* Room Info */
        if house.houseThumbnailUrl.isEmpty {
            houseImage.image = #imageLiteral(resourceName: "img_default")
        } else {
            let url = URL(string: house.houseThumbnailUrl)
            Nuke.loadImage(with: url!, into: houseImage)
        }
    
        if visit.visitTime != nil {
            houseDateLabel.text = String(format: NSLocalizedString("visit_date_format", comment: ""),
                                         visit.visitTime!.year, visit.visitTime!.month, visit.visitTime!.day,
                                         visit.visitTime!.hour, visit.visitTime!.minute)
        }

    }

    func makeConstraints() {
        
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        let sidePadding = (UIScreen.main.bounds.width - slideButtonWidth) / 4
        
        /* Text Buttons */
        locationButton?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(sidePadding)
            make.top.equalTo(topOffset + sidePadding)
        }
        
        cancelButton?.snp.makeConstraints { (make) -> Void in
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
    
    func launchMapViewController() {
        let mapViewController = MapViewController()
        mapViewController.latitude = house.latitude
        mapViewController.longitude = house.longitude
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func cancelVisit() {
        visitCancelDialog = VillimDialog()
        visitCancelDialog.title = NSLocalizedString("cancel_visit", comment: "")
        visitCancelDialog.label =
            String(format:NSLocalizedString("cancel_visit_confirm", comment: ""), VillimSession.getFullName())
        visitCancelDialog.onConfirm = { () -> Void in self.sendCancelVisitRequest() }
        self.tabBarController?.view.addSubview(visitCancelDialog)
    }
    
    func sendCancelVisitRequest() {
        VillimUtils.showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_VISIT_ID : self.visit.visitId,
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.CANCEL_VISIT_URL)
        
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                
                if responseData[VillimKeys.KEY_CANCEL_SUCCESS].boolValue {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
        }
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
        if visitCancelDialog != nil {
            visitCancelDialog.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
}
