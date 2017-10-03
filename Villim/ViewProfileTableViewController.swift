//
//  ViewProfileTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Nuke

protocol ViewProfileDelegate {
    func launchPhotoPicker()
    func launchAddPhoneViewController()
    func updateProfileInfo(firstname:String, lastname:String, email:String, phoneNumber:String, city:String)
}

class ViewProfileTableViewController: UITableViewController {

    var inEditMode : Bool = false
    
    static let PROFILE_PICTURE = 0
    static let NAME            = 1
    static let EMAIL           = 2
    static let PHONE_NUMBER    = 3
    static let CITY            = 4
    
    var firstname   : String!
    var lastname    : String!
    var email       : String!
    var phoneNumber : String!
    var city        : String!
    
    var viewProfileDelegate  : ViewProfileDelegate!
    var tapGestureRecognizer : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pickPhoto))
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.isScrollEnabled = true
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = VillimValues.backgroundColor
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
            return setUpViewProfileCell(title:title, content:self.email)
            
        case ViewProfileTableViewController.PHONE_NUMBER:
            return setUpViewProfilePhoneNumberCell()
            
        case ViewProfileTableViewController.CITY:
            let title = NSLocalizedString("city_of_residence", comment:"")
            return setUpViewProfileCell(title:title, content:self.city)
            
        default:
            let title = NSLocalizedString("name", comment:"")
            return setUpViewProfileCell(title:title, content:self.lastname + self.firstname)
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
        
        /* Load photo */
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
    
    func togglePhotoEditMode() {
        
        let cell = self.tableView.cellForRow(at:
                        IndexPath(row:ViewProfileTableViewController.PROFILE_PICTURE, section:0))
        if cell != nil {
            if self.inEditMode {
                cell?.addGestureRecognizer(tapGestureRecognizer)
            } else {
                cell?.removeGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    func setUpViewProfileNameCell() -> ViewProfileNameTableViewCell {
        let cell : ViewProfileNameTableViewCell = ViewProfileNameTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"profile_name")
        
        cell.title.text = NSLocalizedString("name", comment:"")
        
        if self.inEditMode {
            cell.layoutEditMode()
            cell.firstNameField.text = self.firstname
            cell.lastNameField.text = self.lastname
        } else {
            if cell.firstNameField != nil  && cell.lastNameField != nil {
                self.firstname = cell.firstNameField.text
                self.lastname = cell.lastNameField.text
            }
            cell.layoutNonEditMode()
            cell.content.text = self.lastname + self.firstname
        }
        
        return cell
    }
    
    func setUpViewProfilePhoneNumberCell() -> ViewProfilePhoneNumberTableViewCell {
        let cell : ViewProfilePhoneNumberTableViewCell = ViewProfilePhoneNumberTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"phone_number")
        
        cell.title.text = NSLocalizedString("phone_number", comment:"")
        
        if self.inEditMode {
            cell.layoutEditMode()
            cell.addButton.addTarget(self, action: #selector(self.launchAddPhoneViewController), for: .touchUpInside)
        } else {
            cell.layoutNonEditMode()
        }
        
        cell.content.text = VillimUtils.formatPhoneNumber(numberString: self.phoneNumber)
        
        return cell
    }
    
    func setUpViewProfileCell(title:String, content:String) -> ViewProfileTableViewCell {
        let cell : ViewProfileTableViewCell = ViewProfileTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"view_profile")
        
        cell.title.text   = title
        
        if self.inEditMode {
            cell.layoutEditMode()
            cell.contentField.text = content
        } else {
            if title == NSLocalizedString("city_of_residence", comment: "") {
                if cell.contentField != nil {
                    self.city = cell.contentField.text
                }
                cell.layoutNonEditMode()
                cell.content.text = self.city
            } else if title == NSLocalizedString("email", comment:"") {
                if cell.contentField != nil {
                   self.email = cell.contentField.text
                }
                cell.layoutNonEditMode()
                cell.content.text = self.email
            }
        }
        
        return cell
    }

    @objc public func pickPhoto() {
        viewProfileDelegate.launchPhotoPicker()
    }
    
    @objc public func launchAddPhoneViewController() {
        viewProfileDelegate.launchAddPhoneViewController()
    }

    func setProfileImage(image:UIImage) {
        let cell = self.tableView.cellForRow(at:
            IndexPath(row:ViewProfileTableViewController.PROFILE_PICTURE, section:0)) as! ViewProfileImageTableViewCell
        
        cell.profileImage.image = image
    }
    
    func updateProfileInfo() {
        viewProfileDelegate.updateProfileInfo(firstname: self.firstname, lastname: self.lastname, email: self.email, phoneNumber: self.phoneNumber, city: self.city)
    }
    
    func getProfilePic() -> UIImage? {
        let cell = self.tableView.cellForRow(at:
            IndexPath(row:ViewProfileTableViewController.PROFILE_PICTURE, section:0)) as! ViewProfileImageTableViewCell
        
        return cell.profileImage.image
    }
    
}
