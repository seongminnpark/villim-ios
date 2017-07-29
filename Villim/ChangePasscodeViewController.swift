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
import NVActivityIndicatorView

class ChangePasscodeViewController: UIViewController, UITextFieldDelegate {
    
    var titleMain            : UILabel!
    var passcodeField        : UITextField!
    var passcodeConfirmField : UITextField!
    
    var nextButton           : UIButton!
    
    var errorMessage         : UILabel!
    var loadingIndicator     : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.title = NSLocalizedString("configure_doorlock", comment: "")
        
        /* Title */
        titleMain = UILabel()
        titleMain.text = NSLocalizedString("change_doorlock_passcode", comment: "")
        self.view.addSubview(titleMain)
        
        /* Passcode field */
        passcodeField = UITextField()
        passcodeField.placeholder = NSLocalizedString("passcode_hint", comment: "")
        passcodeField.textContentType = UITextContentType.emailAddress
        passcodeField.keyboardType = UIKeyboardType.emailAddress
        passcodeField.returnKeyType = .next
        passcodeField.autocapitalizationType = .none
        passcodeField.clearButtonMode = .whileEditing
        passcodeField.delegate = self
        self.view.addSubview(passcodeField)
        
        passcodeField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_view_profile"))
        passcodeField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        passcodeField.leftViewMode = .always
        
        /* Passcode confirm field */
        passcodeConfirmField = UITextField()
        passcodeConfirmField.placeholder = NSLocalizedString("passcode_confirm_hint", comment: "")
        passcodeConfirmField.isSecureTextEntry = true
        passcodeConfirmField.autocapitalizationType = .none
        passcodeConfirmField.returnKeyType = .done
        passcodeConfirmField.clearButtonMode = .whileEditing
        passcodeConfirmField.delegate = self
        self.view.addSubview(passcodeConfirmField)
        
        passcodeConfirmField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_view_profile"))
        passcodeConfirmField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        passcodeConfirmField.leftViewMode = .always
        
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
        
        /* Passcode field */
        passcodeField?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(titleMain.snp.bottom)
        }
        
        /* Passcode confirm field */
        passcodeConfirmField?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(passcodeField.snp.bottom)
        }
        
        /* Next button */
        nextButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(30)
            make.top.equalTo(passcodeConfirmField.snp.bottom)
        }
        
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
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_PASSCODE         : passcodeField.text!,
            VillimKeys.KEY_PASSCODE_CONFIRM : passcodeConfirmField.text!
            ] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.CHANGE_PASSCODE_URL)
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                
                if responseData[VillimKeys.KEY_CHANGE_SUCCESS].boolValue {

                    
                    
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
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
