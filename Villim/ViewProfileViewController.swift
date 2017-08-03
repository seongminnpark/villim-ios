//
//  ViewProfileViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class ViewProfileViewController: UIViewController, ViewProfileDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var viewProfileTableViewController : ViewProfileTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = VillimValues.backgroundColor
        self.tabBarController?.title = NSLocalizedString("profile", comment: "")

        /* Tableview controller */
        viewProfileTableViewController = ViewProfileTableViewController()
        viewProfileTableViewController.viewProfileDelegate = self
        self.view.addSubview(viewProfileTableViewController.view)
        
        /* Set up edit button */
        self.setEditing(false, animated: false)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Tableview */
        viewProfileTableViewController.tableView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(topOffset)
            make.bottom.equalToSuperview()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
       
        super.setEditing(editing,animated:animated)
        if (self.isEditing) {
            self.editButtonItem.title = NSLocalizedString("done", comment:"")
        } else {
            self.editButtonItem.title = NSLocalizedString("edit", comment:"")
        }
        
        self.viewProfileTableViewController.inEditMode = editing
        self.viewProfileTableViewController.togglePhotoEditMode()
        self.viewProfileTableViewController.tableView.beginUpdates()
        self.viewProfileTableViewController.tableView.reloadRows(at:
            [IndexPath(row:ViewProfileTableViewController.NAME,         section:0),
             IndexPath(row:ViewProfileTableViewController.EMAIL,        section:0),
             IndexPath(row:ViewProfileTableViewController.PHONE_NUMBER, section:0),
             IndexPath(row:ViewProfileTableViewController.CITY,         section:0)], with: .automatic)
        self.viewProfileTableViewController.tableView.endUpdates()
    }

    func launchPhotoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // use the image
        self.viewProfileTableViewController.setProfileImage(image: chosenImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
