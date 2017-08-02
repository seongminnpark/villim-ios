//
//  HouseDetailTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke

protocol HouseDetailScrollListener {
    func onScroll(contentOffset:CGPoint)
}

class HouseDetailTableViewController: UITableViewController {

    var houseDetailScrollListener   : HouseDetailScrollListener!
    var house                       : VillimHouse!
    var lastReviewContent           : String! = ""
    var lastReviewReviewer          : String! = ""
    var lastReviewProfilePictureUrl : String! = ""
    var lastReviewRating            : Float! = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.register(HouseTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
        self.tableView.bounces = false
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.contentInset =
            UIEdgeInsets(top: 5, left: 5, bottom: VillimValues.BOTTOM_BUTTON_HEIGHT, right: 5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Pre-load mapview.
        self.tableView(self.tableView, cellForRowAt: IndexPath(row: 7, section: 0))
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
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
    
        switch row {
        case 0:
            return setupHostInfoCell()
        case 1:
            return setupHouseHeaderCell()
        case 2:
            return setupHouseInfographicCell()
        case 3:
            return setupHouseDescriptionCell()
        case 4:
            return setupHouseGenericCell(title: NSLocalizedString("price_policy", comment: ""), content: NSLocalizedString("read", comment: ""))
        case 5:
            return setupHouseAmenitiesCell()
        case 6:
            return setupHouseReviewCell()
        case 7:
            return setupMapCell()
        case 8:
            return setupHouseGenericCell(title: NSLocalizedString("house_policy", comment: ""), content: NSLocalizedString("read", comment: ""))
        case 9:
            return setupHouseGenericCell(title: NSLocalizedString("cancellation_policy", comment: ""), content: NSLocalizedString("strict", comment: ""))
        default:
            return setupHostInfoCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        
        switch row {
        case 0:
            return 100.0
        case 1:
            return 120.0
        case 2:
            return 100.0
        case 3:
            return 100.0
        case 4:
            return 70.0
        case 5:
            return 100.0
        case 6:
            return 150.0
        case 7:
            return 200.0
        case 8:
            return 70.0
        case 9:
            return 70.0
        default:
            return 150.0
        }

    }
    
    func setupHostInfoCell() -> HostInfoTableViewCell {
        let cell : HostInfoTableViewCell = HostInfoTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"host_info")
        
        let url = URL(string: house.hostProfilePicUrl)
        
        if url == nil {
            cell.hostImage.image = #imageLiteral(resourceName: "img_default")
        } else {
            Nuke.loadImage(with: url!, into: cell.hostImage)
        }
        
        cell.hostName.text        = house.hostName
        cell.hostRating.rating    = Double(house.hostRating)
        cell.hostReviewCount.text = String(format: NSLocalizedString("review_count_format", comment: ""), house.hostReviewCount)
        
        cell.makeConstraints()
        return cell
    }
    
    func setupHouseHeaderCell() -> HouseHeaderTableViewCell {
        let cell : HouseHeaderTableViewCell = HouseHeaderTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_header")

        cell.houseName.text    = house.houseName
        cell.houseAddress.text = house.addrFull
        
        cell.makeConstraints()
        return cell
    }
    
    func setupHouseInfographicCell() -> HouseInfographicTableViewCell {
        let cell : HouseInfographicTableViewCell = HouseInfographicTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_infographic")

        cell.guestCountLabel.text    = String(format: NSLocalizedString("guest_count_format", comment: ""), house.numGuest)
        cell.roomCountLabel.text     = String(format: NSLocalizedString("room_count_format", comment: ""), house.numBedroom)
        cell.bedCountLabel.text      = String(format: NSLocalizedString("bed_count_format", comment: ""), house.numBed)
        cell.bathroomCountLabel.text = String(format: NSLocalizedString("bathroom_count_format", comment: ""), house.numBathroom)
        
        cell.makeConstraints()
        return cell
    }
    
    func setupHouseDescriptionCell() -> HouseDescriptionTableViewCell {
        let cell : HouseDescriptionTableViewCell = HouseDescriptionTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_description")
        
        cell.houseDescription.text = house.description
        
        cell.makeConstraints()
        return cell
    }
    
    func setupHouseGenericCell(title:String, content:String) -> HouseGenericTableViewCell {
        let cell : HouseGenericTableViewCell = HouseGenericTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_generic")

        cell.title.text   = title
        cell.content.setTitle(content, for: .normal)
        
        cell.makeConstraints()
        return cell
    }
    
    func setupHouseAmenitiesCell() -> HouseAmenitiesTableViewCell {
        let cell : HouseAmenitiesTableViewCell = HouseAmenitiesTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"hosue_amenities")

        cell.title.text = NSLocalizedString("amenity", comment: "")
        cell.amenities = house.amenityIds
        
        cell.populateViews()
        cell.makeConstraints()
        return cell
    }
    
    func setupHouseReviewCell() -> HouseReviewTableViewCell {
        let cell : HouseReviewTableViewCell = HouseReviewTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_review")

        cell.title.text = NSLocalizedString("review", comment: "")
        print(lastReviewRating == nil)
        cell.houseReviewCount            = self.house.houseReviewCount
        cell.houseReviewRating           = self.house.houseRating
        cell.lastReviewRating            = self.lastReviewRating
        cell.lastReviewContent           = self.lastReviewContent
        cell.lastReviewReviewer          = self.lastReviewReviewer
        cell.lastReviewProfilePictureUrl = self.lastReviewProfilePictureUrl
        
        cell.populateViews()
        cell.makeConstraints()
        return cell
    }
    
    func setupMapCell() -> HouseMapTableViewCell {
        let cell : HouseMapTableViewCell = HouseMapTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_map")
        
        cell.latitude = house.latitude
        cell.longitude = house.longitude
        
        cell.populateView()
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        houseDetailScrollListener.onScroll(contentOffset: scrollView.contentOffset)
    }
}
