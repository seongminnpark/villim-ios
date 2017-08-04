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
import NVActivityIndicatorView
import Toaster

class VisitListViewController: ViewController, VisitTableViewItemSelectedListener {

    var topOffset : CGFloat = 0
    let houseImageSize       : CGFloat = 200.0
    let slideButtonWidth     : CGFloat = 300.0
    let slideButtonHeight    : CGFloat = 60.0
    
    var visits : [VillimVisit] = []
    var houses : [VillimHouse] = []
    
    var visitTableViewController : VisitTableViewController!
    
    var container            : UIView!
    var houseImage           : UIImageView!
    var houseNameLabel       : UILabel!
    var houseDateLabel       : UILabel!
    var findRoomButton       : UIButton!
    
    var loadingIndicator   : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        topOffset = navControllerHeight + statusBarHeight
        
        self.view.backgroundColor = VillimValues.backgroundColor
        self.title = "방문 목록"
        self.tabBarItem.title = self.title
        
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
        
    
        if VillimSession.getLoggedIn() {
            sendVisitListRequest()
        } else {
            setUpNovisitLayout()
        }
    }
    
    
    func setUpVisitListLayout() {
        /* Visit list */
        self.visitTableViewController = VisitTableViewController()
        self.visitTableViewController.itemSelectedListener = self
        self.visitTableViewController.visits = self.visits
        self.visitTableViewController.houses = self.houses
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
        
        showLoadingIndicator()
        
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
                    
                    let visitArray : [JSON] = responseData[VillimKeys.KEY_CONFIRMED_VISITS].arrayValue
                    
                    self.visits = VillimVisit.visitArrayFromJsonArray(jsonVisits: visitArray)
                    self.houses = VillimHouse.houseArrayFromJsonArray(jsonHouses: visitArray)
             
                    if self.visits.count > 0 {
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
            self.hideLoadingIndicator()
        }
    }
    
    func visitItemSelected(position: Int) {
        let visitDetailViewController = VisitDetailViewController()
        visitDetailViewController.visit = visits[position]
        visitDetailViewController.house = houses[position]
        self.navigationController?.pushViewController(visitDetailViewController, animated: true)
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        viewDidLoad()
//    }

    
}
