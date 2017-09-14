//
//  VisitTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/25/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke
import SwiftDate

protocol VisitTableViewItemSelectedListener {
    func visitItemSelected(row:Int, section:Int, checkIn:DateInRegion, checkOut:DateInRegion)
}

class VisitTableViewController: UITableViewController {

    static let CONFIRMED = 0
    static let PENDING   = 1
    static let DONE      = 2
    
    var itemSelectedListener : VisitTableViewItemSelectedListener!
    var pendingVisits   : [VillimVisit] = []
    var confirmedVisits : [VillimVisit] = []
    var pendingHouses   : [VillimHouse] = []
    var confirmedHouses : [VillimHouse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.register(VisitListTableViewCell.self, forCellReuseIdentifier: "visit")
        self.tableView.backgroundColor = VillimValues.backgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.rowHeight = 150
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.contentInset =
            UIEdgeInsets(top: 0, left: 0, bottom: VillimValues.BOTTOM_BUTTON_HEIGHT, right: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case VisitTableViewController.CONFIRMED:
            return min(confirmedVisits.count, confirmedHouses.count)
        case VisitTableViewController.PENDING:
            return min(pendingVisits.count, pendingHouses.count)
        case VisitTableViewController.DONE:
            return 0
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : VisitListTableViewCell = VisitListTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"visit")
        
        var house : VillimHouse
        var visit : VillimVisit
        
        let checkIn = DateInRegion()
        var checkOut = DateInRegion()
        checkOut = checkOut + 3.day
        
        switch indexPath.section {
        case VisitTableViewController.CONFIRMED, VisitTableViewController.DONE:
            house = confirmedHouses[indexPath.row]
            visit = confirmedVisits[indexPath.row]
            cell.dateLabel.text = String(format:NSLocalizedString("checkin_checkout_format", comment: ""),
                                         checkIn.year, checkIn.month, checkIn.day,
                                         checkOut.year, checkOut.month, checkOut.day)
            break
        case VisitTableViewController.PENDING:
            house = pendingHouses[indexPath.row]
            visit = pendingVisits[indexPath.row]
            cell.dateLabel.text = NSLocalizedString("payment_pending", comment:"")
            break
        default:
            house = pendingHouses[indexPath.row]
            visit = pendingVisits[indexPath.row]
            cell.dateLabel.text = NSLocalizedString("payment_pending", comment:"")
            break
        }
        
        let url = URL(string: house.houseThumbnailUrl)
        if url != nil {
            Nuke.loadImage(with: url!, into: cell.houseThumbnail)
        }
        
        cell.houseName.text = house.houseName
        let (base, util) = VillimUtils.calculatePrice(checkIn: checkIn, checkOut: checkOut, rent: house.ratePerMonth)
        cell.housePrice.text = VillimUtils.getCurrencyString(price: base + util)
        cell.dateCount.text = String(format: NSLocalizedString("for_x_nights_format", comment: ""),
                                     (checkIn - checkOut).in(.day)!)
        
        cell.makeConstraints()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case VisitTableViewController.CONFIRMED:
            return NSLocalizedString("completed_reservations", comment: "")
        case VisitTableViewController.PENDING:
            return NSLocalizedString("reservations_in_progress", comment: "")
        case VisitTableViewController.DONE:
            return NSLocalizedString("past_reservations", comment: "")
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var checkIn  = DateInRegion()
        var checkOut = DateInRegion()
        
        switch indexPath.section {
        case VisitTableViewController.CONFIRMED:
            let checkInDummy = DateInRegion()
            var checkOutDummy = DateInRegion()
            checkOutDummy = checkOutDummy + 3.day
            checkIn = checkInDummy
            checkOut = checkOutDummy
            break
        case VisitTableViewController.PENDING:
            break
        case VisitTableViewController.DONE:
            let checkInDummy = DateInRegion()
            var checkOutDummy = DateInRegion()
            checkOutDummy = checkOutDummy + 3.day
            checkIn = checkInDummy
            checkOut = checkOutDummy
            break
        default:
            break
        }

        
        itemSelectedListener.visitItemSelected(row:indexPath.row,
                                               section:indexPath.section,
                                               checkIn:checkIn,
                                               checkOut:checkOut)
    }
}
