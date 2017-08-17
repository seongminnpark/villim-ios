//
//  MyRoomTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/17/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke

protocol MyRoomDelegate {
    func myRoomItemSelected(item:Int)
}

class MyRoomTableViewController: UITableViewController {

    static let CHANGE_PASSCODE   = 0
    static let REQUEST_CLEANING  = 1
    static let REQUEST_CHAUFFUER = 2
    static let LOCAL_AMUSEMENTS  = 3
    static let LEAVE_REVIEW      = 4
    
    var houseName         : String! = ""
    var houseThumbnailUrl : String! = ""
    
    var myRoomDelegate : MyRoomDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.register(MyRoomTableViewCell.self, forCellReuseIdentifier: "my_room")
        self.tableView.backgroundColor = VillimValues.backgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.rowHeight = 80
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.contentInset =
            UIEdgeInsets(top: 0, left: 0, bottom: VillimValues.BOTTOM_BUTTON_HEIGHT, right: 0)

        /* Set up headerview */
        let headerView = MyRoomHeaderView()
        if houseThumbnailUrl.isEmpty {
            headerView.houseImage.image = #imageLiteral(resourceName: "img_default")
        } else {
            let url = URL(string:houseThumbnailUrl)
            Nuke.loadImage(with: url!, into: headerView.houseImage)
        }
        headerView.houseName.text = houseName
        self.tableView.tableHeaderView = headerView

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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyRoomTableViewCell = MyRoomTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"my_room")
        
        var itemTitle : String
        
        switch indexPath.row {
        case MyRoomTableViewController.CHANGE_PASSCODE:
            itemTitle = NSLocalizedString("change_doorlock_passcode", comment: "")
            break
        case MyRoomTableViewController.REQUEST_CLEANING:
            itemTitle = NSLocalizedString("request_cleaning_service", comment: "")
            break
        case MyRoomTableViewController.REQUEST_CHAUFFUER:
            itemTitle = NSLocalizedString("request_chauffuer_service", comment: "")
            break
        case MyRoomTableViewController.LOCAL_AMUSEMENTS:
            itemTitle = NSLocalizedString("local_amusements", comment: "")
            break
        case MyRoomTableViewController.LEAVE_REVIEW:
            itemTitle = NSLocalizedString("review_house", comment: "")
            break
        default:
            itemTitle = ""
            break
        }

        cell.title.text = itemTitle

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        myRoomDelegate.myRoomItemSelected(item: indexPath.row)
    }
}
