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
    var lastnameField    : UITextField!
    var firstnameField   : UITextField!
    var emailField       : UITextField!
    var passwordField    : UITextField!

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
        self.tabBarController?.title = NSLocalizedString("signup", comment: "")
        
        /* Title */
        titleMain = UILabel()
        titleMain.text = NSLocalizedString("login_title_main", comment: "")
        self.view.addSubview(titleMain)
        
        /* Last name field */
        lastnameField = UITextField()
        lastnameField.placeholder = NSLocalizedString("last_name", comment: "")
        lastnameField.textContentType = UITextContentType.emailAddress
        lastnameField.keyboardType = UIKeyboardType.emailAddress
        lastnameField.returnKeyType = .next
        lastnameField.autocapitalizationType = .none
        lastnameField.clearButtonMode = .whileEditing
        lastnameField.delegate = self
        self.view.addSubview(lastnameField)
        
        lastnameField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_view_profile"))
        lastnameField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        lastnameField.leftViewMode = .always
        
        /* First name field */
        firstnameField = UITextField()
        firstnameField.placeholder = NSLocalizedString("first_name", comment: "")
        firstnameField.isSecureTextEntry = true
        firstnameField.autocapitalizationType = .none
        firstnameField.returnKeyType = .done
        firstnameField.clearButtonMode = .whileEditing
        firstnameField.delegate = self
        self.view.addSubview(firstnameField)
        
        firstnameField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_view_profile"))
        firstnameField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        firstnameField.leftViewMode = .always
        
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
        
        /* Password field */
        passwordField = UITextField()
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
        nextButton.setBackgroundColor(color: VillimUtils.themeColor, forState: .normal)
        nextButton.setBackgroundColor(color: VillimUtils.themeColorHighlighted, forState: .highlighted)
        nextButton.adjustsImageWhenHighlighted = true
        nextButton.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .highlighted)
        nextButton.addTarget(self, action: #selector(self.verifyInput), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        /* Terms of Service button */
        tosContainer = UIStackView()
        tosContainer.axis = UILayoutConstraintAxis.horizontal
        tosContainer.distribution = UIStackViewDistribution.fill
        tosContainer.alignment = UIStackViewAlignment.center
        self.view.addSubview(tosContainer)
        
        tosLeft = UILabel()
        tosLeft.text = NSLocalizedString("tos_left", comment: "")
        tosLeft.font = tosLeft.font.withSize(tosFontSize)
        tosContainer.addArrangedSubview(tosLeft)
        
        tosMiddle = UIButton()
        tosMiddle.setTitle(NSLocalizedString("tos_middle", comment: ""), for: .normal)
        tosMiddle.setTitleColor(UIColor.gray, for: .normal)
        tosMiddle.setTitleColor(UIColor.black, for: .highlighted)
        tosMiddle.titleLabel?.font = tosMiddle.titleLabel?.font.withSize(tosFontSize)
        tosMiddle.addTarget(self, action:#selector(self.launchTOSActivity), for: .touchUpInside)
        tosContainer.addArrangedSubview(tosMiddle)
        
        tosRight = UILabel()
        tosRight.text = NSLocalizedString("tos_right", comment: "")
        tosRight.font = tosRight.font.withSize(tosFontSize)
        tosContainer.addArrangedSubview(tosRight)
        
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
        
        /* Last name field */
        lastnameField?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(titleMain.snp.bottom)
        }
        
        /* First name field */
        firstnameField?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(lastnameField.snp.bottom)
        }
        
        /* Email field */
        emailField?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(firstnameField.snp.bottom)
        }
        
        /* Password field */
        passwordField?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(emailField.snp.bottom)
        }
        
        /* Next button */
        nextButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
        /* */
        tosContainer?.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(30)
            make.top.equalTo(passwordField.snp.bottom)
        }
        
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
