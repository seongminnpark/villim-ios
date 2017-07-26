//
//  HouseDetailTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

protocol HouseDetailScrollListener {
    func onScroll(contentOffset:CGPoint)
}

class HouseDetailTableViewController: UITableViewController {

    var houseDetailScrollListener : HouseDetailScrollListener!
    var house : VillimHouse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.register(HouseTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.rowHeight = 150
//        self.tableView.bounces = false
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
        
        let cell : HouseTableViewCell = HouseTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        
        let url = URL(string: house.houseThumbnailUrl)
        cell.houseName.text = house.houseName
        cell.houseRating.text = house.houseName
        cell.houseReviewCount.text = house.houseName
        cell.houseRent.text = house.houseName
        cell.makeConstraints()
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        houseDetailScrollListener.onScroll(contentOffset: scrollView.contentOffset)
    }
}
