//
//  LoginViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/16/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

protocol LoginDelegate {
    func onLogin(success:Bool)
}

class LoginViewController: UIViewController, UITextFieldDelegate, SignupListener {
    
    var isRootView         : Bool = false
    
    var loginDelegate     : LoginDelegate!
    
    var titleMain          : UILabel!
    var titleSecondary     : UILabel!
    var emailField         : CustomTextField!
    var passwordField      : CustomTextField!
    
    var findPasswordButton : UIButton!
    var signupButton       : UIButton!
    var nextButton         : UIButton!
    
    var errorMessage       : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        if isRootView {
            let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_caret_black"), style: .plain, target: self, action: #selector(self.onBackPressed))
            self.navigationItem.leftBarButtonItem  = backButton
            self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        }
        
        self.title = NSLocalizedString("login", comment: "")
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        /* Title */
        titleMain = UILabel()
        titleMain.font = UIFont(name: "BMDOHYEON", size: 25)
        titleMain.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        titleMain.text = NSLocalizedString("login_title_main", comment: "")
        self.view.addSubview(titleMain)
        
        /* Second Title */
        titleSecondary = UILabel()
        titleSecondary.font = UIFont(name: "NotoSansCJKkr-DemiLight", size: 13)
        titleSecondary.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        titleSecondary.text = NSLocalizedString("login_title_secondary", comment: "")
        self.view.addSubview(titleSecondary)
        
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
        
        /* Find password button */
        findPasswordButton = UIButton()
        findPasswordButton.setTitleColor(VillimValues.themeColor, for: .normal)
        findPasswordButton.setTitleColor(VillimValues.themeColorHighlighted, for: .highlighted)
        findPasswordButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        findPasswordButton.setTitle(NSLocalizedString("forgot_password", comment: ""), for: .normal)
        findPasswordButton.addTarget(self, action:#selector(self.launchFindPasswordViewController), for: .touchUpInside)
        self.view.addSubview(findPasswordButton)
        
        /* Signup button */
        signupButton = UIButton()
        signupButton.setTitleColor(VillimValues.themeColor, for: .normal)
        signupButton.setTitleColor(VillimValues.themeColorHighlighted, for: .highlighted)
        signupButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        signupButton.setTitle(NSLocalizedString("signup", comment: ""), for: .normal)
        signupButton.addTarget(self, action:#selector(self.launchSignupViewController), for: .touchUpInside)
        self.view.addSubview(signupButton)
        
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
        
        /* Error message */
        errorMessage = UILabel()
        errorMessage.textAlignment = .center
        errorMessage.textColor = VillimValues.themeColor
        errorMessage.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        self.view.addSubview(errorMessage)

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
        
        /* Second Title */
        titleSecondary?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(titleMain.snp.bottom).offset(VillimValues.sideMargin)
        }
        
        /* Email field */
        emailField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(titleSecondary.snp.bottom).offset(VillimValues.sideMargin*2)
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
        
        /* Find password button */
        findPasswordButton?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.bottom.equalTo(nextButton.snp.top).offset(-VillimValues.sideMargin)
        }
        
        /* Signup button */
        signupButton?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.bottom.equalTo(nextButton.snp.top).offset(-VillimValues.sideMargin)
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
        
        /* Email form */
        emailField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        
        /* Password form */
        passwordField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
    }
    
    func launchSignupViewController() {
        let signupViewController = SignupViewController()
        signupViewController.signupListener = self
        self.navigationController?.pushViewController(signupViewController, animated: true)
    }
    
    func launchFindPasswordViewController() {
        let findPasswordViewController = FindPasswordViewController()
        self.navigationController?.pushViewController(findPasswordViewController, animated: true)
    }
    
    func onBackPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /* Text field listeners */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailField { // Switch focus to other text field
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
            sendLoginRequest();
        } else {
            showErrorMessage(message: NSLocalizedString("empty_field", comment: ""))
        }
    }
    
    @objc private func sendLoginRequest() {
        
        VillimUtils.showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_EMAIL    : emailField.text!,
            VillimKeys.KEY_PASSWORD : passwordField.text!
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.LOGIN_URL)
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    let user : VillimUser = VillimUser.init(userInfo:responseData[VillimKeys.KEY_USER_INFO])
                    VillimSession.setLoggedIn(loggedIn: true)
                    VillimSession.updateUserSession(user: user)
                    self.login()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
                self.loginDelegate.onLogin(success: false)
            }
            VillimUtils.hideLoadingIndicator()
        }
    }
    
    func login() {
        self.loginDelegate.onLogin(success: true)
        if isRootView {
             self.dismiss(animated: true, completion: nil)
        } else {
             self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onSignup(success:Bool) {
        self.login()
    }
    
    private func showErrorMessage(message:String) {
        errorMessage.isHidden = false
        errorMessage.text = message
    }
    
    private func hideErrorMessage() {
        errorMessage.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideErrorMessage()
        VillimUtils.hideLoadingIndicator()
    }
    
}
