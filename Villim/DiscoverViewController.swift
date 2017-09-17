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
import Toaster
import SwiftDate
import Nuke
import ScalingCarousel
import GoogleMaps

class DiscoverViewController: ViewController, LocationFilterDelegate, CalendarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, GMSMapViewDelegate {
    
    var filterOpen : Bool = false
    let CAROUSEL_HEIGHT : CGFloat! = 360.0
    
    var houses  : [VillimHouse] = []
    var markers : [GMSMarker] = []
    
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
    
    var mapView   : GMSMapView!
    var carousel : ScalingCarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = VillimValues.backgroundColor
        self.tabBarItem.title = NSLocalizedString("discover", comment: "")
        
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
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        /* Add navbar logo */
        navbarLogo = UIImageView()
        let navBarLogoHeight = navControllerHeight - 20
        /* Original image is 375 by 140, hence the 2.68 */
        navbarLogo.frame = CGRect(x: 10, y: statusBarHeight, width: 2.68*navBarLogoHeight, height: navBarLogoHeight)
        navbarLogo.image = #imageLiteral(resourceName: "logo_lowercase")
        
        let leftItem = UIBarButtonItem(customView: navbarLogo)
        let negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -6
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
        searchFilter.backgroundColor = UIColor.white
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
        locationFilterLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
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
        dateFilterLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        dateFilterLabel.text = NSLocalizedString("select_date", comment: "")
        dateFilterLabel.textColor = VillimValues.searchFilterContentColor
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
        
        /* Map */
        mapView = GMSMapView()
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        /* Carousel */
        let carouselFrame = CGRect(x: 0,
                                   y: UIScreen.main.bounds.height - CAROUSEL_HEIGHT -
                                      self.tabBarController!.tabBar.bounds.height,
                                   width: UIScreen.main.bounds.height,
                                   height: CAROUSEL_HEIGHT)
        
        carousel = ScalingCarouselView(withFrame: carouselFrame, andInset: 0)
        carousel.dataSource = self
        carousel.translatesAutoresizingMaskIntoConstraints = false
        carousel.backgroundColor = UIColor.clear
        
        // Register our custom cell for dequeueing
        carousel.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: "discover")
        self.view.addSubview(carousel)
        
        populateViews()
        makeConstraints()
        
        collapseFilter()
        
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
        let calendarViewController = CalendarViewController()
        calendarViewController.calendarDelegate = self
        calendarViewController.dateSet = self.dateFilterSet
        calendarViewController.checkIn = self.checkIn
        calendarViewController.checkOut = self.checkOut
        self.navigationController?.pushViewController(calendarViewController, animated: true)
    }
    
    func populateViews() {
//        discoverTableViewController.houses = self.houses
//        discoverTableViewController.tableView.reloadData()
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
        
        /* Map */
        mapView.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.tableMargin)
            make.right.equalToSuperview().offset(-VillimValues.tableMargin)
            make.top.equalTo(searchFilter.snp.bottom).offset(VillimValues.tableMargin)
            make.height.equalTo(UIScreen.main.bounds.height
                - CAROUSEL_HEIGHT
                - self.tabBarController!.tabBar.bounds.height)
        }
        
        /* CollectionView */
        carousel.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.tableMargin)
            make.right.equalToSuperview().offset(-VillimValues.tableMargin)
            make.top.equalTo(mapView.snp.bottom)
            make.height.equalTo(CAROUSEL_HEIGHT)
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
        
        VillimUtils.showLoadingIndicator()
        
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

                    self.carousel.reloadData()
                    self.updateMap()
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
        }
    }
    
    @objc private func sendSearchRequest() {
        
        VillimUtils.showLoadingIndicator()
        
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
                    
//                    self.discoverTableViewController.houses = self.houses
//                    self.discoverTableViewController.tableView.reloadData()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
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
        houseDetailViewController.displayBottomBar = true
        houseDetailViewController.house = houses[position]
        houseDetailViewController.dateSet = self.dateFilterSet
        houseDetailViewController.checkIn = self.checkIn
        houseDetailViewController.checkOut = self.checkOut
        houseDetailViewController.mapMarkerExact = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(houseDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return houses.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : DiscoverCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "discover", for: indexPath) as! DiscoverCollectionViewCell
        
        let house = self.houses[indexPath.row]
        
        let url = URL(string: house.houseThumbnailUrl)
        if url != nil {
            Nuke.loadImage(with: url!, into: cell.houseThumbnail)
        }
        cell.houseName.text = house.houseName
        cell.houseRating.rating = Double(house.houseRating)
        cell.monthlyRent.text = VillimUtils.getRentString(rent: house.ratePerMonth, month: true)
        cell.address.text = "서울시 종로구"
        cell.makeConstraints()
        return cell
        
    }
    
    func open() {
        filterOpen = true
        navbarIcon.setImage(#imageLiteral(resourceName: "up_caret_black"), for: .normal)
        navbarIcon.addTarget(self, action: #selector(self.collapseFilter), for: .touchUpInside)
    }
    
    func collapse() {
        filterOpen = false
        navbarIcon.setImage(#imageLiteral(resourceName: "icon_search"), for: .normal)
        navbarIcon.addTarget(self, action: #selector(self.openFilter), for: .touchUpInside)
    }
    
    func collapseFilter() {
        collapse()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchFilter?.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(0)
            }
            self.locationFilter?.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(0)
            }
            self.dateFilter?.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        })
       
    }
    
    func openFilter() {
        open()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchFilter?.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(self.searchFilterMaxHeight)
            }
            self.locationFilter?.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(self.individualFilterHeight)
            }
            self.dateFilter?.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(self.individualFilterHeight)
            }
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        launchMapView()
    }
    
    func launchMapView() {
        let mapViewController = MapViewController()
        let indexPath = carousel.indexPathsForVisibleItems.first.row
        mapViewController.latitude = 0.0
        mapViewController.longitude = 0.0
        mapViewController.mapMarkerExact = false
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func updateMap() {
        for house in houses {
            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(latitude: house.latitude, longitude: house.longitude)
            marker.position = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9790)
            marker.map = mapView
            self.markers.append(marker)
        }
        
        var initialLatitude = 0.0
        var initialLongitude = 0.0
        
        if markers.count > 0 {
            initialLatitude = markers[0].position.latitude
            initialLongitude = markers[0].position.longitude
        }
      
        let camera = GMSCameraPosition.camera(withLatitude: initialLatitude, longitude: initialLongitude, zoom: 17.0)
        mapView.camera = camera
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
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
}
