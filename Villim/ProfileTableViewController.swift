//
//  ProfileTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/11/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

protocol ProfileTableViewItemSelectedListener {
    func profileItemSelected(item:String)
}

class ProfileTableViewController: UITableViewController {
    
    public var itemSelectedListener : ProfileTableViewItemSelectedListener!
    public var profileTableViewItems : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.backgroundColor = VillimValues.backgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.isScrollEnabled = false
        self.tableView.separatorInset = UIEdgeInsets.zero
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
        return profileTableViewItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = VillimValues.backgroundColor
        cell.textLabel?.text = profileTableViewItems[indexPath.row]
        cell.textLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        cell.textLabel?.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        cell.imageView?.image = getCellImage(cellTitle: profileTableViewItems[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        let currentItem = currentCell.textLabel!.text
        itemSelectedListener.profileItemSelected(item: currentItem!)
    }
    
    func getCellImage(cellTitle: String) -> UIImage {
        switch cellTitle {
        case NSLocalizedString("login", comment: ""):
            return #imageLiteral(resourceName: "icon_login")
        case NSLocalizedString("faq", comment: ""):
            return #imageLiteral(resourceName: "icon_faq")
        case NSLocalizedString("settings", comment: ""):
            return #imageLiteral(resourceName: "icon_settings")
        case NSLocalizedString("privacy_policy", comment: ""):
            return #imageLiteral(resourceName: "icon_shield")
        case NSLocalizedString("edit_profile", comment: ""):
            return #imageLiteral(resourceName: "icon_view_profile")
        default:
            return #imageLiteral(resourceName: "icon_login")
        }
    }

}
