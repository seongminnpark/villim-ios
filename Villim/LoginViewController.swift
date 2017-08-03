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
import NVActivityIndicatorView

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

protocol LoginListener {
    func onLogin(success:Bool)
}

class LoginViewController: UIViewController, UITextFieldDelegate, SignupListener {
    
    var loginListener      : LoginListener!
    
    var titleMain          : UILabel!
    var titleSecondary     : UILabel!
    var emailField         : UITextField!
    var passwordField      : UITextField!
    
    var findPasswordButton : UIButton!
    var signupButton       : UIButton!
    var nextButton         : UIButton!
    
    var errorMessage       : UILabel!
    var loadingIndicator   : NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.title = NSLocalizedString("login", comment: "")
        
        /* Title */
        titleMain = UILabel()
        titleMain.text = NSLocalizedString("login_title_main", comment: "")
        self.view.addSubview(titleMain)
        
        /* Second Title */
        titleSecondary = UILabel()
        titleSecondary.text = NSLocalizedString("login_title_secondary", comment: "")
        self.view.addSubview(titleSecondary)
        
        /* Email field */
        emailField = UITextField()
        emailField.borderStyle = .roundedRect
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
        passwordField.borderStyle = .roundedRect
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
        findPasswordButton.setTitle(NSLocalizedString("forgot_password", comment: ""), for: .normal)
        findPasswordButton.setTitleColor(UIColor.gray, for: .normal)
        findPasswordButton.setTitleColor(UIColor.black, for: .highlighted)
        findPasswordButton.addTarget(self, action:#selector(self.launchFindPasswordViewController), for: .touchUpInside)
        self.view.addSubview(findPasswordButton)
        
        /* Signup button */
        signupButton = UIButton()
        signupButton.setTitle(NSLocalizedString("signup", comment: ""), for: .normal)
        signupButton.setTitleColor(UIColor.gray, for: .normal)
        signupButton.setTitleColor(UIColor.black, for: .highlighted)
        signupButton.addTarget(self, action:#selector(self.launchSignupViewController), for: .touchUpInside)
        self.view.addSubview(signupButton)
        
        /* Next button */
        nextButton = UIButton()
        nextButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        nextButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
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
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(topOffset)
        }
        
        /* Second Title */
        titleSecondary?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(titleMain.snp.bottom)
        }
        
        /* Email field */
        emailField?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(titleSecondary.snp.bottom)
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
        
        /* Find password button */
        findPasswordButton?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        /* Signup button */
        signupButton?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(30)
            make.top.equalTo(passwordField.snp.bottom)
        }
        
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
        
        showLoadingIndicator()
        
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
                self.loginListener.onLogin(success: false)
            }
            self.hideLoadingIndicator()
        }
    }
    
    func login() {
        self.loginListener.onLogin(success: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func onSignup(success:Bool) {
        self.login()
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
