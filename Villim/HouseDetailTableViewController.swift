//
//  HouseDetailTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke

protocol HouseDetailTableViewDelegate {
    func onScroll(contentOffset:CGPoint)
    func launchViewController(viewController:UIViewController, animated:Bool)
}

class HouseDetailTableViewController: UITableViewController, AmenityDelegate, ReviewDelegate {
    
    static let HOST                : Int! = 0
    static let HEADER              : Int! = 1
    static let INFOGRAPHIC         : Int! = 2
    static let DESCRIPTION         : Int! = 3
    static let PRICE_POLICY        : Int! = 4
    static let AMENITY             : Int! = 5
    static let REVIEW              : Int! = 6
    static let MAP                 : Int! = 7
    static let RULES               : Int! = 8
    static let CANCELLATION_POLICY : Int! = 9

    var houseDetailDelegate         : HouseDetailTableViewDelegate!
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
            UIEdgeInsets(top: 0, left: 0, bottom: VillimValues.BOTTOM_BUTTON_HEIGHT, right: 0)

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
        case HouseDetailTableViewController.HOST:
            return setupHostInfoCell()
        case HouseDetailTableViewController.HEADER:
            return setupHouseHeaderCell()
        case HouseDetailTableViewController.INFOGRAPHIC:
            return setupHouseInfographicCell()
        case HouseDetailTableViewController.DESCRIPTION:
            return setupHouseDescriptionCell()
        case HouseDetailTableViewController.PRICE_POLICY:
            return setupHouseGenericCell(row:row, title: NSLocalizedString("price_policy", comment: ""), content: NSLocalizedString("read", comment: ""))
        case HouseDetailTableViewController.AMENITY:
            return setupHouseAmenitiesCell()
        case HouseDetailTableViewController.REVIEW:
            return setupHouseReviewCell()
        case HouseDetailTableViewController.MAP:
            return setupMapCell()
        case HouseDetailTableViewController.RULES:
            return setupHouseGenericCell(row:row, title: NSLocalizedString("house_policy", comment: ""), content: NSLocalizedString("read", comment: ""))
        case HouseDetailTableViewController.CANCELLATION_POLICY:
            return setupHouseGenericCell(row:row, title: NSLocalizedString("cancellation_policy", comment: ""), content: NSLocalizedString("strict", comment: ""))
        default:
            return setupHostInfoCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        
        switch row {
        case HouseDetailTableViewController.HOST:
            return 100.0
        case HouseDetailTableViewController.HEADER:
            return 120.0
        case HouseDetailTableViewController.INFOGRAPHIC:
            return 100.0
        case HouseDetailTableViewController.DESCRIPTION:
            return 100.0
        case HouseDetailTableViewController.PRICE_POLICY:
            return 70.0
        case HouseDetailTableViewController.AMENITY:
            return 100.0
        case HouseDetailTableViewController.REVIEW:
            return 150.0
        case HouseDetailTableViewController.MAP:
            return 150.0
        case HouseDetailTableViewController.RULES:
            return 70.0
        case HouseDetailTableViewController.CANCELLATION_POLICY:
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
    
    func setupHouseGenericCell(row:Int, title:String, content:String) -> HouseGenericTableViewCell {
        let cell : HouseGenericTableViewCell = HouseGenericTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_generic")

        cell.title.text   = title
        cell.button.setTitle(content, for: .normal)
        
        switch row {
        case HouseDetailTableViewController.PRICE_POLICY:
            cell.button.addTarget(self, action: #selector(self.onPricePolicySeeMore), for: .touchUpInside)
            break
        default:
            break
        }
        
        cell.makeConstraints()
        return cell
    }
    
    func setupHouseAmenitiesCell() -> HouseAmenitiesTableViewCell {
        let cell : HouseAmenitiesTableViewCell = HouseAmenitiesTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"hosue_amenities")

        cell.title.text = NSLocalizedString("amenity", comment: "")
        cell.amenities = house.amenityIds
        cell.amenityDelegate = self
        
        cell.populateViews()
        cell.makeConstraints()
        return cell
    }
    
    func setupHouseReviewCell() -> HouseReviewTableViewCell {
        let cell : HouseReviewTableViewCell = HouseReviewTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_review")

        cell.reviewDelegate = self
        cell.title.text = NSLocalizedString("review", comment: "")
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
        houseDetailDelegate.onScroll(contentOffset: scrollView.contentOffset)
    }
    
    func onPricePolicySeeMore() {
        let pricePolicyViewController = PricePolicyViewController()
        pricePolicyViewController.cleaningFee = house.cleaningFee
        houseDetailDelegate.launchViewController(viewController: pricePolicyViewController, animated: true)
    }
    
    func onAmenitySeeMore() {
        let amenityViewController = AmenityViewController()
        amenityViewController.amenities = house.amenityIds
        houseDetailDelegate.launchViewController(viewController: amenityViewController, animated: true)
    }
    
    func onReviewSeeMore() {
        let viewReviewViewControlelr = ViewReviewViewController()
        viewReviewViewControlelr.houseId = house.houseId
        houseDetailDelegate.launchViewController(viewController: viewReviewViewControlelr, animated: true)
    }
    
}
