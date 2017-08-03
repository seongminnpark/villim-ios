//
//  ViewProfileTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke
import PhoneNumberKit

class ViewProfileTableViewController: UITableViewController {

    var inEditMode : Bool = false
    
    static let PROFILE_PICTURE = 0
    static let NAME            = 1
    static let EMAIL           = 2
    static let PHONE_NUMBER    = 3
    static let CITY            = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.isScrollEnabled = true
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
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
        case ViewProfileTableViewController.PROFILE_PICTURE:
            return setUpViewProfileImageCell()
            
        case ViewProfileTableViewController.NAME:
            return setUpViewProfileNameCell()
            
        case ViewProfileTableViewController.EMAIL:
            let title = NSLocalizedString("email", comment:"")
            return setUpViewProfileCell(title:title, content:VillimSession.getEmail())
            
        case ViewProfileTableViewController.PHONE_NUMBER:
            return setUpViewProfilePhoneNumberCell()
            
        case ViewProfileTableViewController.CITY:
            let title = NSLocalizedString("city_of_residence", comment:"")
            return setUpViewProfileCell(title:title, content:VillimSession.getCityOfResidence())
            
        default:
            let title = NSLocalizedString("name", comment:"")
            return setUpViewProfileCell(title:title, content:VillimSession.getFullName())
        }

    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        
        switch row {
        case ViewProfileTableViewController.PROFILE_PICTURE:
            return 250.0
            
        case ViewProfileTableViewController.NAME:
            return 100.0
            
        case ViewProfileTableViewController.EMAIL:
            return 100.0
            
        case ViewProfileTableViewController.PHONE_NUMBER:
            return 100.0
            
        case ViewProfileTableViewController.CITY:
            return 100.0
            
        default:
            return 100.0
        }
        
    }
    
    func setUpViewProfileImageCell() -> ViewProfileImageTableViewCell {
        let cell : ViewProfileImageTableViewCell = ViewProfileImageTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"profile_image")
        
        let profilePicUrl = VillimSession.getProfilePicUrl()
        
        if profilePicUrl == nil {
//            cell.profileImage.image = 
        } else {
            let url = URL(string: profilePicUrl)
            if url != nil {
                Nuke.loadImage(with: url!, into: cell.profileImage)
            } else {
//                cell.profileImage.image =
            }
        }
        
        return cell
    }
    
    func setUpViewProfileNameCell() -> ViewProfileNameTableViewCell {
        let cell : ViewProfileNameTableViewCell = ViewProfileNameTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"profile_name")
        
        cell.title.text = NSLocalizedString("name", comment:"")
        
        if self.inEditMode {
            cell.layoutEditMode()
            cell.firstNameField.text = VillimSession.getFirstName()
            cell.lastNameField.text = VillimSession.getLastName()
        } else {
            cell.layoutNonEditMode()
            cell.content.text = VillimSession.getFullName()
        }
        
        return cell
    }
    
    func setUpViewProfilePhoneNumberCell() -> ViewProfilePhoneNumberTableViewCell {
        let cell : ViewProfilePhoneNumberTableViewCell = ViewProfilePhoneNumberTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"phone_number")
        
        cell.title.text = NSLocalizedString("phone_number", comment:"")
        
        var content = ""
        do {
            let phoneNumberKit = PhoneNumberKit()
            let phoneNumber = try phoneNumberKit.parse(VillimSession.getPhoneNumber())
            content = phoneNumberKit.format(phoneNumber, toType: .national)
        }
        catch {
            
        }
        cell.content.text = content
        
        if self.inEditMode {
            cell.layoutEditMode()
        } else {
            cell.layoutNonEditMode()
        }
        
        return cell
    }
    
    func setUpViewProfileCell(title:String, content:String) -> ViewProfileTableViewCell {
        let cell : ViewProfileTableViewCell = ViewProfileTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"view_profile")
        
        cell.title.text   = title
        
        if self.inEditMode {
            cell.layoutEditMode()
            cell.contentField.text = content
        } else {
            cell.layoutNonEditMode()
            cell.content.text = content
        }
        
        return cell
    }

}
