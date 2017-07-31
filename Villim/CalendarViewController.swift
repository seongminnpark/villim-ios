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
import FSCalendar

protocol CalendarDelegate {
    func onDateSet(checkIn:DateInRegion, checkOut:DateInRegion)
}

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    static let STATE_NORMAL          = 0
    static let STATE_SELECT_CHECKIN  = 1
    static let STATE_SELECT_CHECKOUT = 2
    
    let LabelContainerHeight = 130.0
    
    var state : Int!
    var dateSet : Bool = false
    var checkIn  : DateInRegion! = nil
    var checkOut : DateInRegion! = nil
    
    var calendarDelegate : CalendarDelegate!
    
    private weak var calendar: FSCalendar!
    var labelContainer : UIView!
    var checkInLabel   : UILabel!
    var checkOutLabel  : UILabel!

    var saveButton     : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "날짜 선택"
        
        state = CalendarViewController.STATE_SELECT_CHECKIN
        
        /* Date labels */
        labelContainer = UIView()
        self.view.addSubview(labelContainer)
        
        checkInLabel = UILabel()
        checkInLabel.numberOfLines = 2
        let checkInText = dateSet ?
            String(format:NSLocalizedString("date_format_client_weekday", comment: ""),
                   checkIn.month, checkIn.day, VillimUtils.weekdayToString(weekday:checkIn.weekday)) :
            NSLocalizedString("start_date", comment: "")
        checkInLabel.text = checkInText
        labelContainer.addSubview(checkInLabel)
        
        checkOutLabel = UILabel()
        checkOutLabel.numberOfLines = 2
        let checkOutText = dateSet ?
            String(format:NSLocalizedString("date_format_client_weekday", comment: ""),
                   checkOut.month, checkOut.day, VillimUtils.weekdayToString(weekday:checkOut.weekday)) :
            NSLocalizedString("end_date", comment: "")
        checkOutLabel.text = checkOutText
        labelContainer.addSubview(checkOutLabel)
        
        /* Calendar */
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.scrollDirection = .vertical
        self.view.addSubview(calendar)
        self.calendar = calendar
        
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
        
        if dateSet {
            selectDates(from: checkIn, to: checkOut)
        }
        
        updateState()
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
        
        /* Calendar */
        calendar?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(labelContainer.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top)
        }
        
        self.view.layoutIfNeeded()
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
    
    func updateState() {
        switch self.state {
        case CalendarViewController.STATE_NORMAL:
            checkInLabel.textColor = UIColor.black
            checkOutLabel.textColor = UIColor.black
            break
        case CalendarViewController.STATE_SELECT_CHECKIN:
            checkInLabel.textColor = VillimValues.themeColor
            checkOutLabel.textColor = UIColor.black
            break
        case CalendarViewController.STATE_SELECT_CHECKOUT:
            checkInLabel.textColor = UIColor.black
            checkOutLabel.textColor = VillimValues.themeColor
            break
        default:
            break
        }
        saveButton.isEnabled = self.dateSet
    }
    
    /* Calendar methods */
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if (date.isToday) {
            return false
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let selectedDate = DateInRegion(absoluteDate:date)
        
        switch self.state {
        case CalendarViewController.STATE_SELECT_CHECKIN,
             CalendarViewController.STATE_NORMAL:
            self.dateSet = false
            self.state = CalendarViewController.STATE_SELECT_CHECKOUT
            self.checkIn = selectedDate
            checkInLabel.text =
                String(format:NSLocalizedString("date_format_client_weekday", comment: ""),
                   self.checkIn.month, self.checkIn.day,
                   VillimUtils.weekdayToString(weekday:self.checkIn.weekday))
            checkOutLabel.text = NSLocalizedString("end_date", comment: "")
            clearDates()
            calendar.select(self.checkIn.absoluteDate)
            break
            
        case CalendarViewController.STATE_SELECT_CHECKOUT:
            self.dateSet = true
            self.state = CalendarViewController.STATE_NORMAL
            self.checkOut = selectedDate
            checkOutLabel.text =
                String(format:NSLocalizedString("date_format_client_weekday", comment: ""),
                       self.checkOut.month, self.checkOut.day,
                       VillimUtils.weekdayToString(weekday:self.checkOut.weekday))
            selectDates(from:self.checkIn, to:self.checkOut)
            break
            
        default:
            break
        }
        
        updateState()
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.calendar(calendar, didSelect: date, at: monthPosition)
    }
    
    func selectDates(from:DateInRegion, to:DateInRegion) {
        for date in DateInRegion.dates(between: from, and: to, increment: 1.day)! {
            calendar.select(date.absoluteDate)
        }
    }
    
    func clearDates() {
        for date in calendar.selectedDates {
            calendar.deselect(date)
        }
    }
    
    @objc private func verifyInput() {
        let differentDates : Bool = self.checkIn != self.checkOut
        let monthApart     : Bool = self.checkIn + 1.month <= checkOut
        let validInput : Bool = differentDates && monthApart
        if validInput {
            self.navigationController?.popViewController(animated: true)
            calendarDelegate.onDateSet(checkIn: self.checkIn, checkOut: self.checkOut)
        } else if !differentDates {
            showErrorMessage(message: NSLocalizedString("select_different_dates", comment: ""))
        } else if !monthApart {
            showErrorMessage(message: NSLocalizedString("book_at_least_a_month", comment: ""))
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
