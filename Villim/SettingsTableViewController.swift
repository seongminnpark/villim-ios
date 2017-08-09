//
//  SettingsTableViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/8/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

protocol SettingsDelegate {
    func launchViewController(viewController:UIViewController, animated:Bool)
}

class SettingsTableViewController: UITableViewController {

    static let PUSH      : Int = 0
    static let VIBRATION : Int = 1
    static let CURRENCY  : Int = 2
    static let LANGUAGE  : Int = 3
    static let VERSION   : Int = 4
    static let LICENSE   : Int = 5
    
    var settingsDelegate : SettingsDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of unnecessary cells stretching to the bottom.
        self.tableView.isScrollEnabled = false
        self.tableView.backgroundColor = VillimValues.backgroundColor
        self.tableView.separatorInset = UIEdgeInsets.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
        case SettingsTableViewController.PUSH:
            return setUpPushCell()
           
        case SettingsTableViewController.VIBRATION:
            return setUpVibrationCell()
            
        case SettingsTableViewController.CURRENCY:
            return setUpCurrencyCell()
            
        case SettingsTableViewController.LANGUAGE:
            return setUpLanguageCell()
            
        case SettingsTableViewController.VERSION:
            return setUpVersionCell()
            
        case SettingsTableViewController.LICENSE:
            return setUpLicenseCell()
            
        default:
            return setUpLicenseCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        
        switch row {
            
        case SettingsTableViewController.CURRENCY:
            launchCurrencyDialog()
            break
            
        case SettingsTableViewController.LANGUAGE:
            launchLanguageDialog()
            break
            
        case SettingsTableViewController.LICENSE:
            launchLicenseViewController()
            break
            
        default:
            break
        }
    }
    
    
    func setUpPushCell() -> SwitchTableViewCell {
        let cell : SwitchTableViewCell = SwitchTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"switch")
        cell.selectionStyle = .none
        
        cell.title.text =  NSLocalizedString("push_notifications", comment: "")
        cell.button.isOn = VillimSession.getPushPref()
        cell.button.addTarget(self, action:#selector(self.onPushChanged(uiSwitch:)), for: .valueChanged)
        
        cell.makeConstraints()
        return cell
    }
    
    func setUpVibrationCell() -> SwitchTableViewCell {
        let cell : SwitchTableViewCell = SwitchTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"switch")
        cell.selectionStyle = .none
        
        cell.title.text =  NSLocalizedString("vibration_on_doorlock_unlock", comment: "")
        cell.button.isOn = VillimSession.getVibrationOnUnlock()
        cell.button.addTarget(self, action:#selector(self.onVibrationChanged(uiSwitch:)), for: .valueChanged)
        
        cell.makeConstraints()
        return cell
    }
    
    func setUpCurrencyCell() -> HouseGenericTableViewCell {
        let cell : HouseGenericTableViewCell = HouseGenericTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_generic")
        
        cell.title.text = NSLocalizedString("currency", comment: "")
        cell.button.setTitle(VillimUtils.currencyToString(code: VillimSession.getCurrencyPref(), full: true), for: .normal)
        cell.button.isEnabled = false
        
        cell.makeConstraints()
        return cell
    }
    
    func setUpLanguageCell() -> HouseGenericTableViewCell {
        let cell : HouseGenericTableViewCell = HouseGenericTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_generic")
        
        cell.title.text = NSLocalizedString("language", comment: "")
        cell.button.setTitle(VillimUtils.languageToString(code: VillimSession.getLanguagePref()), for: .normal)
        cell.button.isEnabled = false
        
        cell.makeConstraints()
        return cell
    }
    
    func setUpVersionCell() -> HouseGenericTableViewCell {
        let cell : HouseGenericTableViewCell = HouseGenericTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_generic")
        cell.selectionStyle = .none
        
        cell.title.text = NSLocalizedString("version_information", comment: "")
        cell.button.setTitle(VillimKeys.APP_VERSION, for: .normal)
        cell.button.setTitleColor(UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0), for: .normal)
        cell.button.isEnabled = false
        
        cell.makeConstraints()
        return cell
    }

    func setUpLicenseCell() -> HouseGenericTableViewCell {
        let cell : HouseGenericTableViewCell = HouseGenericTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"house_generic")
        
        
        cell.title.text = NSLocalizedString("license_information", comment: "")
//        cell.button.setTitle(NSLocalizedString("read", comment: ""), for: .normal)
        cell.button.isEnabled = false
        
        cell.makeConstraints()
        return cell
    }
    
    /* Switch listeners */
    func onPushChanged(uiSwitch : UISwitch!) {
        VillimSession.setPushPref(pushPref: uiSwitch.isOn)
    }
    
    func onVibrationChanged(uiSwitch : UISwitch!) {
        VillimSession.setVibrationOnUnlock(vibrationPref: uiSwitch.isOn)
    }
    
    /* Dialog and viewcontroller launchers */
    func launchCurrencyDialog() {
        
    }
    
    func launchLanguageDialog() {
        
    }
    
    
    func launchLicenseViewController() {
        let licenseViewController = LicenseVIewController()
        settingsDelegate.launchViewController(viewController: licenseViewController, animated: true)
    }
}


















