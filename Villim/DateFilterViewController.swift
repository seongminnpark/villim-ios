//
//  DateFilterViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/30/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import Toaster
import SwiftDate

protocol DateFilterDelegate {
    func onDateFilterSet(checkIn:DateInRegion, checkOut:DateInRegion)
}

class DateFilterViewController: UIViewController {
    let LabelContainerHeight = 130.0
    
    var dateSet : Bool = false
    var checkIn  : DateInRegion! = nil
    var checkOut : DateInRegion! = nil
    
    var dateDalegate : DateFilterDelegate!
    
    var labelContainer : UIView!
    var checkInLabel   : UILabel!
    var checkOutLabel  : UILabel!

    var saveButton     : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "날짜 선택"
        
        /* Date labels */
        labelContainer = UIView()
        self.view.addSubview(labelContainer)
        
        checkInLabel = UILabel()
        var checkInText = dateSet ?
            String(format:NSLocalizedString("date_format_client_weekday", comment: ""),
                   checkIn.month, checkIn.day, VillimUtils.weekdayToString(weekday:checkIn.weekday)) :
            NSLocalizedString("start_date", comment: "")
        checkInLabel.text = checkInText
        labelContainer.addSubview(checkInLabel)
        
        checkOutLabel = UILabel()
        var checkOutText = dateSet ?
            String(format:NSLocalizedString("date_format_client_weekday", comment: ""),
                   checkOut.month, checkOut.day, checkOut.weekday) :
            NSLocalizedString("end_date", comment: "")
        checkOutLabel.text = checkOutText
        labelContainer.addSubview(checkOutLabel)
        
        /* Save button */
        saveButton = UIButton()
        saveButton.setBackgroundColor(color: VillimValues.themeColor, forState: .normal)
        saveButton.setBackgroundColor(color: VillimValues.themeColorHighlighted, forState: .highlighted)
        saveButton.adjustsImageWhenHighlighted = true
        saveButton.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitleColor(UIColor.gray, for: .highlighted)
        saveButton.addTarget(self, action: #selector(self.verifyInput), for: .touchUpInside)
        self.view.addSubview(saveButton)

        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Date labels */
        labelContainer?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(LabelContainerHeight)
            make.top.equalTo(topOffset)
        }
        
        checkInLabel?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        checkOutLabel?.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        
        /* Save button */
        saveButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(VillimValues.BOTTOM_BUTTON_HEIGHT)
            make.bottom.equalTo(self.view)
        }
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = CGFloat(1.0)
        
        let labelBorder = CALayer()
        labelBorder.borderColor = VillimValues.searchFilterContentColor.cgColor
        labelBorder.frame = CGRect(x: 0, y: labelContainer.frame.size.height - width, width:  labelContainer.frame.size.width, height: labelContainer.frame.size.height)
        labelBorder.backgroundColor = UIColor.clear.cgColor
        labelBorder.borderWidth = width
        labelContainer.layer.addSublayer(labelBorder)
        labelContainer.layer.masksToBounds = true

    }
    
    @objc private func verifyInput() {
        let allFieldsFilledOut : Bool = true
        let validInput : Bool = allFieldsFilledOut;
        if validInput {
            dateDalegate.onDateFilterSet(checkIn: self.checkIn, checkOut: self.checkOut)
        } else {
            showErrorMessage(message: NSLocalizedString("empty_field", comment: ""))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func showErrorMessage(message:String) {
        let toast = Toast(text: message, duration: Delay.long)
        
        ToastView.appearance().bottomOffsetPortrait = (tabBarController?.tabBar.frame.size.height)! + 30
        ToastView.appearance().bottomOffsetLandscape = (tabBarController?.tabBar.frame.size.height)! + 30
        ToastView.appearance().font = UIFont.systemFont(ofSize: 17.0)
        
        toast.show()
    }
    
    private func hideErrorMessage() {
        ToastCenter.default.cancelAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideErrorMessage()
    }
    
}
