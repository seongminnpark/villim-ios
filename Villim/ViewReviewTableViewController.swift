//
//  ViewReviewTableTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/2/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SwiftDate
import Nuke

class ViewReviewTableViewController: UITableViewController {

    var reviews : [VillimReview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.isScrollEnabled = true
        self.tableView.allowsSelection = false
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = VillimValues.backgroundColor
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
        return reviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reviewCell = ViewReviewTableViewCell()
        
        let review = reviews[indexPath.row]
        
        /* Load image */
        if review.reviewerProfilePicUrl == nil {
            reviewCell.reviewerImageView.image = #imageLiteral(resourceName: "img_default")
        } else {
            let url = URL(string: review.reviewerProfilePicUrl)
            if url != nil {
                Nuke.loadImage(with: url!, into: reviewCell.reviewerImageView)
            } else {
                reviewCell.reviewerImageView.image = #imageLiteral(resourceName: "img_default")
            }
        }
        
        reviewCell.reviewerName.text  = review.reviewerName
        reviewCell.reviewContent.text = review.reviewContent
        reviewCell.reviewDate.text    = String(format:NSLocalizedString("date_format_client_year_month", comment:""), review.reviewDate.year, review.reviewDate.month)
        
        return reviewCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140.0
        
    }

}
