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
import SwiftDate

class DiscoverViewController: ViewController, DiscoverTableViewDelegate, LocationFilterDelegate, CalendarDelegate, HouseDetailDelegate {
    
    var filterOpen : Bool = false
    
    var houses : [VillimHouse] = []
    
    var locationQuery : String = ""
    var checkIn  : DateInRegion! = nil
    var checkOut : DateInRegion! = nil
    
    var navControllerHeight : CGFloat!
    var statusBarHeight : CGFloat!
    var topOffset : CGFloat!
    var prevContentOffset : CGFloat!
    let searchFilterMaxHeight : CGFloat! = 150
    let individualFilterHeight : CGFloat! = 50
    var filterOffset : CGFloat!
    
    let filterIconSize : CGFloat! = 25.0
    let filterPadding  : CGFloat! = 25.0
    let navbarIconSize : CGFloat! = 25.0
    
    var navbarLogo : UIImageView!
    var navbarIcon : UIButton!

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
        
        self.view.backgroundColor = VillimValues.backgroundColor
        self.tabBarItem.title = "숙소 찾기"
        
        filterOffset = (searchFilterMaxHeight - individualFilterHeight*2) / 3.0
        
        checkIn = DateInRegion()
        checkOut = DateInRegion()
        
        /* Prevent overlap with navigation controller */
        navControllerHeight = self.navigationController!.navigationBar.frame.height
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        topOffset = navControllerHeight + statusBarHeight
        prevContentOffset = 0
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationItem.backBarButtonItem?.title = ""
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        /* Add navbar logo */
        navbarLogo = UIImageView()
        navbarLogo.frame = CGRect(x: 0, y: statusBarHeight, width: 4.2*navControllerHeight, height: navControllerHeight)
        navbarLogo.image = #imageLiteral(resourceName: "navbar_logo")
        
        let leftItem = UIBarButtonItem(customView: navbarLogo)
        let negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -16
        self.navigationItem.leftBarButtonItems = [negativeSpacer, leftItem]
        
        /* Set up right button items */
        navbarIcon = UIButton()
        navbarIcon.frame = CGRect(x: 0, y: 0, width: navbarIconSize, height: navbarIconSize)
        navbarIcon.setImage(#imageLiteral(resourceName: "icon_search"), for: .normal)
        navbarIcon.sizeToFit()
        navbarIcon.addTarget(self, action: #selector(self.openFilter), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: navbarIcon)
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        /* Search filter container */
        searchFilter = UIView()
        searchFilter.backgroundColor = VillimValues.searchFilterOpenColor
        self.view.addSubview(searchFilter)
        
        let clearIcon = UIImage(named: "icon_clear_white")!.withRenderingMode(.alwaysTemplate)
        
        /* Location filter */
        locationFilterSet = false
        locationFilter = UIView()
//        locationFilter.layer.borderColor = VillimValues.searchFilterContentColor.cgColor
//        locationFilter.layer.borderWidth = 2.0;
        locationFilter.layer.cornerRadius = individualFilterHeight / 2.0
        locationFilter.backgroundColor = UIColor.white
        locationFilterIcon = UIImageView()
        let markerIcon = UIImage(named: "icon_marker")!.withRenderingMode(.alwaysTemplate)
        locationFilterIcon.image = markerIcon
        locationFilterIcon.tintColor = UIColor.black
        locationFilterLabel = UILabel()
        locationFilterLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        locationFilterLabel.text = NSLocalizedString("all_locations", comment: "")
        locationFilterLabel.textColor = UIColor.black
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
//        dateFilter.layer.borderColor = VillimValues.searchFilterContentColor.cgColor
//        dateFilter.layer.borderWidth = 2.0;
        dateFilter.layer.cornerRadius = individualFilterHeight / 2.0
        dateFilter.backgroundColor = UIColor.white
        dateFilterIcon = UIImageView()
        let calendarIcon = UIImage(named: "icon_calendar")!.withRenderingMode(.alwaysTemplate)
        dateFilterIcon.image = calendarIcon
        dateFilterIcon.tintColor = UIColor.black
        dateFilterLabel = UILabel()
        dateFilterLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        dateFilterLabel.text = NSLocalizedString("select_date", comment: "")
        dateFilterLabel.textColor = UIColor.black
        dateFilterClearButton = UIButton()
        dateFilterClearButton.setImage(clearIcon, for: .normal)
        dateFilterClearButton.tintColor = VillimValues.searchFilterContentColor
        dateFilterClearButton.isHidden = true
        dateFilterClearButton.isEnabled = false
        dateFilterClearButton.addTarget(self, action: #selector(self.clearDateFilter), for: .touchUpInside)
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
        
        self.searchFilter?.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(0)
        }
        
        sendFeaturedHousesRequest()
        
    }
    
    func launchLocationFilterViewController(sender : UITapGestureRecognizer) {
        self.tabBarController?.tabBar.isHidden = true
        let locationFilterViewController = LocationFilterViewController()
        locationFilterViewController.locationDelegate = self
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        self.navigationController?.pushViewController(locationFilterViewController, animated: true)
    }
    
    func launchDateFilterViewController(sender : UITapGestureRecognizer) {
        self.tabBarController?.tabBar.isHidden = true
        let calendarViewController = CalendarViewController()
        calendarViewController.calendarDelegate = self
        calendarViewController.dateSet = self.dateFilterSet
        calendarViewController.checkIn = self.checkIn
        calendarViewController.checkOut = self.checkOut
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        self.navigationController?.pushViewController(calendarViewController, animated: true)
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
            make.height.equalTo(searchFilterMaxHeight)
        }
    
        /* Location filter */
        locationFilter.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(filterPadding)
            make.right.equalToSuperview().offset(-filterPadding)
            make.top.equalToSuperview().offset(filterOffset)
            make.height.equalTo(individualFilterHeight)
        }
        locationFilterIcon.snp.makeConstraints{ (make) -> Void in
            make.width.height.equalTo(filterIconSize)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(filterPadding)
        }
        locationFilterLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalTo(locationFilterIcon.snp.right).offset(filterPadding)
        }
        locationFilterClearButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(locationFilter.snp.height)
            make.right.equalToSuperview()
        }

        /* Date filter */
        dateFilter.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(filterPadding)
            make.right.equalToSuperview().offset(-filterPadding)
            make.top.equalTo(locationFilter.snp.bottom).offset(filterOffset)
            make.height.equalTo(individualFilterHeight)
        }
        dateFilterIcon.snp.makeConstraints{ (make) -> Void in
            make.width.height.equalTo(filterIconSize)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(filterPadding)
        }
        dateFilterLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalTo(dateFilterIcon.snp.right).offset(filterPadding)
        }
        dateFilterClearButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(dateFilter.snp.height)
            make.right.equalToSuperview()
        }
        
        /* Tableview */
        discoverTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.tableMargin)
            make.right.equalToSuperview().offset(-VillimValues.tableMargin)
            make.top.equalTo(searchFilter.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let width = CGFloat(1.0)
//        
//        let locationBorder = CALayer()
//        locationBorder.borderColor = VillimValues.searchFilterContentColor.cgColor
//        locationBorder.frame = CGRect(x: 0, y: locationFilter.frame.size.height - width, width:  locationFilter.frame.size.width, height: locationFilter.frame.size.height)
//        locationBorder.backgroundColor = UIColor.clear.cgColor
//        locationBorder.borderWidth = width
//        locationFilter.layer.addSublayer(locationBorder)
//        locationFilter.layer.masksToBounds = true
//        
//        let dateBorder = CALayer()
//        dateBorder.borderColor = VillimValues.searchFilterContentColor.cgColor
//        dateBorder.frame = CGRect(x: 0, y: dateFilter.frame.size.height - width, width:  dateFilter.frame.size.width, height: dateFilter.frame.size.height)
//        dateBorder.backgroundColor = UIColor.clear.cgColor
//        dateBorder.borderWidth = width
//        dateFilter.layer.addSublayer(dateBorder)
//        dateFilter.layer.masksToBounds = true
//    }
    
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
    
    /* Filter delegation methods */
    
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
        sendSearchRequest()
    }
    
    func onDateSet(checkIn:DateInRegion, checkOut:DateInRegion) {
        dateFilterSet = true
        self.checkIn = checkIn
        self.checkOut = checkOut
        let dateFormatString = NSLocalizedString("date_format_client", comment: "")
        let checkInString  = String(format:dateFormatString, checkIn.month, checkIn.day)
        let checkOutString = String(format:dateFormatString, checkOut.month, checkOut.day)
        dateFilterLabel.text =
            String(format:NSLocalizedString("date_filter_format", comment: ""), checkInString, checkOutString)
        dateFilterClearButton.isHidden = false
        dateFilterClearButton.isEnabled = true
        sendSearchRequest()
    }
    
    func clearDateFilter() {
        dateFilterSet = false
        dateFilterLabel.text = NSLocalizedString("select_date", comment: "")
        dateFilterClearButton.isHidden = true
        dateFilterClearButton.isEnabled = false
        sendSearchRequest()
    }

    func discoverItemSelected(position: Int) {
        let houseDetailViewController = HouseDetailViewController()
        houseDetailViewController.houseDetailDelegate = self
        houseDetailViewController.house = houses[position]
        houseDetailViewController.dateSet = self.dateFilterSet
        houseDetailViewController.checkIn = self.checkIn
        houseDetailViewController.checkOut = self.checkOut
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.pushViewController(houseDetailViewController, animated: true)
    }
    
    func onScroll(contentOffset:CGPoint) {
        let contentVector = contentOffset.y - prevContentOffset
        prevContentOffset = contentOffset.y
        var newHeight = searchFilter.bounds.height - contentVector

        if newHeight <= 0 {
            newHeight = 0
            filterOpen = false
            navbarLogo.image = #imageLiteral(resourceName: "navbar_logo")
            navbarIcon.setImage(#imageLiteral(resourceName: "icon_search"), for: .normal)
            navbarIcon.addTarget(self, action: #selector(self.openFilter), for: .touchUpInside)
        } else if newHeight > searchFilterMaxHeight {
            newHeight = searchFilterMaxHeight
            filterOpen = true
            navbarLogo.image = #imageLiteral(resourceName: "navbar_logo_open")
        } else {
            filterOpen = true
            navbarIcon.setImage(#imageLiteral(resourceName: "up_arrow"), for: .normal)
            navbarIcon.addTarget(self, action: #selector(self.collapseFilter), for: .touchUpInside)
        }
        self.navigationController!.navigationBar.barTintColor = calculateNavBarColor(offset: newHeight)
        searchFilter?.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(newHeight)
        }
    
    }
    
    func collapseFilter() {
        self.navigationController!.navigationBar.barTintColor = calculateNavBarColor(offset: 0)
        navbarLogo.image = #imageLiteral(resourceName: "navbar_logo")
        navbarIcon.setImage(#imageLiteral(resourceName: "icon_search"), for: .normal)
        navbarIcon.addTarget(self, action: #selector(self.openFilter), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchFilter?.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(0)
            }
            
            self.searchFilter.superview?.layoutIfNeeded()
        })
    }
    
    func openFilter() {
        self.navigationController!.navigationBar.barTintColor = calculateNavBarColor(offset: searchFilterMaxHeight)
        navbarLogo.image = #imageLiteral(resourceName: "navbar_logo_open")
        navbarIcon.setImage(#imageLiteral(resourceName: "up_arrow"), for: .normal)
        navbarIcon.addTarget(self, action: #selector(self.collapseFilter), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchFilter?.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(self.searchFilterMaxHeight)
            }
            
            self.searchFilter.superview?.layoutIfNeeded()
        })
    }

    func calculateNavBarColor(offset:CGFloat) -> UIColor {
        let openColorComponents = VillimValues.searchFilterOpenColor.cgColor.components
        let openR = openColorComponents?[0]
        let openG = openColorComponents?[1]
        let openB = openColorComponents?[2]
        let diff = searchFilterMaxHeight - offset
        let r = openR! + diff/searchFilterMaxHeight  * (1 - openR!)
        let g = openR! + diff/searchFilterMaxHeight  * (1 - openG!)
        let b = openR! + diff/searchFilterMaxHeight  * (1 - openB!)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    
    func onCollapse() {
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
    }
    
    func onOpen() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.navigationController!.navigationBar.barTintColor = calculateNavBarColor(offset: searchFilter.bounds.height)
    }
    
}
