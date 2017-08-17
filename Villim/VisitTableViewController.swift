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
    func visitItemSelected(position:Int)
}

class VisitTableViewController: UITableViewController {

    var itemSelectedListener : VisitTableViewItemSelectedListener!
    var pendingVisits   : [VillimVisit] = []
    var confirmedVisits : [VillimVisit] = []
    var pendingHouses   : [VillimHouse] = []
    var confirmedHouses : [VillimHouse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.register(HouseTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = VillimValues.backgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.rowHeight = 150
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.showsVerticalScrollIndicator = false
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
        case 0:
            return confirmedVisits.count
        case 1:
            return pendingVisits.count
        case 2:
            return 0
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : VisitListTableViewCell = VisitListTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        
        var house : VillimHouse
        var visit : VillimVisit
        
        let checkIn = DateInRegion()
        var checkOut = DateInRegion()
        checkOut = checkOut + 3.day
        
        switch indexPath.section {
        case 0:
            house = confirmedHouses[indexPath.row]
            visit = confirmedVisits[indexPath.row]
            cell.dateLabel.text = String(format:NSLocalizedString("checkin_checkout_format", comment: ""),
                                         checkIn.year, checkIn.month, checkIn.day,
                                         checkOut.year, checkOut.month, checkOut.day)
            break
        case 1, 2:
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
        case 0:
            return NSLocalizedString("completed_reservations", comment: "")
        case 1:
            return NSLocalizedString("reservations_in_progress", comment: "")
        case 2:
            return NSLocalizedString("past_reservations", comment: "")
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemSelectedListener.visitItemSelected(position: indexPath.row)
    }
}
