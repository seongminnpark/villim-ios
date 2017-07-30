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

class DiscoverViewController: ViewController, DiscoverTableViewDelegate {
    
    var houses : [VillimHouse] = []
    
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
        
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        topOffset = navControllerHeight + statusBarHeight
        prevContentOffset = 0
        
        /* Search filter container */
        searchFilter = UIView()
        searchFilter.backgroundColor = VillimValues.searchFilterOpenColor
        self.view.addSubview(searchFilter)
        
        /* Location filter */
        locationFilterSet = false
        locationFilter = UIView()
        locationFilterIcon = UIImageView()
        locationFilterIcon.image = #imageLiteral(resourceName: "icon_marker")
        locationFilterLabel = UILabel()
        locationFilterLabel.text = NSLocalizedString("all_locations", comment: "")
        locationFilterClearButton = UIButton()
        locationFilterClearButton.setImage(#imageLiteral(resourceName: "icon_clear_white"), for: .normal)
//        locationFilterClearButton.isHidden = true
//        locationFilterClearButton.isEnabled = false
        locationFilter.addSubview(locationFilterIcon)
        locationFilter.addSubview(locationFilterLabel)
        locationFilter.addSubview(locationFilterClearButton)
        searchFilter.addSubview(locationFilter)
        
        /* Date filter */
        dateFilterSet = false
        dateFilter = UIView()
        dateFilterIcon = UIImageView()
        dateFilterIcon.image = #imageLiteral(resourceName: "icon_calendar")
        dateFilterLabel = UILabel()
        dateFilterLabel.text = NSLocalizedString("select_date", comment: "")
        dateFilterClearButton = UIButton()
        dateFilterClearButton.setImage(#imageLiteral(resourceName: "icon_clear_white"), for: .normal)
//        dateFilterClearButton.isHidden = true
//        dateFilterClearButton.isEnabled = false
        dateFilter.addSubview(dateFilterIcon)
        dateFilter.addSubview(dateFilterLabel)
        dateFilter.addSubview(dateFilterClearButton)
        searchFilter.addSubview(dateFilter)
        
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
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = VillimValues.dividerColor.cgColor
        border.frame = CGRect(x: 0, y: locationFilter.frame.size.height - width, width:  locationFilter.frame.size.width, height: locationFilter.frame.size.height)
        border.backgroundColor = UIColor.clear.cgColor
        border.borderWidth = width
//        locationFilter.layer.addSublayer(border)
//        locationFilter.layer.masksToBounds = true
//        dateFilter.layer.addSublayer(border)
//        dateFilter.layer.masksToBounds = true
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
        
//        /* Location filter */
//        locationFilter.snp.updateConstraints{ (make) -> Void in
//            make.top.equalToSuperview().offset(DiscoverViewController.filterOffset)
//            make.height.equalTo(DiscoverViewController.individualFilterHeight)
//        }
//        locationFilterIcon.snp.updateConstraints{ (make) -> Void in
//            make.height.equalToSuperview()
//        }
//        locationFilterLabel.snp.updateConstraints{ (make) -> Void in
//            make.height.equalToSuperview()
//        }
//        locationFilterClearButton.snp.updateConstraints{ (make) -> Void in
//            make.height.equalToSuperview()
//        }
//        
//        /* Date filter */
//        dateFilter.snp.updateConstraints{ (make) -> Void in
//            make.top.equalTo(locationFilter.snp.bottom).offset(DiscoverViewController.filterOffset)
//            make.height.equalTo(DiscoverViewController.individualFilterHeight)
//        }
//        dateFilterIcon.snp.updateConstraints{ (make) -> Void in
//            make.height.equalToSuperview()
//        }
//        dateFilterLabel.snp.updateConstraints{ (make) -> Void in
//            make.height.equalToSuperview()
//        }
//        dateFilterClearButton.snp.updateConstraints{ (make) -> Void in
//            make.height.equalToSuperview()
//        }
//
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
    
}
