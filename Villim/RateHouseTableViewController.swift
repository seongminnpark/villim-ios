//
//  RateHouseTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/29/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

protocol RatingSetListener {
    func onRatingSet(category:Int, value:Double)
    func getRating(category:Int) -> Double
}


class RateHouseTableViewController: UITableViewController {

    var listener : RatingSetListener!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.register(HouseTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = VillimValues.backgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
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
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        var categoryName : String
        
        switch row {
        case RateHouseViewController.RATING_CATEGORY_ACCURACY:
            categoryName = NSLocalizedString("accuracy", comment: "")
            break
        case RateHouseViewController.RATING_CATEGORY_LOCATION:
            categoryName = NSLocalizedString("location", comment: "")
            break
        case RateHouseViewController.RATING_CATEGORY_COMMUNICATION:
            categoryName = NSLocalizedString("communication", comment: "")
            break
        case RateHouseViewController.RATING_CATEGORY_CHECKIN:
            categoryName = NSLocalizedString("checkin", comment: "")
            break
        case RateHouseViewController.RATING_CATEGORY_CLEANLINESS:
            categoryName = NSLocalizedString("cleanliness", comment: "")
            break
        case RateHouseViewController.RATING_CATEGORY_VALUE:
            categoryName = NSLocalizedString("value", comment: "")
            break
        default:
            categoryName = NSLocalizedString("accuracy", comment: "")
            break
        }
        
        let rateCell = RateHouseTableViewCell()
        rateCell.tableViewController = self
        rateCell.category            = row
        rateCell.categoryName        = categoryName
        rateCell.rating              = listener.getRating(category: row)
        rateCell.ratingBar.rating    = listener.getRating(category: row)
        rateCell.categoryLabel.text  = categoryName
        
        return rateCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func setRating(category:Int, value:Double) {
        listener.onRatingSet(category: category, value: value)

    }


}
