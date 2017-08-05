//
//  ChangePasscodeViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/29/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ChangePasscodeViewController: UIViewController, UITextFieldDelegate, ChangePasscodeSuccessDelegate {
    
    var titleMain            : UILabel!
    var passcodeField        : CustomTextField!
    var passcodeConfirmField : CustomTextField!
    
    var nextButton           : UIButton!
    
    var errorMessage         : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("configure_doorlock", comment: "")
        
        /* Title */
        titleMain = UILabel()
        titleMain.font = UIFont(name: "NotoSansCJKkr-Medium", size: 25)
        titleMain.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        titleMain.text = NSLocalizedString("change_doorlock_passcode", comment: "")
        self.view.addSubview(titleMain)
        
        /* Passcode field */
        passcodeField = CustomTextField()
        passcodeField.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        passcodeField.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        passcodeField.placeholder = NSLocalizedString("passcode_hint", comment: "")
        passcodeField.clearButtonMode = .whileEditing
        passcodeField.isSecureTextEntry = true
        passcodeField.keyboardType = .numberPad
        passcodeField.delegate = self
        self.view.addSubview(passcodeField)
        
        passcodeField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_lock"))
        passcodeField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        passcodeField.leftViewMode = .always
        
        /* Passcode confirm field */
        passcodeConfirmField = CustomTextField()
        passcodeConfirmField.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        passcodeConfirmField.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        passcodeConfirmField.placeholder = NSLocalizedString("passcode_confirm_hint", comment: "")
        passcodeConfirmField.isSecureTextEntry = true
        passcodeConfirmField.clearButtonMode = .whileEditing
        passcodeConfirmField.keyboardType = .numberPad
        passcodeConfirmField.delegate = self
        self.view.addSubview(passcodeConfirmField)
        
        passcodeConfirmField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_lock"))
        passcodeConfirmField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        passcodeConfirmField.leftViewMode = .always
        
        /* Confirm button */
        nextButton = UIButton()
        nextButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        nextButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
        nextButton.adjustsImageWhenHighlighted = true
        nextButton.titleLabel?.font = VillimValues.bottomButtonFont
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(VillimValues.whiteHighlightedColor, for: .highlighted)
        nextButton.setTitle(NSLocalizedString("confirm", comment: ""), for: .normal)
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
        
        /* Passcode field */
        passcodeField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(titleMain.snp.bottom).offset(VillimValues.sideMargin)
            make.height.equalTo(CustomTextField.iconSize * 2)
        }
        
        /* Passcode confirm field */
        passcodeConfirmField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(passcodeField.snp.bottom).offset(VillimValues.sideMargin)
            make.height.equalTo(CustomTextField.iconSize * 2)
        }
        
        /* Next button */
        nextButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(passcodeConfirmField.snp.bottom).offset(10)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = CGFloat(1.0)
        
        /* Passcode form */
        passcodeField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        
        /* Passcode confirm form */
        passcodeConfirmField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
    }
    
    /* Text field listeners */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passcodeField { // Switch focus to other text field
            passcodeConfirmField.becomeFirstResponder()
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
        let passcodeInput        : String = (passcodeField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        let passcodeConfirmInput : String = (passcodeConfirmField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
        let allFieldsFilledOut : Bool = !(passcodeInput.isEmpty) && !(passcodeConfirmInput.isEmpty)
        let same      : Bool = passcodeInput == passcodeConfirmInput
        let tooLong   : Bool = passcodeInput.characters.count > 12 && passcodeConfirmInput.characters.count > 12
        let tooShort  : Bool = passcodeInput.characters.count < 4 && passcodeConfirmInput.characters.count < 4
        let allDigits : Bool = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: passcodeInput)) &&
                                CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: passcodeConfirmInput))

        let validInput : Bool = allFieldsFilledOut && same && !tooLong && !tooShort && allDigits
        if validInput {
            sendChangePasscodeRequest();
        } else if !allFieldsFilledOut {
            showErrorMessage(message: NSLocalizedString("empty_field", comment: ""))
        } else if !same {
            showErrorMessage(message: NSLocalizedString("passcode_different", comment: ""))
        } else if tooLong {
            showErrorMessage(message: NSLocalizedString("passcode_too_long", comment: ""))
        } else if tooShort {
            showErrorMessage(message: NSLocalizedString("passcode_too_short", comment: ""))
        } else if !allDigits {
            showErrorMessage(message: NSLocalizedString("passcode_non_digit", comment: ""))
        } else {
            showErrorMessage(message: NSLocalizedString("try_again", comment: ""))
        }
    }
    
    @objc private func sendChangePasscodeRequest() {
        
        VillimUtils.showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_PASSCODE         : (passcodeField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
            VillimKeys.KEY_PASSCODE_CONFIRM : (passcodeConfirmField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.CHANGE_PASSCODE_URL)
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                print(responseData)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                
                    self.launchChangePasscodeSuccessViewController()
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
        }
    }
    
    
    func onDismiss() {
        VillimUtils.hideLoadingIndicator()
        self.navigationController?.popViewController(animated: true)
    }
    
    func launchChangePasscodeSuccessViewController() {
        let changePasscodeSuccessViewController = ChangePasscodeSuccessViewController()
        changePasscodeSuccessViewController.dismissDelegate = self
        let newNavBar: UINavigationController = UINavigationController(rootViewController: changePasscodeSuccessViewController)
        self.present(newNavBar, animated: true, completion: nil)

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
        VillimUtils.hideLoadingIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
