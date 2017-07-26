//
//  HouseDetailViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Toaster


class HouseDetailViewController: UIViewController {
    
    var house : VillimHouse! = nil
    
    var houseImageView : UIImageView!
    
    var loadingIndicator   : NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        /* Remove title */
        
        /* Make navbar transparent */
        
        /* Make navbar transparent */
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        /* House ImageView */
        houseImageView = UIImageView()
        self.view.addSubview(houseImageView!)
        
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
        
        makeConstraints()
        
        sendHouseInfoRequest()
    }
    
    func makeConstraints() {
        /* House ImageView */
        houseImageView?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(200)
            make.top.equalTo(self.view)
        }
    }
    
    @objc private func sendHouseInfoRequest() {
        
        showLoadingIndicator()
        
        let parameters = [VillimKeys.KEY_PREFERENCE_CURRENCY : VillimSession.getCurrencyPref(),
                          VillimKeys.KEY_HOUSE_ID : house.houseId] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.HOUSE_INFO_URL)

        Alamofire.request(url, method:.get, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    print(responseData)
                    self.house = VillimHouse.init(houseInfo: responseData[VillimKeys.KEY_HOUSE_INFO])
                    
//                    self.discoverTableViewController.houses = self.houses
//                    self.discoverTableViewController.tableView.reloadData()
                    
                    self.populateView()
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }
    
    func populateView() {
        /* Add house image */
        let url = URL(string: house.houseThumbnailUrl)
        Nuke.loadImage(with: url!, into: self.houseImageView)
        
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
