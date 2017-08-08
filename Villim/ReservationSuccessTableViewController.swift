//
//  ReservationSuccessTableViewController
//  Villim
//
//  Created by Seongmin Park on 8/8/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ReservationSuccessTableViewController: UITableViewController {
    
    static let VISIT_CODE   = 0
    static let VISIT_GUEST  = 1
    static let VISIT_DATE   = 2
    static let VISIT_STATUS = 3
    
    var visit : VillimVisit!

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Initialize tableview */
        self.tableView = UITableView()
        self.tableView.backgroundColor = VillimValues.themeColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.isScrollEnabled = false
        self.tableView.separatorColor = UIColor.white
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
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell : HouseGenericTableViewCell = HouseGenericTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"reservation_success")
        
        cell.contentView.backgroundColor = VillimValues.themeColor
        
        cell.title.font      = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        cell.title.textColor = UIColor.white
        
        cell.button.isEnabled = false
        cell.button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        cell.button.setTitleColor(UIColor.white, for: .normal)
        
        var title : String
        var content : String
        
        switch indexPath.row {
        case ReservationSuccessTableViewController.VISIT_CODE:
            title = NSLocalizedString("visit_code", comment:"")
            content = String(self.visit.visitId)
            break
        case ReservationSuccessTableViewController.VISIT_GUEST:
            title = NSLocalizedString("visit_guest", comment:"")
            content = VillimSession.getFullName()
            break
        case ReservationSuccessTableViewController.VISIT_DATE:
            
            title = NSLocalizedString("visit_date", comment:"")
            
            let visitDate = self.visit.visitTime
            
            if visitDate != nil {
                
                content = String(format:NSLocalizedString("date_format_client_year_month_day", comment: ""),
                                 visitDate!.year, visitDate!.month, visitDate!.day)
            } else {
                
                content = NSLocalizedString("no_date_set", comment:"")
            
            }

            break
        case ReservationSuccessTableViewController.VISIT_STATUS:
            title = NSLocalizedString("visit_status", comment:"")
            content = String(VillimVisit.stringFromVisitStatus(status:self.visit.visitStatus))
            break
        default:
            title = NSLocalizedString("visit_code", comment:"")
            content = String(self.visit.visitId)
            break
        }
        
        cell.title.text = title
        cell.button.setTitle(content, for: .normal)
        

        cell.makeConstraints()
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

}
