//
//  AddPhoneNumberViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/4/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

protocol AddPhoneDelegate {
    func onPhoneAdded(number:String)
}

class AddPhoneViewController: UIViewController, UITextFieldDelegate, VerifyPhoneDelegate {
    
    var phoneNumeber     : String! = ""
    
    var phoneDelegate    : AddPhoneDelegate!

    var titleMain        : UILabel!
    var numberField      : CustomTextField!
    
    var nextButton       : UIButton!
    
    var errorMessage     : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_caret_black"), style: .plain, target: self, action: #selector(self.onBackPressed))
        self.navigationItem.leftBarButtonItem  = backButton
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("add_phone_number", comment: "")

        /* Title */
        titleMain = UILabel()
        titleMain.font = UIFont(name: "NotoSansCJKkr-Medium", size: 25)
        titleMain.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        titleMain.text = NSLocalizedString("enter_phone_number", comment: "")
        self.view.addSubview(titleMain)
        
        /* Number field */
        numberField = CustomTextField()
        numberField.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        numberField.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        numberField.placeholder = NSLocalizedString("add_phone_number_placeholder", comment: "")
        numberField.textContentType = .telephoneNumber
        numberField.keyboardType = .decimalPad
        numberField.returnKeyType = .done
        numberField.clearButtonMode = .whileEditing
        numberField.delegate = self
        numberField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.view.addSubview(numberField)
        
        numberField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_phone"))
        numberField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        numberField.leftViewMode = .always
        
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
        
        /* Number field */
        numberField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(titleMain.snp.bottom).offset(VillimValues.sideMargin)
            make.height.equalTo(CustomTextField.iconSize * 2)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(numberField.snp.bottom).offset(VillimValues.sideMargin * 2)
        }
        
        /* Next button */
        nextButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = CGFloat(1.0)
        
        /* Number form */
        numberField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
    }
    
    
    @objc private func verifyInput() {
        let phoneInput        : String = VillimUtils.decodePhoneString(phoneString: (numberField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        
        let allFieldsFilledOut : Bool = !phoneInput.isEmpty
        let tooLong   : Bool = phoneInput.characters.count > 11
        let tooShort  : Bool = phoneInput.characters.count < 10
        let allDigits : Bool = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phoneInput))
        
        let validInput : Bool = allFieldsFilledOut && !tooLong && !tooShort && allDigits
        if validInput {
            sendSendVerificationPhoneRequest()
        } else if !allFieldsFilledOut {
            showErrorMessage(message: NSLocalizedString("empty_field", comment: ""))
        } else if tooLong {
            showErrorMessage(message: NSLocalizedString("phone_number_too_long", comment: ""))
        } else if tooShort {
            showErrorMessage(message: NSLocalizedString("phone_number_too_short", comment: ""))
        } else if !allDigits {
            showErrorMessage(message: NSLocalizedString("phone_number_non_digit", comment: ""))
        } else {
            showErrorMessage(message: NSLocalizedString("try_again", comment: ""))
        }
    }
    
    func onBackPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /* Text field listeners */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /* Text field listeners */
    func textFieldDidChange(_ textField: UITextField) {
        
        textField.text = VillimUtils.formatPhoneNumber(numberString: VillimUtils.decodePhoneString(phoneString: textField.text!))
    }

    func keyboardInputShouldDelete(_ textField: UITextField) -> Bool {
        
        let currString = textField.text!
        
        if currString.characters.last! == ")" {
            textField.text = String(currString.characters.dropLast())
        }
        
        return true
    }
    
    
    @objc private func sendSendVerificationPhoneRequest() {
        
        VillimUtils.showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_PHONE_NUMBER : numberField.text!] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.SEND_VERIFICATION_PHONE_URL)
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    self.phoneNumeber = VillimUtils.decodePhoneString(phoneString: self.numberField.text!)
                    self.launchVerifyPhoneViewController()
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
        }
    }
    
    func launchVerifyPhoneViewController() {
        let verifyPhoneViewController = VerifyPhoneViewController()
        verifyPhoneViewController.verifyDelegate = self
        self.navigationController?.pushViewController(verifyPhoneViewController, animated: true)
    }
    
    func onVerifySuccess() {
        phoneDelegate.onPhoneAdded(number:self.phoneNumeber)
        self.dismiss(animated:true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}
