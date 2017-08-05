//
//  VerifyPhoneViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/4/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

protocol VerifyPhoneDelegate {
    func onVerifySuccess()
}

class VerifyPhoneViewController: UIViewController, UITextFieldDelegate{

    var verifyDelegate : VerifyPhoneDelegate!
    
    var titleMain        : UILabel!
    
    var container        : UIStackView!
    
    var code1            : VerificationCodeField!
    var code2            : VerificationCodeField!
    var code3            : VerificationCodeField!
    var code4            : VerificationCodeField!
    var code5            : VerificationCodeField!
    var code6            : VerificationCodeField!
    
    var instruction      : UILabel!
    
    
    var nextButton       : UIButton!
    
    var errorMessage     : UILabel!
    var loadingIndicator : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Set back button */
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("verify_phone_number", comment: "")

        /* Title */
        titleMain = UILabel()
        titleMain.font = UIFont(name: "NotoSansCJKkr-Medium", size: 25)
        titleMain.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        titleMain.text = NSLocalizedString("verify_phone_title", comment: "")
        self.view.addSubview(titleMain)
        
        /* Container */
        container = UIStackView()
        container.axis = UILayoutConstraintAxis.horizontal
        container.distribution = UIStackViewDistribution.fillEqually
        container.alignment = UIStackViewAlignment.center
        container.spacing = VillimValues.sideMargin
        self.view.addSubview(container)
        
        /* Codes */
        code1 = VerificationCodeField()
        code1.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        code1.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        code1.textContentType = .telephoneNumber
        code1.keyboardType = .decimalPad
        code1.returnKeyType = .next
        code1.textAlignment = .center
        code1.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        code1.delegate = self
        container.addArrangedSubview(code1)
        
        code2 = VerificationCodeField()
        code2.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        code2.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        code2.textContentType = .telephoneNumber
        code2.keyboardType = .decimalPad
        code2.returnKeyType = .next
        code2.textAlignment = .center
        code2.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        code2.delegate = self
        container.addArrangedSubview(code2)
        
        code3 = VerificationCodeField()
        code3.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        code3.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        code3.textContentType = .telephoneNumber
        code3.keyboardType = .decimalPad
        code3.returnKeyType = .next
        code3.textAlignment = .center
        code3.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        code3.delegate = self
        container.addArrangedSubview(code3)
        
        code4 = VerificationCodeField()
        code4.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        code4.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        code4.textContentType = .telephoneNumber
        code4.keyboardType = .decimalPad
        code4.returnKeyType = .next
        code4.textAlignment = .center
        code4.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        code4.delegate = self
        container.addArrangedSubview(code4)
        
        code5 = VerificationCodeField()
        code5.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        code5.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        code5.textContentType = .telephoneNumber
        code5.keyboardType = .decimalPad
        code5.returnKeyType = .next
        code5.textAlignment = .center
        code5.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        code5.delegate = self
        container.addArrangedSubview(code5)
        
        code6 = VerificationCodeField()
        code6.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        code6.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        code6.textContentType = .telephoneNumber
        code6.keyboardType = .decimalPad
        code6.returnKeyType = .next
        code6.textAlignment = .center
        code6.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        code6.delegate = self
        container.addArrangedSubview(code6)

        /* Instruction Field */
        instruction = UILabel()
        instruction.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        instruction.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        instruction.text = NSLocalizedString("verify_phone_instruction", comment: "")
        instruction.textAlignment = .center
        self.view.addSubview(instruction)
        
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
        
        /* Code container */
        container?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(titleMain.snp.bottom).offset(VillimValues.sideMargin)
            make.height.equalTo(CustomTextField.iconSize * 3)
        }
        
        /* Instruction Field */
        instruction?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(container.snp.bottom).offset(10)
        }
        
        /* Error message */
        errorMessage?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(instruction.snp.bottom).offset(VillimValues.sideMargin * 2)
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
        
        code1.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        code2.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        code3.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        code4.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        code5.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
        code6.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
    }
    
    
    @objc private func verifyInput() {
        let code1Text : String = (code1.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        let code2Text : String = (code2.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        let code3Text : String = (code3.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        let code4Text : String = (code4.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        let code5Text : String = (code5.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        let code6Text : String = (code6.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
        
        let allFieldsFilledOut : Bool = !code1Text.isEmpty && !code2Text.isEmpty
                                        && !code3Text.isEmpty && !code4Text.isEmpty
                                        && !code5Text.isEmpty && !code6Text.isEmpty
        
        let allDigits : Bool = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: code1Text))
                                && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: code2Text))
                                && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: code3Text))
                                && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: code4Text))
                                && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: code5Text))
                                && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: code6Text))
        
        let validInput : Bool = allFieldsFilledOut && allDigits
        if validInput {
            var num = code1Text + code2Text + code3Text
            num += code4Text + code5Text + code6Text
            sendVerifyPhoneRequest(number: num)
            self.navigationController?.popViewController(animated: true)
        } else if !allFieldsFilledOut {
            showErrorMessage(message: NSLocalizedString("empty_field", comment: ""))
        } else if !allDigits {
            showErrorMessage(message: NSLocalizedString("phone_number_non_digit", comment: ""))
        } else {
            showErrorMessage(message: NSLocalizedString("try_again", comment: ""))
        }
    }
    
    /* Text field listeners */
    func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.characters.count == 1 {
            switch textField{
            case self.code1:
                self.code2.becomeFirstResponder()
            case self.code2:
                self.code3.becomeFirstResponder()
            case self.code3:
                self.code4.becomeFirstResponder()
            case self.code4:
                self.code5.becomeFirstResponder()
            case self.code5:
                self.code6.becomeFirstResponder()
            case self.code6:
                self.code6.resignFirstResponder()
            default:
                break
            }
        } else {
            var input = textField.text!
            textField.text = input.substring(from:input.index(input.endIndex, offsetBy: -1))
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func sendVerifyPhoneRequest(number:String) {
        
        showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_PHONE_NUMBER : number] as [String : Any]
        
        let url = VillimUtils.buildURL(endpoint: VillimKeys.SEND_VERIFICATION_PHONE_URL)
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(data: response.data!)
                if responseData[VillimKeys.KEY_SUCCESS].boolValue {
                    self.verifyDelegate.onVerifySuccess()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showErrorMessage(message: responseData[VillimKeys.KEY_MESSAGE].stringValue)
                }
            case .failure(let error):
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            self.hideLoadingIndicator()
        }
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
