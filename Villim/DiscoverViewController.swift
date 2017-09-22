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
import Material

class DiscoverViewController: ViewController, LocationFilterDelegate, CalendarDelegate {
    
    var filterOpen : Bool = false
    let CAROUSEL_HEIGHT : CGFloat! = 250.0
    let bottomOffset : CGFloat! = 30.0
    
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
    
    var menuButton : UIButton!
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
    
    var mapView  : GMSMapView!
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
        
        setUpNavigationBar()
            
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
        mapView.mapType = .normal        
//        do {
//            // Set the map style by passing the URL of the local file.
//            if let styleURL = Bundle.main.url(forResource: "styles", withExtension: "json") {
//                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
//            } else {
//                NSLog("Unable to find styles.json")
//            }
//        } catch {
//            NSLog("One or more of the map styles failed to load. \(error)")
//        }
        
        let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 14.0)
        mapView.camera = camera
        
        self.view.addSubview(mapView)
        
        /* Carousel */
        let carouselFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        carousel = ScalingCarouselView(withFrame: carouselFrame, andInset: 30)
        carousel.dataSource = self
        carousel.delegate = self
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
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        /* Add menu button */
        menuButton = UIButton()
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        
        /* Add navbar logo */
        let navBarLogoHeight = self.navControllerHeight - 20
        /* Original image is 375 by 140, hence the 2.68 */
        let navBarLogoWidth = 2.68*navBarLogoHeight
        navbarLogo = UIImageView()
        navbarLogo.contentMode = .scaleAspectFit
//        navbarLogo.frame = CGRect(x: 0, y: 0, width: navBarLogoWidth, height: navBarLogoHeight)
        navbarLogo.image = #imageLiteral(resourceName: "logo_resized").resize(toWidth: navBarLogoWidth)
    
        
        /* Set up right button items */
        navbarIcon = UIButton()
        navbarIcon.frame = CGRect(x: 0, y: 0, width: navbarIconSize, height: navbarIconSize)
        navbarIcon.setImage(#imageLiteral(resourceName: "icon_search"), for: .normal)
        navbarIcon.sizeToFit()
        navbarIcon.addTarget(self, action: #selector(self.openFilter), for: .touchUpInside)
        
        self.navigationItem.leftViews = [menuButton]
        self.navigationItem.centerViews = [navbarLogo]
        self.navigationItem.rightViews = [navbarIcon]
    }
    
    func handleMenuButton() {
        self.navigationDrawerController?.toggleLeftView()
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
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(searchFilter.snp.bottom)
            make.height.equalTo(UIScreen.main.bounds.height - self.topOffset)
        }
        
        /* CollectionView */
        carousel.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(mapView).offset(-bottomOffset)
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
        
//        let url = VillimUtils.buildURL(endpoint: VillimKeys.FEATURED_HOUSES_URL)
        let url = URL(string: "http://mockbin.org/bin/ec538a2c-cad8-4a7b-b30b-923fb55e655f?foo=bar&foo=baz")!

        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    
                    self.houses = VillimHouse.houseArrayFromJsonArray(jsonHouses: responseData[VillimKeys.KEY_HOUSES].arrayValue)

                    self.carousel.reloadData()
                    self.initializeMap()
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
                print(error)
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
    
    func discoverItemSelected(position: Int) {
        let houseDetailViewController = HouseDetailViewController()
        houseDetailViewController.displayBottomBar = true
        houseDetailViewController.house = houses[position]
        houseDetailViewController.dateSet = self.dateFilterSet
        houseDetailViewController.checkIn = self.checkIn
        houseDetailViewController.checkOut = self.checkOut
        houseDetailViewController.mapMarkerExact = false
//        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(houseDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return houses.count
    }
    
    func launchMapView() {
        let mapViewController = MapViewController()
        let index = carousel.indexPathsForVisibleItems.first?.row
        mapViewController.latitude  = index == nil ? 0.0 : houses[index!].latitude
        mapViewController.longitude = index == nil ? 0.0 : houses[index!].longitude
        mapViewController.mapMarkerExact = false
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func initializeMap() {
        // Create markers
//        for house in houses {
//            let marker = GMSMarker()
//            marker.tracksViewChanges = false
//            marker.position = CLLocationCoordinate2D(latitude: house.latitude, longitude: house.longitude)
//            let markerView = CustomMarkerView(frame:
//                CGRect(x:0, y:0, width: 100, height:50))
//            markerView.content = VillimUtils.getCurrencyString(price: house.ratePerMonth)
//            marker.iconView = markerView
//            marker.map = mapView
//            self.markers.append(marker)
//        }
        
        /* Delete this for loop */
        for _ in houses {
            let marker = GMSMarker()
            marker.tracksViewChanges = false
            let random = (Double(arc4random()) / Double(UInt32.max)) * 5 - 10
            let latitude = 37.5665 + (random  / 100)
            let longitude = 126.9790 + (random  / 100)
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let markerView = CustomMarkerView(frame:
                CGRect(x:0, y:0, width: 100, height:50))
            markerView.content = VillimUtils.getCurrencyString(price: 30405)
            marker.iconView = markerView
            marker.map = mapView
            self.markers.append(marker)
        }
        
        /* Adjust camera to first marker */
        var initialLatitude = 0.0
        var initialLongitude = 0.0
        
        if markers.count > 0 {
            let markerPoint = mapView.projection.point(for: markers[0].position)
            
            let carouselTop = mapView.frame.origin.y + mapView.bounds.height - CAROUSEL_HEIGHT
            let mapViewTop = mapView.frame.origin.y
            let cameraOffsetY = (carouselTop - mapViewTop) / 2.0
            let newCameraPoint = CGPoint(x:markerPoint.x, y: markerPoint.y + cameraOffsetY)
            
            let newCameraCoordinate = mapView.projection.coordinate(for: newCameraPoint)
            initialLatitude = newCameraCoordinate.latitude
            initialLongitude = newCameraCoordinate.longitude
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: initialLatitude, longitude: initialLongitude, zoom: 14.0)

        mapView.camera = camera
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showErrorMessage(message:String) {
        let toast = Toast(text: message, duration: Delay.long)
        
        ToastView.appearance().bottomOffsetPortrait = 30
        ToastView.appearance().bottomOffsetLandscape = 30
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

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : DiscoverCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "discover", for: indexPath) as! DiscoverCollectionViewCell
        
        let house = self.houses[indexPath.row]
        
        let url = URL(string: house.houseThumbnailUrl)
        if url != nil {
            Nuke.loadImage(with: url!, into: cell.houseThumbnail)
        }
        cell.toolbar.title = house.houseName
        cell.toolbar.detail = "서울시 종로구"
        cell.houseRating.rating = Double(house.houseRating)
        cell.monthlyRent.text = VillimUtils.getRentString(rent: house.ratePerMonth, month: true)
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: self.carousel.frame.size.width/2 + scrollView.contentOffset.x,
                                  y: self.carousel.frame.size.height/2 + scrollView.contentOffset.y)
        let index = carousel.indexPathForItem(at: centerPoint)?.row
        print(centerPoint)
        if index != nil {
            scrollToMarker(index:index!)
        }
        
    }
}

extension DiscoverViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //        launchMapView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let index = markers.index(of: marker)
        
        if index != nil {
            /* Bring selected marker forward */
            markers.map { $0.zIndex = 0 }
            markers[index!].zIndex = 1
            
            scrollToMarker(index:index!)
            
            /* Scroll to appropriate card */
            carousel.scrollToItem(at: IndexPath(item: index!, section: 0),
                                  at: .right,
                                  animated: true)
        }
        
        return true
    }
    
    func scrollToMarker(index:Int) {
        
        let marker = markers[index]
        let markerPoint = mapView.projection.point(for: marker.position)
        
        let carouselTop = mapView.frame.origin.y + mapView.bounds.height - CAROUSEL_HEIGHT - bottomOffset
        let mapViewTop = mapView.frame.origin.y
        let cameraOffsetY = (carouselTop - mapViewTop) / 2.0
        let newCameraPoint = CGPoint(x:markerPoint.x, y: markerPoint.y + cameraOffsetY)
        
        let newCameraCoordinate = mapView.projection.coordinate(for: newCameraPoint)
        
        let camera = GMSCameraPosition.camera(withLatitude: newCameraCoordinate.latitude, longitude: newCameraCoordinate.longitude, zoom: 14.0)
        mapView.animate(to: camera)
    }
    
}
