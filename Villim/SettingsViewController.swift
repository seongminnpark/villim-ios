//
//  SettnigsViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/8/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import pop
import Material

class SettingsViewController: UIViewController, SettingsDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    let currencyPickerData = ["KRW (₩)", "USD ($)"]
    let languagePickerData = [NSLocalizedString("korean", comment: ""),
                              NSLocalizedString("english", comment: "")]
    
    
    var pickerType : Int!
    
    var alert : UIAlertController!
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
        
        var alertTitle : String
        
        let alertContentView = UIViewController()
        alertContentView.preferredContentSize = CGSize(width: 250,height: 150)
        
        /* Picker */
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        picker.backgroundColor = Color.grey.lighten4
        picker.delegate = self
        picker.dataSource = self
        picker.alpha = 1
    
        /* Show picker */
        switch self.pickerType {
        case SettingsTableViewController.CURRENCY:
            picker.selectRow(VillimSession.getCurrencyPref(), inComponent: 0, animated: false)
            alertTitle = NSLocalizedString("choose_currency", comment:"")
            break
        case SettingsTableViewController.LANGUAGE:
            picker.selectRow(VillimSession.getLanguagePref(), inComponent: 0, animated: false)
            alertTitle = NSLocalizedString("choose_language", comment:"")
            break
        default:
            alertTitle = ""
            break
        }
    
        alertContentView.view.addSubview(picker)
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.setValue(alertContentView, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: NSLocalizedString("done", comment:""), style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func launchViewController(viewController:UIViewController, animated:Bool) {
        self.navigationController?.pushViewController(viewController, animated:animated)
    }

}
