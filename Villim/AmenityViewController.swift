//
//  AmenityViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/2/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class AmenityViewController: UIViewController {

    var amenities = [Int]()
    
    private var amenityTitle : UILabel!
    private var amenityTableViewController : AmenityTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = ""
        
        /* Add Title */
        amenityTitle = UILabel()
        amenityTitle.text = NSLocalizedString("amenity_title", comment: "")
        self.view.addSubview(amenityTitle)
        
        /* Populate tableview */
        amenityTableViewController = AmenityTableViewController()
        amenityTableViewController.amenities = self.amenities
        self.view.addSubview(amenityTableViewController.view)
        
        makeConstraints()

    }

    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Amenity title */
        amenityTitle?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(topOffset)
        }
        
        /* Tableview */
        amenityTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view)
            make.top.equalTo(amenityTitle.snp.bottom)
            make.bottom.equalTo(self.view)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
