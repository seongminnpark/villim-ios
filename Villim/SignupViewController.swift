//
//  SignupViewController.swift
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

protocol SignupListener {
    func onSignup(success:Bool)
}

class SignupViewController: UIViewController, UITextFieldDelegate {

    let tosFontSize      : CGFloat = 12
    
    var signupListener   : SignupListener!
    
    var titleMain        : UILabel!
    var lastnameField    : CustomTextField!
    var firstnameField   : CustomTextField!
    var emailField       : CustomTextField!
    var passwordField    : CustomTextField!

    var nextButton       : UIButton!
    
    var tosContainer     : UIStackView!
    var tosMiddle        : UIButton!
    var tosLeft          : UILabel!
    var tosRight         : UILabel!
    
    var errorMessage     : UILabel!
    var loadingIndicator : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("signup", comment: "")
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        /* Title */
        titleMain = UILabel()
        titleMain.font = UIFont(name: "NotoSansCJKkr-Medium", size: 25)
        titleMain.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        titleMain.text = NSLocalizedString("signup_title", comment: "")
        self.view.addSubview(titleMain)
        
        /* Last name field */
        lastnameField = CustomTextField()
        lastnameField.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        lastnameField.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        lastnameField.placeholder = NSLocalizedString("last_name", comment: "")
        lastnameField.returnKeyType = .next
        lastnameField.autocapitalizationType = .none
        lastnameField.clearButtonMode = .whileEditing
        lastnameField.delegate = self
        self.view.addSubview(lastnameField)
        
        lastnameField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_view_profile"))
        lastnameField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        lastnameField.leftViewMode = .always
        
        /* First name field */
        firstnameField = CustomTextField()
        firstnameField.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        firstnameField.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        firstnameField.placeholder = NSLocalizedString("first_name", comment: "")
        firstnameField.autocapitalizationType = .none
        firstnameField.returnKeyType = .next
        firstnameField.clearButtonMode = .whileEditing
        firstnameField.delegate = self
        self.view.addSubview(firstnameField)
        
        firstnameField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_view_profile"))
        firstnameField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        firstnameField.leftViewMode = .always
        
        /* Email field */
        emailField = CustomTextField()
        emailField.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        emailField.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
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
        
        /* Password field */
        passwordField = CustomTextField()
        passwordField.font =  UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        passwordField.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        passwordField.placeholder = NSLocalizedString("password", comment: "")
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        passwordField.returnKeyType = .done
        passwordField.clearButtonMode = .whileEditing
        passwordField.delegate = self
        self.view.addSubview(passwordField)
        
        passwordField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_lock"))
        passwordField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        passwordField.leftViewMode = .always

        /* Next button */
        nextButton = UIButton()
        nextButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        nextButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
        nextButton.adjustsImageWhenHighlighted = true
        nextButton.titleLabel?.font = VillimValues.bottomButtonFont
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(VillimValues.whiteHighlightedColor, for: .highlighted)
        nextButton.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        nextButton.addTarget(self, action: #selector(self.verifyInput), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        /* Terms of Service button */
        tosContainer = UIStackView()
        tosContainer.axis = UILayoutConstraintAxis.horizontal
        tosContainer.distribution = UIStackViewDistribution.fill
        tosContainer.alignment = UIStackViewAlignment.center
        self.view.addSubview(tosContainer)
        
        tosLeft = UILabel()
        tosLeft.font =  UIFont(name: "NotoSansCJKkr-Regular", size: 11)
        tosLeft.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        tosLeft.text = NSLocalizedString("tos_left", comment: "")
        tosLeft.font = tosLeft.font.withSize(tosFontSize)
        tosContainer.addArrangedSubview(tosLeft)
        
        tosMiddle = UIButton()
        tosMiddle.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 11)
        tosMiddle.setTitleColor(VillimValues.themeColor, for: .normal)
        tosMiddle.setTitleColor(VillimValues.themeColorHighlighted, for: .highlighted)
        tosMiddle.setTitle(NSLocalizedString("tos_middle", comment: ""), for: .normal)
        tosMiddle.addTarget(self, action:#selector(self.launchTOSActivity), for: .touchUpInside)
        tosContainer.addArrangedSubview(tosMiddle)
        
        tosRight = UILabel()
        tosRight.font =  UIFont(name: "NotoSansCJKkr-Regular", size: 11)
        tosRight.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        tosRight.text = NSLocalizedString("tos_right", comment: "")
        tosRight.font = tosRight.font.withSize(tosFontSize)
        tosContainer.addArrangedSubview(tosRight)
        
        /* Error message */
        errorMessage = UILabel()
        errorMessage.textAlignment = .center
        errorMessage.textColor = VillimValues.themeColor
        errorMessage.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        self.view.addSubview(errorMessage)
        
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
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Title */
        titleMain?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(topOffset + VillimValues.titleOffset)
        }
        
        /* Last name field */
        lastnameField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(titleMain.snp.bottom).offset(VillimValues.sideMargin)
            make.height.equalTo(CustomTextField.iconSize * 2)
        }
        
        /* First name field */
        firstnameField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(lastnameField.snp.bottom).offset(VillimValues.sideMargin)
            make.height.equalTo(CustomTextField.iconSize * 2)
        }
        
        /* Email field */
        emailField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(firstnameField.snp.bottom).offset(VillimValues.sideMargin)
            make.height.equalTo(CustomTextField.iconSize * 2)
        }
        
        /* Password field */
        passwordField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(emailField.snp.bottom).offset(VillimValues.sideMargin)
            make.height.equalTo(CustomTextField.iconSize * 2)
        }
        
        /* Next button */
        nextButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
        /* Terms of service */
        tosContainer?.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(passwordField.snp.bottom).offset(10)
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = CGFloat(1.0)
        
        /* Lastname form */
        lastnameField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        
        /* Firstname form */
        firstnameField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        
        /* Email form */
        emailField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        
        /* Password form */
        passwordField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
    }
    
    /* Text field listeners */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == lastnameField { // Switch focus to other text field
            firstnameField.becomeFirstResponder()
        } else if textField == firstnameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func verifyInput() {
        let allFieldsFilledOut : Bool =
            !(emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! &&
                !(passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
        let validInput : Bool = allFieldsFilledOut;
        if validInput {
            sendSignupRequest();
        } else {
            showErrorMessage(message: NSLocalizedString("empty_field", comment: ""))
        }
    }
    
    func launchTOSActivity() {
        let tosWebViewController = WebViewController()
        tosWebViewController.urlString = VillimKeys.TERMS_OF_SERVICE_URL
        self.navigationController?.pushViewController(tosWebViewController, animated: true)
    }
    
    @objc private func sendSignupRequest() {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_LASTNAME  : lastnameField.text!,
            VillimKeys.KEY_FIRSTNAME : firstnameField.text!,
            VillimKeys.KEY_EMAIL     : emailField.text!,
            VillimKeys.KEY_PASSWORD  : passwordField.text!
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.SIGNUP_URL)
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    let user : VillimUser = VillimUser.init(userInfo:responseData[VillimKeys.KEY_USER_INFO])
                    VillimSession.setLoggedIn(loggedIn: true)
                    VillimSession.updateUserSession(user: user)
                    self.signup()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
                self.signupListener.onSignup(success: false)
            }
            self.hideLoadingIndicator()
        }
    }

    func signup() {
        self.signupListener.onSignup(success: true)
        self.navigationController?.popViewController(animated: true)
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
