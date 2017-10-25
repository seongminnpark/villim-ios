//
//  VisitListViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/9/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster
import SwiftDate

class VisitListViewController: ViewController, VisitTableViewItemSelectedListener {

    var topOffset : CGFloat = 0
    let houseImageSize       : CGFloat = 200.0
    let slideButtonWidth     : CGFloat = 300.0
    let slideButtonHeight    : CGFloat = 60.0
    
    var pendingVisits   : [VillimVisit] = []
    var confirmedVisits : [VillimVisit] = []
    var pendingHouses   : [VillimHouse] = []
    var confirmedHouses : [VillimHouse] = []
    
    var visitTableViewController : VisitTableViewController!
    
    var menuButton : UIButton!
    
    var container            : UIView!
    var houseImage           : UIImageView!
    var houseNameLabel       : UILabel!
    var houseDateLabel       : UILabel!
    var findRoomButton       : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        topOffset = navControllerHeight + statusBarHeight
        
        setUpNavigationBar()
        
        self.view.backgroundColor = VillimValues.backgroundColor
        self.title = NSLocalizedString("visit_list", comment: "")
        self.tabBarItem.title = self.title
    }
    
    func setUpNavigationBar() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        /* Set title */
        self.navigationItem.titleLabel.text = NSLocalizedString("reservation_list", comment: "")
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        /* Add menu button */
        menuButton = UIButton()
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        
        self.navigationItem.leftViews = [menuButton]
    }
    
    func handleMenuButton() {
        self.navigationDrawerController?.toggleLeftView()
    }
    
    func setUpVisitListLayout() {
        
        if houseImage != nil {
            houseImage.removeFromSuperview()
        }
        
        if container != nil {
            container.removeFromSuperview()
        }
        
        if findRoomButton != nil {
            findRoomButton.removeFromSuperview()
        }
        
        /* Visit list */
        self.visitTableViewController = VisitTableViewController()
        self.visitTableViewController.itemSelectedListener = self
        self.visitTableViewController.pendingVisits = self.pendingVisits
        self.visitTableViewController.confirmedVisits = self.confirmedVisits
        self.visitTableViewController.pendingHouses = self.pendingHouses
        self.visitTableViewController.confirmedHouses = self.confirmedHouses
        self.visitTableViewController.tableView.reloadData()
        visitTableViewController.tableView.reloadData()
        self.view.addSubview(visitTableViewController.view)
        
        /* Tableview */
        visitTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.tableMargin)
            make.right.equalToSuperview().offset(-VillimValues.tableMargin)
            make.top.equalTo(topOffset)
            make.bottom.equalToSuperview()
        }
    }
    
    func setUpNovisitLayout() {
        
        if visitTableViewController != nil {
            visitTableViewController.tableView.removeFromSuperview()
            visitTableViewController = nil
        }
        
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
        let buttonTop = UIScreen.main.bounds.height - slideButtonHeight * 2
        findRoomButton = UIButton(frame:CGRect(x:buttonLeft,y:buttonTop, width:slideButtonWidth, height:slideButtonHeight))
        findRoomButton.backgroundColor = VillimValues.themeColor
        findRoomButton.setTitle(NSLocalizedString("find_house", comment: ""), for: .normal)
        findRoomButton.setTitleColor(UIColor.white, for: .normal)
        findRoomButton.setTitleColor(VillimValues.whiteHighlightedColor, for: .highlighted)
        findRoomButton.layer.cornerRadius  = 30
        findRoomButton.layer.masksToBounds = true
        findRoomButton.addTarget(self, action:#selector(self.showDiscoverTab), for: .touchUpInside)
        
        self.view.addSubview(findRoomButton)
        
        /* Room Info */
        houseImage.image = #imageLiteral(resourceName: "img_default")
        houseNameLabel.text = NSLocalizedString("no_visit", comment: "")
        
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
    
    func showDiscoverTab() {
        self.tabBarController?.selectedIndex = 0;
    }
    
    
    @objc private func sendVisitListRequest() {
        
        VillimUtils.showLoadingIndicator()
        
        //        let parameters = [
        //            VillimKeys.KEY_PREFERENCE_CURRENCY : VillimSession.getCurrencyPref(),
        //            ] as [String : Any]
        let parameters = [:] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.VISIT_LIST_URL)
        
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    
                    let confirmedVisitArray : [JSON] = responseData[VillimKeys.KEY_CONFIRMED_VISITS].arrayValue
                    let pendingVisitArray   : [JSON] = responseData[VillimKeys.KEY_PENDING_VISITS].arrayValue
                    
                    self.confirmedVisits = VillimVisit.visitArrayFromJsonArray(jsonVisits: confirmedVisitArray)
                    self.pendingVisits   = VillimVisit.visitArrayFromJsonArray(jsonVisits: confirmedVisitArray)
                    
                    self.confirmedHouses = VillimHouse.houseArrayFromJsonArray(jsonHouses: confirmedVisitArray)
                    self.pendingHouses   = VillimHouse.houseArrayFromJsonArray(jsonHouses: pendingVisitArray)
             
                    if self.confirmedVisits.count > 0 || self.pendingVisits.count > 0 {
                        self.setUpVisitListLayout()
                    } else {
                        self.setUpNovisitLayout()
                    }
                    
                } else {
                    self.setUpNovisitLayout()
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.setUpNovisitLayout()
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
        }
    }
    
    func visitItemSelected(row:Int, section:Int, checkIn:DateInRegion, checkOut:DateInRegion) {
        
        var house : VillimHouse
        var displayBottomBar : Bool
        var dateSet :  Bool
        var mapMarkerExact : Bool
        
        switch section {
        case VisitTableViewController.CONFIRMED:
            house = confirmedHouses[row]
            displayBottomBar = false
            dateSet = false
            mapMarkerExact = true
            break
        case VisitTableViewController.PENDING:
            house = pendingHouses[row]
            displayBottomBar = false
            dateSet = false
            mapMarkerExact = false
            break
        case VisitTableViewController.DONE:
            house = confirmedHouses[row]
            displayBottomBar = false
            dateSet = false
            mapMarkerExact = true
            break
        default:
            house = confirmedHouses[row]
            displayBottomBar = false
            dateSet = false
            mapMarkerExact = false
            break
        }
        
        let houseDetailViewController = HouseDetailViewController()
        houseDetailViewController.displayBottomBar = displayBottomBar
        houseDetailViewController.house = house
        houseDetailViewController.dateSet = dateSet
        houseDetailViewController.checkIn = checkIn
        houseDetailViewController.checkOut = checkOut
        houseDetailViewController.mapMarkerExact = mapMarkerExact
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(houseDetailViewController, animated: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        if VillimSession.getLoggedIn() {
//            sendVisitListRequest()
        } else {
            setUpNovisitLayout()
        }
    }

    
}
