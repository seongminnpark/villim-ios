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

class DiscoverViewController: ViewController {
    
    var houses : [VillimHouse] = []
    var discoverTableViewController : DiscoverTableViewController!
    var loadingIndicator   : NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        self.title = "숙소 찾기"
        self.tabBarItem.title = self.title
        
        /* Featured houses list */
        discoverTableViewController = DiscoverTableViewController()
        self.view.addSubview(discoverTableViewController.view)
        
        /* Loading inidcator */
        let screenCenterX = UIScreen.main.bounds.width / 2
        let screenCenterY = UIScreen.main.bounds.height / 2
        let indicatorViewLeft = screenCenterX - VillimUtils.loadingIndicatorSize / 2
        let indicatorViweRIght = screenCenterY - VillimUtils.loadingIndicatorSize / 2
        let loadingIndicatorFrame = CGRect(x:indicatorViewLeft, y:indicatorViweRIght,
                                           width:VillimUtils.loadingIndicatorSize, height: VillimUtils.loadingIndicatorSize)
        loadingIndicator = NVActivityIndicatorView(
            frame: loadingIndicatorFrame,
            type: .orbit,
            color: VillimUtils.themeColor)
        self.view.addSubview(loadingIndicator)
        
        populateViews()
        makeConstraints()
        
        sendFeaturedHousesRequest()
        
    }
    
    func populateViews() {
        discoverTableViewController.houses = houses
        discoverTableViewController.tableView.reloadData()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
    
        /* Tableview */
        discoverTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(topOffset)
            make.bottom.equalToSuperview()
        }
        
    }
    
    @objc private func sendFeaturedHousesRequest() {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_PREFERENCE_CURRENCY : VillimSession.getCurrencyPref(),
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.FEATURED_HOUSES_URL)
        
        Alamofire.request(url, method:.get, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    
                    self.houses = VillimHouse.getFeaturedHouseArray(jsonHouses: responseData[VillimKeys.KEY_HOUSES].arrayValue)
                    
                    self.discoverTableViewController.houses = self.houses
                    self.discoverTableViewController.tableView.reloadData()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                print(url)
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
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
    
}
