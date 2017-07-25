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

class VisitListViewController: ViewController {

    var visits : [VillimVisit] = []
    var houses : [VillimHouse] = []
    var visitTableViewController : VisitTableViewController!
    var loadingIndicator   : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        self.title = "방문 목록"
        self.tabBarItem.title = self.title
        
        /* Featured houses list */
        visitTableViewController = VisitTableViewController()
        self.view.addSubview(visitTableViewController.view)
        
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
        
        sendVisitListRequest()
        
    }
    
    func populateViews() {
        visitTableViewController.visits = self.visits
        visitTableViewController.tableView.reloadData()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Tableview */
        visitTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(topOffset)
            make.bottom.equalToSuperview()
        }
        
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
                    
                    self.visitTableViewController.visits = self.visits
                    self.visitTableViewController.houses = self.houses
                    self.visitTableViewController.tableView.reloadData()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
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
