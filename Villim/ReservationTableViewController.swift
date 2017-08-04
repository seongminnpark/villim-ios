//
//  ReservationTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SwiftDate

protocol ReservationTableViewDelegate {
    func launchViewController(viewController:UIViewController, animated:Bool)
    func onDateSet(checkIn:DateInRegion, checkOut:DateInRegion)
}

class ReservationTableViewController: UITableViewController, CalendarDelegate {
    
    static let HEADER              : Int! = 0
    static let DATES               : Int! = 1
    static let NUMBER_OF_NIGHTS    : Int! = 2
    static let PRICE               : Int! = 3
    static let CANCELLATION_POLICY : Int! = 4
    
    static let SIDE_MARGIN : CGFloat = 20.0
    
    var reservationDelegate : ReservationTableViewDelegate!
    
    var house    : VillimHouse!
    var dateSet  : Bool = false
    var checkIn  : DateInRegion!
    var checkOut : DateInRegion!

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
        self.tableView.bounces = false
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.contentInset =
            UIEdgeInsets(top: 0, left: 0, bottom: VillimValues.BOTTOM_BUTTON_HEIGHT, right: 0)

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
        case ReservationTableViewController.HEADER:
            return setUpHeaderCell()
            
        case ReservationTableViewController.DATES:
            return setUpDatesCell()
            
        case ReservationTableViewController.NUMBER_OF_NIGHTS:

            let daysString = dateSet ?
                String(format:NSLocalizedString("number_of_dates_format", comment: ""), (checkOut - checkIn).in(.day)!) :
                NSLocalizedString("not_selected", comment: "")
            
            return setupHouseGenericCell(row:row, title: NSLocalizedString("number_of_nights", comment: ""), content: daysString)
            
        case ReservationTableViewController.PRICE:
            return setupPriceCell()
            
        case ReservationTableViewController.CANCELLATION_POLICY:
            return setupHouseGenericCell(row:row, title: NSLocalizedString("cancellation_policy", comment: ""), content: house.cancellationPolicy)
            
        default:
            return setUpHeaderCell()
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        
        switch row {
        case ReservationTableViewController.HEADER:
            return 150.0
            
        case ReservationTableViewController.DATES:
            return 130.0
            
        case ReservationTableViewController.NUMBER_OF_NIGHTS:
            return 70.0
            
        case ReservationTableViewController.PRICE:
            return 140.0
            
        case ReservationTableViewController.CANCELLATION_POLICY:
            return 70.0
            
        default:
            return 70.0
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


    func setUpHeaderCell() -> ReservationHeaderTableViewCell {
        let cell : ReservationHeaderTableViewCell = ReservationHeaderTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"reservation_header")
        
        cell.houseName.text = house.houseName
        cell.houseAddr.text = house.addrFull
        
        let houseInfoTest = String(format: NSLocalizedString("house_info_format", comment: ""),
                                   house.numGuest, house.numBedroom, house.numBed, house.numBathroom)
        cell.houseInfo.text = houseInfoTest
        
        cell.makeConstraints()
        return cell
    }
    
    func setUpDatesCell() -> ReservationDatesTableViewCell {
        let cell : ReservationDatesTableViewCell = ReservationDatesTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"reservation_dates")
        
        let checkInText = dateSet ?
            String(format:NSLocalizedString("date_format_client_weekday", comment: ""),
                   checkIn.month, checkIn.day, VillimUtils.weekdayToString(weekday:checkIn.weekday)) :
            NSLocalizedString("select_checkin", comment: "")
        
        let checkOutText = dateSet ?
            String(format:NSLocalizedString("date_format_client_weekday", comment: ""),
                   checkOut.month, checkOut.day, VillimUtils.weekdayToString(weekday:checkOut.weekday)) :
            NSLocalizedString("select_checkout", comment: "")
        
        cell.checkInLabel.text = checkInText
        cell.checkOutLabel.text = checkOutText
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.launchCalendarViewController))
        cell.addGestureRecognizer(tapGestureRecognizer)
        
        cell.makeConstraints()
        return cell
    }
    
    
    func setupPriceCell() -> ReservationPriceTableViewCell {
        let cell : ReservationPriceTableViewCell = ReservationPriceTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"reservation_price")
        
        let notSelectedText = NSLocalizedString("not_selected", comment: "")
        
        if dateSet {
            let (base, util) = VillimUtils.calculatePrice(checkIn: self.checkIn, checkOut: self.checkOut, rent: house.ratePerMonth)
            
            cell.priceContent.text       = VillimUtils.getCurrencyString(price: base + util + house.cleaningFee)
            cell.basePriceContent.text   = VillimUtils.getCurrencyString(price: base)
            cell.utilityContent.text     = VillimUtils.getCurrencyString(price: util)

        } else {            
            cell.priceContent.text       = notSelectedText
            cell.basePriceContent.text   = notSelectedText
            cell.utilityContent.text     = notSelectedText
        }

        cell.cleaningFeeContent.text = VillimUtils.getCurrencyString(price: house.cleaningFee)
        
        cell.makeConstraints()
        return cell
    }
    
    func setupHouseGenericCell(row:Int, title:String, content:String) -> HouseGenericTableViewCell {
        let cell : HouseGenericTableViewCell = HouseGenericTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_generic")
        
        cell.title.text   = title
        cell.button.setTitle(content, for: .normal)
        
        cell.makeConstraints()
        return cell
    }
    
    func onDateSet(checkIn:DateInRegion, checkOut:DateInRegion) {
        self.dateSet = true
        self.checkIn = checkIn
        self.checkOut = checkOut
        
        reservationDelegate.onDateSet(checkIn:checkIn, checkOut:checkOut)

        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row:ReservationTableViewController.DATES, section:0),
                                  IndexPath(row:ReservationTableViewController.NUMBER_OF_NIGHTS, section:0),
                                  IndexPath(row:ReservationTableViewController.PRICE, section:0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func launchCalendarViewController() {
        let calendarViewController = CalendarViewController()
        calendarViewController.calendarDelegate = self
        calendarViewController.dateSet  = self.dateSet
        calendarViewController.checkIn  = self.checkIn
        calendarViewController.checkOut = self.checkOut
        reservationDelegate.launchViewController(viewController: calendarViewController, animated: true)
    }
    
}

