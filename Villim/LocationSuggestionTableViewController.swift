//
//  LocationSuggestionTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/30/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

protocol LocationSuggestionSelectedListener {
    func locationSuggestionItemSelected(item:String)
}

class LocationSuggestionTableViewController: UITableViewController {

    public var itemSelectedListener : LocationSuggestionSelectedListener!
    public var locationSuggestions = [VillimLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.isScrollEnabled = false
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.separatorStyle = .none
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
        return locationSuggestions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let location = locationSuggestions[indexPath.row]
        
        let locationCell = LocationSuggestionTableViewCell()
        
        locationCell.locationName.text   = location.name
        locationCell.locationDetail.text = location.addrSummary
        
        locationCell.makeConstraints()
        
        return locationCell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)! as! LocationSuggestionTableViewCell
        let currentItem = currentCell.locationName.text
        itemSelectedListener.locationSuggestionItemSelected(item: currentItem!)
    }

}
