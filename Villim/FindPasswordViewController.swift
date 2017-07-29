//
//  FindPasswordViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/28/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class FindPasswordViewController: UIViewController, UITextFieldDelegate {

    var titleMain        : UILabel!
    var emailField       : UITextField!
    var instruction      : UILabel!
    
    var nextButton       : UIButton!
    
    var errorMessage     : UILabel!
    var loadingIndicator : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.title = NSLocalizedString("find_password", comment: "")
        
        /* Title */
        titleMain = UILabel()
        titleMain.text = NSLocalizedString("lost_password", comment: "")
        self.view.addSubview(titleMain)
        
        /* Email field */
        emailField = UITextField()
        emailField.placeholder = NSLocalizedString("email", comment: "")
        emailField.textContentType = UITextContentType.emailAddress
        emailField.keyboardType = UIKeyboardType.emailAddress
        emailField.returnKeyType = .next
        emailField.autocapitalizationType = .none
        emailField.clearButtonMode = .whileEditing
        emailField.delegate = self
        self.view.addSubview(emailField)
        
        emailField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_email"))
        emailField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        emailField.leftViewMode = .always
        
        /* Instruction Field */
        instruction = UILabel()
        instruction.text = NSLocalizedString("enter_email", comment: "")
        self.view.addSubview(instruction)
        
        /* Next button */
        nextButton = UIButton()
        nextButton.setBackgroundColor(color: VillimUtils.themeColor, forState: .normal)
        nextButton.setBackgroundColor(color: VillimUtils.themeColorHighlighted, forState: .highlighted)
        nextButton.adjustsImageWhenHighlighted = true
        nextButton.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(self.verifyInput), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        /* Error message */
        errorMessage = UILabel()
        self.view.addSubview(errorMessage)
        
        /* Loading inidcator */
        let screenCenterX = UIScreen.main.bounds.width / 2
        let screenCenterY = UIScreen.main.bounds.height / 2
        let indicatorViewLeft = screenCenterX - VillimUtils.loadingIndicatorSize / 2
        let indicatorViweRIght = screenCenterY - VillimUtils.loadingIndicatorSize / 2
        let loadingIndicatorFrame = CGRect(x:indicatorViewLeft, y:indicatorViweRIght,
                                           width:VillimUtils.loadingIndicatorSize, height: VillimUtils.loadingIndicatorSize)
        loadingIndicator = NVActivityIndicatorView(
            frame: loadingIndicatorFrame,
            type: .orbit,
            color: VillimUtils.themeColor)
        self.view.addSubview(loadingIndicator)
        
        makeConstraints()

    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Title */
        titleMain?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(topOffset)
        }
        
        /* Email field */
        emailField?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(titleMain.snp.bottom)
        }
        
        /* Instruction Field */
        instruction?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(emailField.snp.bottom)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(30)
            make.top.equalTo(instruction.snp.bottom)
        }
        
        /* Next button */
        nextButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
    }
    
    @objc private func verifyInput() {
        let allFieldsFilledOut : Bool =
            !(emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
        let validInput : Bool = allFieldsFilledOut;
        if validInput {
            sendFindPasswordRequest()
        } else {
            showErrorMessage(message: NSLocalizedString("empty_field", comment: ""))
        }
    }
    
    /* Text field listeners */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func sendFindPasswordRequest() {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_EMAIL    : emailField.text!] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.FIND_PASSWORD_URL)
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_POST_SUCCESS].boolValue {
                    self.launchFindPasswordSuccessViewController()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                print(response)
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
    }

    func launchFindPasswordSuccessViewController() {
        let findPasswordSuccessViewController = FindPasswordSuccessViewController()
        self.navigationController?.pushViewController(findPasswordSuccessViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    private func showErrorMessage(message:String) {
        errorMessage.isHidden = false
        errorMessage.text = message
    }
    
    private func hideErrorMessage() {
        errorMessage.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideErrorMessage()
    }

}
