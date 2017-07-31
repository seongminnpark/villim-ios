//
//  DiscoverViewController.swift
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

class DiscoverViewController: ViewController, DiscoverTableViewDelegate, LocationFilterDelegate {
    
    var houses : [VillimHouse] = []
    
    var locationQuery : String = ""
    var checkIn  : Date? = nil
    var checkOut : Date? = nil
    
    var topOffset : CGFloat!
    var prevContentOffset : CGFloat!
    static let searchFilterMaxHeight : CGFloat! = 150
    static let individualFilterHeight : CGFloat! = 60
    static let filterOffset : CGFloat! = (searchFilterMaxHeight - individualFilterHeight*2) / 3.0
    
    var locationFilterSet : Bool = false
    var dateFilterSet : Bool = false
    
    var searchFilter : UIView!
    
    var locationFilter : UIView!
    var locationFilterIcon : UIImageView!
    var locationFilterLabel : UILabel!
    var locationFilterClearButton : UIButton!
    
    var dateFilter : UIView!
    var dateFilterIcon : UIImageView!
    var dateFilterLabel : UILabel!
    var dateFilterClearButton : UIButton!
    
    var discoverTableViewController : DiscoverTableViewController!
    var loadingIndicator   : NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        self.title = "숙소 찾기"
        self.tabBarItem.title = self.title
        
        checkIn = Date()
        checkOut = Date()
        
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        topOffset = navControllerHeight + statusBarHeight
        prevContentOffset = 0
        
        /* Search filter container */
        searchFilter = UIView()
        searchFilter.backgroundColor = VillimValues.searchFilterOpenColor
        self.view.addSubview(searchFilter)
        
        let clearIcon = UIImage(named: "icon_clear_white")!.withRenderingMode(.alwaysTemplate)
        
        /* Location filter */
        locationFilterSet = false
        locationFilter = UIView()
        locationFilterIcon = UIImageView()
        let markerIcon = UIImage(named: "icon_marker")!.withRenderingMode(.alwaysTemplate)
        locationFilterIcon.image = markerIcon
        locationFilterIcon.tintColor = VillimValues.searchFilterContentColor
        locationFilterLabel = UILabel()
        locationFilterLabel.text = NSLocalizedString("all_locations", comment: "")
        locationFilterLabel.textColor = VillimValues.searchFilterContentColor
        locationFilterClearButton = UIButton()
        locationFilterClearButton.setImage(clearIcon, for: .normal)
        locationFilterClearButton.tintColor = VillimValues.searchFilterContentColor
        locationFilterClearButton.isHidden = true
        locationFilterClearButton.isEnabled = false
        locationFilterClearButton.addTarget(self, action: #selector(self.clearLocationFilter), for: .touchUpInside)
        locationFilter.addSubview(locationFilterIcon)
        locationFilter.addSubview(locationFilterLabel)
        locationFilter.addSubview(locationFilterClearButton)
        searchFilter.addSubview(locationFilter)
        
        let locationGesture = UITapGestureRecognizer(target: self, action:  #selector (self.launchLocationFilterViewController(sender:)))
        self.locationFilter.addGestureRecognizer(locationGesture)
        
        /* Date filter */
        dateFilterSet = false
        dateFilter = UIView()
        dateFilterIcon = UIImageView()
        let calendarIcon = UIImage(named: "icon_calendar")!.withRenderingMode(.alwaysTemplate)
        dateFilterIcon.image = calendarIcon
        dateFilterIcon.tintColor = VillimValues.searchFilterContentColor
        dateFilterLabel = UILabel()
        dateFilterLabel.text = NSLocalizedString("select_date", comment: "")
        dateFilterLabel.textColor = VillimValues.searchFilterContentColor
        dateFilterClearButton = UIButton()
        dateFilterClearButton.setImage(clearIcon, for: .normal)
        dateFilterClearButton.tintColor = VillimValues.searchFilterContentColor
        dateFilterClearButton.isHidden = true
        dateFilterClearButton.isEnabled = false
        dateFilter.addSubview(dateFilterIcon)
        dateFilter.addSubview(dateFilterLabel)
        dateFilter.addSubview(dateFilterClearButton)
        searchFilter.addSubview(dateFilter)
    
        let dateGesture = UITapGestureRecognizer(target: self, action:  #selector (self.launchDateFilterViewController(sender:)))
        self.dateFilter.addGestureRecognizer(dateGesture)
        
        
        /* Featured houses list */
        discoverTableViewController = DiscoverTableViewController()
        discoverTableViewController.discoverDelegate = self
        self.view.addSubview(discoverTableViewController.view)
        
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
        
        populateViews()
        makeConstraints()
        
        sendFeaturedHousesRequest()
        
    }
    
    func launchLocationFilterViewController(sender : UITapGestureRecognizer) {
        self.tabBarController?.tabBar.isHidden = true
        let locationFilterViewController = LocationFilterViewController()
        locationFilterViewController.locationDelegate = self
        self.navigationController?.pushViewController(locationFilterViewController, animated: true)
    }
    
    func launchDateFilterViewController(sender : UITapGestureRecognizer) {
        self.tabBarController?.tabBar.isHidden = true
        let dateFilterViewController = DateFilterViewController()
        self.navigationController?.pushViewController(dateFilterViewController, animated: true)
    }
    
    func populateViews() {
        discoverTableViewController.houses = self.houses
        discoverTableViewController.tableView.reloadData()
    }
    
    func makeConstraints() {
        
        /* Search filter */
        searchFilter.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(topOffset)
            make.height.equalTo(DiscoverViewController.searchFilterMaxHeight)
        }
    
        /* Location filter */
        locationFilter.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(DiscoverViewController.filterOffset)
            make.height.equalTo(DiscoverViewController.individualFilterHeight)
        }
        locationFilterIcon.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(locationFilter.snp.height)
            make.left.equalToSuperview()
        }
        locationFilterLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalTo(locationFilterIcon.snp.right)
        }
        locationFilterClearButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(locationFilter.snp.height)
            make.right.equalToSuperview()
        }

        /* Date filter */
        dateFilter.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(locationFilter.snp.bottom).offset(DiscoverViewController.filterOffset)
            make.height.equalTo(DiscoverViewController.individualFilterHeight)
        }
        dateFilterIcon.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(dateFilter.snp.height)
            make.left.equalToSuperview()
        }
        dateFilterLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalTo(dateFilterIcon.snp.right)
        }
        dateFilterClearButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(dateFilter.snp.height)
            make.right.equalToSuperview()
        }
        
        /* Tableview */
        discoverTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(searchFilter.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = CGFloat(1.0)
        
        let locationBorder = CALayer()
        locationBorder.borderColor = VillimValues.searchFilterContentColor.cgColor
        locationBorder.frame = CGRect(x: 0, y: locationFilter.frame.size.height - width, width:  locationFilter.frame.size.width, height: locationFilter.frame.size.height)
        locationBorder.backgroundColor = UIColor.clear.cgColor
        locationBorder.borderWidth = width
        locationFilter.layer.addSublayer(locationBorder)
        locationFilter.layer.masksToBounds = true
        
        let dateBorder = CALayer()
        dateBorder.borderColor = VillimValues.searchFilterContentColor.cgColor
        dateBorder.frame = CGRect(x: 0, y: dateFilter.frame.size.height - width, width:  dateFilter.frame.size.width, height: dateFilter.frame.size.height)
        dateBorder.backgroundColor = UIColor.clear.cgColor
        dateBorder.borderWidth = width
        dateFilter.layer.addSublayer(dateBorder)
        dateFilter.layer.masksToBounds = true
    }
    
    @objc private func sendFeaturedHousesRequest() {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_PREFERENCE_CURRENCY : VillimSession.getCurrencyPref(),
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.FEATURED_HOUSES_URL)

        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    
                    self.houses = VillimHouse.houseArrayFromJsonArray(jsonHouses: responseData[VillimKeys.KEY_HOUSES].arrayValue)
                    
                    self.discoverTableViewController.houses = self.houses
                    self.discoverTableViewController.tableView.reloadData()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }
    
    @objc private func sendSearchRequest() {
        
        showLoadingIndicator()
        
        var parameters = [
            VillimKeys.KEY_PREFERENCE_CURRENCY : VillimSession.getCurrencyPref(),
            ] as [String : Any]
        
        if dateFilterSet {
            parameters[VillimKeys.KEY_CHECKIN]  = VillimUtils.dateToString(date: checkIn!)
            parameters[VillimKeys.KEY_CHECKOUT] =  VillimUtils.dateToString(date: checkOut!)
        }
        
        if locationFilterSet {
            parameters[VillimKeys.KEY_LOCATION] = locationQuery
        }
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.SEARCH_URL)
        
        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    
                    self.houses = VillimHouse.houseArrayFromJsonArray(jsonHouses: responseData[VillimKeys.KEY_HOUSES].arrayValue)
                    
                    self.discoverTableViewController.houses = self.houses
                    self.discoverTableViewController.tableView.reloadData()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }
    
    func onLocationFilterSet(location:String) {
        locationFilterSet = true
        locationFilterLabel.text = location
        locationFilterClearButton.isHidden = false
        locationFilterClearButton.isEnabled = true
        sendSearchRequest()
    }
    
    func clearLocationFilter() {
        locationFilterSet = false
        locationFilterLabel.text = NSLocalizedString("all_locations", comment: "")
        locationFilterClearButton.isHidden = true
        locationFilterClearButton.isEnabled = false
    }

    func discoverItemSelected(position: Int) {
        let houseDetailViewController = HouseDetailViewController()
        houseDetailViewController.house = houses[position]
        self.navigationController?.pushViewController(houseDetailViewController, animated: true)
    }
    
    func onScroll(contentOffset:CGPoint) {
        let contentVector = contentOffset.y - prevContentOffset
        prevContentOffset = contentOffset.y
        var newHeight = searchFilter.bounds.height - contentVector

        if newHeight <= 0 {
            newHeight = 0
        } else if newHeight > DiscoverViewController.searchFilterMaxHeight {
            newHeight = DiscoverViewController.searchFilterMaxHeight
        }
        
        searchFilter?.snp.updateConstraints { (make) -> Void in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
