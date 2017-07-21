//
//  DiscoverTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/21/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke

class DiscoverTableViewController: UITableViewController {

    var houses : [VillimHouse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
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
        return houses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let house = houses[indexPath.row]
        
        let cell : HouseTableViewCell = HouseTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        
        let url = URL(string: house.houseThumbnailUrl)
        Nuke.loadImage(with: url!, into: cell.houseThumbnail)
        cell.houseName.text = house.houseName
        cell.houseRating.text = house.houseName
        cell.houseReviewCount.text = house.houseName
        cell.houseRent.text = house.houseName

        return cell
    }

}
