//
//  ReservationViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SwiftDate

class ReservationViewController: UIViewController, ReservationTableViewDelegate, LoginListener {

    var house    : VillimHouse!
    var dateSet  : Bool = false
    var checkIn  : DateInRegion!
    var checkOut : DateInRegion!
    
    var reservationTableViewController : ReservationTableViewController!
    
    var nextButton         : UIButton!
    var errorMessage       : UILabel!
    var loadingIndicator   : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = VillimValues.backgroundColor
        self.tabBarController?.title = NSLocalizedString("request_visit", comment: "")
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        /* Tableview controller */
        reservationTableViewController = ReservationTableViewController()
        reservationTableViewController.reservationDelegate = self
        reservationTableViewController.house = self.house
        reservationTableViewController.dateSet = self.dateSet
        reservationTableViewController.checkIn = self.checkIn
        reservationTableViewController.checkOut = self.checkOut
        self.view.addSubview(reservationTableViewController.view)
        
        /* Next button */
        nextButton = UIButton()
        nextButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        nextButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
        nextButton.adjustsImageWhenHighlighted = true
        nextButton.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(self.verifyInput), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        /* Error message */
        errorMessage = UILabel()
        self.view.addSubview(errorMessage)
        
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
        
        makeConstraints()

    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        
        /* TableView */
        reservationTableViewController?.tableView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(topOffset)
            make.bottom.equalToSuperview()
        }
        
        /* Next button */
        nextButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
        }
        
    }
    
    func verifyInput() {
        if VillimSession.getLoggedIn() {
            if self.dateSet {
                sendVisitRequest()
            } else {
                showErrorMessage(message: NSLocalizedString("must_select_date", comment: ""))
            }
        } else {
            launchLoginViewController()
        }
    }
    
    @objc private func sendVisitRequest() {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_HOUSE_ID : house.houseId,
            VillimKeys.KEY_CHECKIN  : VillimUtils.dateToString(date: self.checkIn),
            VillimKeys.KEY_CHECKOUT : VillimUtils.dateToString(date: self.checkOut)
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.RESERVE_URL)
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    let visit = VillimVisit(visitInfo:responseData[VillimKeys.KEY_VISIT_INFO])
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }

    func launchViewController(viewController:UIViewController, animated:Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func launchLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.loginListener = self
        self.navigationController?.pushViewController(loginViewController, animated: true)
        //        self.present(loginViewController, animated: true, completion: nil)
    }

    func onDateSet(checkIn:DateInRegion, checkOut:DateInRegion) {
        self.dateSet = true
        self.checkIn = checkIn
        self.checkOut = checkOut
    }
    
    func onLogin(success: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    private func showErrorMessage(message:String) {
        errorMessage.isHidden = false
        errorMessage.text = message
    }
    
    private func hideErrorMessage() {
        errorMessage.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideErrorMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
}
