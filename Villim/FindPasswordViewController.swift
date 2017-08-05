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

class FindPasswordViewController: UIViewController, UITextFieldDelegate, FindPasswordSuccessDelegate {

    var titleMain        : UILabel!
    var emailField       : CustomTextField!
    var instruction      : UILabel!
    
    var nextButton       : UIButton!
    
    var errorMessage     : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Set back button */
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("find_password", comment: "")
        
        /* Title */
        titleMain = UILabel()
        titleMain.font = UIFont(name: "NotoSansCJKkr-Medium", size: 25)
        titleMain.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        titleMain.text = NSLocalizedString("lost_password", comment: "")
        self.view.addSubview(titleMain)
        
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
        
        /* Instruction Field */
        instruction = UILabel()
        instruction.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        instruction.textColor = UIColor(red:0.35, green:0.34, blue:0.34, alpha:1.0)
        instruction.text = NSLocalizedString("enter_email", comment: "")
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
        
        /* Email field */
        emailField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(titleMain.snp.bottom).offset(VillimValues.sideMargin)
            make.height.equalTo(CustomTextField.iconSize * 2)
        }
        
        /* Instruction Field */
        instruction?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(VillimValues.sideMargin)
            make.right.equalToSuperview().offset(-VillimValues.sideMargin)
            make.top.equalTo(emailField.snp.bottom).offset(10)
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
        
        /* Email form */
        emailField.addBottomBorderWithColor(color: VillimValues.customTextFieldBorderColor, width: width)
    }
    
    @objc private func verifyInput() {
        let allFieldsFilledOut : Bool =
            !(emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
        let validInput : Bool = allFieldsFilledOut;
        if validInput {
            self.launchFindPasswordSuccessViewController()
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
        
        VillimUtils.showLoadingIndicator()
        
        let parameters = [
            VillimKeys.KEY_EMAIL : emailField.text!] as [String : Any]
        
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
                self.showErrorMessage(message: NSLocalizedString("server_unavailable", comment: ""))
            }
            VillimUtils.hideLoadingIndicator()
        }
    }

    func launchFindPasswordSuccessViewController() {
        let findPasswordSuccessViewController = FindPasswordSuccessViewController()
        findPasswordSuccessViewController.dismissDelegate = self
        self.navigationController?.pushViewController(findPasswordSuccessViewController, animated: true)
    }
    
    func onDismiss() {
        self.navigationController?.popViewController(animated: true)
        VillimUtils.hideLoadingIndicator()
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
