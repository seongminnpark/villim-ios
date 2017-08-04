//
//  ViewProfileViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import Toaster
import NVActivityIndicatorView

class ViewProfileViewController: UIViewController, ViewProfileDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var initialLaunch : Bool = true
    
    var firstname   : String!
    var lastName    : String!
    var email       : String!
    var phoneNumber : String!
    var city        : String!
    
    var viewProfileTableViewController : ViewProfileTableViewController!
    var loadingIndicator   : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.title = NSLocalizedString("profile", comment: "")
        
        firstname   = VillimSession.getFirstName()
        lastName    = VillimSession.getLastName()
        email       = VillimSession.getEmail()
        phoneNumber = VillimSession.getPhoneNumber()
        city        = VillimSession.getCityOfResidence()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = VillimValues.backgroundColor
        self.tabBarController?.title = NSLocalizedString("profile", comment: "")

        /* Tableview controller */
        viewProfileTableViewController = ViewProfileTableViewController()
        viewProfileTableViewController.viewProfileDelegate = self
        viewProfileTableViewController.firstname = self.firstname
        viewProfileTableViewController.lastname = self.lastName
        viewProfileTableViewController.email = self.email
        viewProfileTableViewController.phoneNumber = self.phoneNumber
        viewProfileTableViewController.city = self.city
        self.view.addSubview(viewProfileTableViewController.view)
        
        /* Set up edit button */
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        /* Loading inidcator */
        let screenCenterX = UIScreen.main.bounds.width / 2
        let screenCenterY = UIScreen.main.bounds.height / 2
        let indicatorViewLeft = screenCenterX - VillimValues.loadingIndicatorSize / 2
        let indicatorViweRIght = screenCenterY - VillimValues.loadingIndicatorSize / 2
        let loadingIndicatorFrame = CGRect(x:indicatorViewLeft, y:indicatorViweRIght,
                                           width:VillimValues.loadingIndicatorSize, height: VillimValues.loadingIndicatorSize)
        loadingIndicator = NVActivityIndicatorView(
            frame: loadingIndicatorFrame,
            type: .orbit,
            color: VillimValues.themeColor)
        self.view.addSubview(loadingIndicator)

        makeConstraints()
        
        self.setEditing(false, animated: false)
        
        /* Dismiss keyboard on tap */
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
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

        if self.isEditing {
            self.editButtonItem.title = NSLocalizedString("done", comment:"")
            initialLaunch = false
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
        self.viewProfileTableViewController.updateProfileInfo()
        
        if !initialLaunch && !self.isEditing {
            sendUpdateProfileRequest()
        }
    }

    @objc private func sendUpdateProfileRequest() {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_FIRSTNAME          : self.firstname,
            VillimKeys.KEY_LASTNAME           : self.lastName,
            VillimKeys.KEY_EMAIL              : self.email,
            VillimKeys.KEY_PHONE_NUMBER       : self.phoneNumber,
            VillimKeys.KEY_CITY_OF_RESIDENCE  : self.city
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.UPDATE_PROFILE_URL)
        
        let image = self.viewProfileTableViewController.getProfilePic()
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        let responseData = JSON(data: response.data!)
                        if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                            let user : VillimUser = VillimUser.init(userInfo:responseData[VillimKeys.KEY_USER_INFO])
                            VillimSession.updateUserSession(user: user)
                        } else {
                            self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                        }
                    case .failure(let error):
                        self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
                        self.hideLoadingIndicator()
                    }
                }
                
            case .failure(let encodingError):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
                self.hideLoadingIndicator()
            }
        }
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
    
    func updateProfileInfo(firstname:String, lastname:String, email:String, phoneNumber:String, city:String) {
        self.firstname   = firstname
        self.lastName    = lastname
        self.email       = email
        self.phoneNumber = phoneNumber
        self.city        = city
    }
    
    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    private func showErrorMessage(message:String) {
        let toast = Toast(text: message, duration: Delay.long)
        
        ToastView.appearance().bottomOffsetPortrait = (tabBarController?.tabBar.frame.size.height)! + 30
        ToastView.appearance().bottomOffsetLandscape = (tabBarController?.tabBar.frame.size.height)! + 30
        ToastView.appearance().font = UIFont.systemFont(ofSize: 17.0)
        
        toast.show()
    }
    
    private func hideErrorMessage() {
        ToastCenter.default.cancelAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideErrorMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
