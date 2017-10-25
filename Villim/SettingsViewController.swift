//
//  SettnigsViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/8/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    let currencyPickerData = ["KRW (₩)", "USD ($)"]
    let languagePickerData = [NSLocalizedString("korean", comment: ""),
                              NSLocalizedString("english", comment: "")]
    
    
    var pickerType : Int!
    
    var picker : UIPickerView!
    var toolBar : UIToolbar!
    
    var settingsTableviewController : SettingsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Set up navigation bar */
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        /* Set navigation bar title */
        self.navigationItem.titleLabel.text = NSLocalizedString("settings", comment: "")
        
        /* Set back button */
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = VillimValues.darkBackButtonColor
        
        /* Tableview controller */
        settingsTableviewController = SettingsTableViewController()
        settingsTableviewController.settingsDelegate = self
        self.view.addSubview(settingsTableviewController.view)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Tableview */
        settingsTableviewController.view.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(topOffset)
            make.bottom.equalToSuperview()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /* Picker delegates */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch self.pickerType {
        case SettingsTableViewController.CURRENCY:
            return 1
        case SettingsTableViewController.LANGUAGE:
            return 1
        default:
            return 0
        }
    }
    
    func showPicker(type:Int){
        self.pickerType = type

        showPicker()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent: Int) -> Int {
        switch self.pickerType {
        case SettingsTableViewController.CURRENCY:
            return currencyPickerData.count
        case SettingsTableViewController.LANGUAGE:
            return languagePickerData.count
        default:
            return 0
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch self.pickerType {
        case SettingsTableViewController.CURRENCY:
            return currencyPickerData[row]
        case SettingsTableViewController.LANGUAGE:
            return languagePickerData[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch self.pickerType {
            
        case SettingsTableViewController.CURRENCY:
            VillimSession.setCurrencyPref(currencyPref: row)
            let indexPath = IndexPath(item: SettingsTableViewController.CURRENCY, section: 0)
            self.settingsTableviewController.tableView.reloadRows(at: [indexPath], with: .top)
            
        case SettingsTableViewController.LANGUAGE:
            VillimSession.setLanguagePref(languagePref: row)
            let indexPath = IndexPath(item: SettingsTableViewController.LANGUAGE, section: 0)
            self.settingsTableviewController.tableView.reloadRows(at: [indexPath], with: .top)
            
        default:
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 40
    }

    func showPicker() {
        
        if picker != nil {
            picker.removeFromSuperview()
        }
        if toolBar != nil {
            toolBar.removeFromSuperview()
        }
        
        /* Picker */
        picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        picker.delegate = self
        picker.dataSource = self
        picker.alpha = 0
        
        toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor.darkGray
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        toolBar.alpha = 0
        
        let button  = UIButton()
        button.setTitle(NSLocalizedString("done", comment:""), for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(self.hidePicker), for: .touchUpInside)
        button.sizeToFit()

        let doneButton = UIBarButtonItem(customView: button)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
        
        /* Picker */
        picker.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom).offset(-VillimValues.pickerHeight)
            make.bottom.equalToSuperview()
        }
        
        /* Toolbar */
        toolBar.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(picker.snp.top)
        }
    
        /* Show picker */
        switch self.pickerType {
        case SettingsTableViewController.CURRENCY:
            picker.selectRow(VillimSession.getCurrencyPref(), inComponent: 0, animated: false)
            break
        case SettingsTableViewController.LANGUAGE:
            picker.selectRow(VillimSession.getLanguagePref(), inComponent: 0, animated: false)
            break
        default:
            break
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.picker.alpha = 1
            self.toolBar.alpha = 1
        })
    }
    
    func hidePicker() {
        if self.picker != nil && self.toolBar != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.picker.alpha = 0
                self.toolBar.alpha = 0
            })
        }

        if picker != nil {
            picker.removeFromSuperview()
        }
        if toolBar != nil {
            toolBar.removeFromSuperview()
        }
    }
    
    
    func launchViewController(viewController:UIViewController, animated:Bool) {
        self.navigationController?.pushViewController(viewController, animated:animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hidePicker()
    }

}
