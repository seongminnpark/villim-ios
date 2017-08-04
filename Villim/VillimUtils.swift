//
//  VillimUtils.swift
//  Villim
//
//  Created by Seongmin Park on 7/17/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

class VillimUtils {
    
    public static func buildURL(endpoint:String) -> String {
        return VillimKeys.SERVER_SCHEME + "://" + VillimKeys.SERVER_HOST + "/" + endpoint
    }
    
    public static func dateFromString(dateString:String) -> DateInRegion {

        var date = DateInRegion(string: dateString, format: .custom("yyyy-MM-dd"))
        
        if date == nil {
            date = DateInRegion(string: dateString, format: .custom("yyyy-MM-dd HH:mm:ss"))
        }
        
        return date!
    }
    
    public static func dateToString(date:DateInRegion) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = NSLocalizedString("date_format", comment: "")
        return formatter.string(from: date.absoluteDate)
    }
    
    public static func datesBetween(startDate:DateInRegion, endDate:DateInRegion, includeEdges:Bool) -> [DateInRegion] {
        var currDate = startDate;
        
        var dates = [DateInRegion]();
        
        if includeEdges { dates.append(startDate) }
        
        while currDate < endDate {
            dates.append(currDate)
            currDate = currDate + 1.day
        }
        
        if includeEdges { dates.append(endDate) }
        
        return dates;
    }
    
    public static func weekdayToString(weekday:Int) -> String {
        switch weekday {
        case 0:
            return NSLocalizedString("monday", comment: "")
        case 1:
            return NSLocalizedString("tuesday", comment: "")
        case 2:
            return NSLocalizedString("wednesday", comment: "")
        case 3:
            return NSLocalizedString("thursday", comment: "")
        case 4:
            return NSLocalizedString("friday", comment: "")
        case 5:
            return NSLocalizedString("saturday", comment: "")
        case 6:
            return NSLocalizedString("sunday", comment: "")
        default:
            return NSLocalizedString("monday", comment: "")
        }
    }
    
    public static func currencyToString(code:Int, full:Bool) -> String {
        switch code {
        case 0: return  full ? "KRW (₩)" : "₩"
        case 1: return  full ? "USD ($)" : "$"
        default: return full ? "KRW (₩)" : "W"
        }
    }
 
    public static func getCurrencyString(price:Int) -> String{
        let currencyCode = VillimSession.getLoggedIn() ? VillimSession.getCurrencyPref() : 0
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:price))
        
        return String(format:NSLocalizedString("currency_format", comment: ""),
                      VillimUtils.currencyToString(code: currencyCode, full: false), formattedNumber!)
    }
    
    public static func getRentString(rent:Int) -> String {
        let currencyCode = VillimSession.getLoggedIn() ? VillimSession.getCurrencyPref() : 0
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:rent))
        
        return String(format:NSLocalizedString("monthly_rent_format", comment: ""),
                      VillimUtils.currencyToString(code: currencyCode, full: false), formattedNumber!)
    }
    
    // Calculates and returns (base price, utitlity) in a tuple.
    public static func calculatePrice(checkIn:DateInRegion, checkOut:DateInRegion, rent:Int) -> (Int, Int) {
        let TWENTY    : Float = 0.2;
        let FIFTEEN   : Float = 0.15;
        
        let dailyRent : Float = Float(rent) / 30.0
        
        var base      : Int = 0
        var util      : Float = 0
        
        /* Start counting from start date. */
        var currDate : DateInRegion = checkIn
        let endDate  : DateInRegion = checkOut
        var nextDate : DateInRegion = currDate + 1.month

        
        /* Count until we go over end date. */
        while (nextDate < endDate) {
            
            nextDate = currDate
            nextDate = nextDate + 1.month
            
            /* Base price */
            base += rent;
            
            /* Utility fees */
            let currUtilityRate : Float = isLowUtility(date: currDate) ? FIFTEEN : TWENTY
            let nextUtilityRate : Float = isLowUtility(date: nextDate) ? FIFTEEN : TWENTY
        
            if (currUtilityRate != nextUtilityRate) {
                
                let currUtilityFee : Float = Float(daysUntilEndOfMonth(date: currDate)) * dailyRent * currUtilityRate
                let nextUtilityFee : Float = Float(daysFromStartOfMonth(date: currDate)) * dailyRent * nextUtilityRate
                
                util += currUtilityFee;
                util += nextUtilityFee;
                
            } else {
                util += Float(rent) * currUtilityRate
            }
            
            /* Go to next month */
            currDate = currDate + 1.month
        }
        
        /* Calculate daily rent */
        let days : Int = (endDate - currDate).in(.day)!
        if (days > 0) {
            base += Int(Float(days) * dailyRent)
        }
        
        return (base, Int(util))
    }
    
    
    private static func isLowUtility(date:DateInRegion) -> Bool {
        return date.month == 3  ||
               date.month == 4  ||
               date.month == 5  ||
               date.month == 9  ||
               date.month == 10 ||
               date.month == 11
    }
    
    private static func daysUntilEndOfMonth(date:DateInRegion) -> Int {
        var endDate : Int
        switch date.month {
        case 1, 3, 5, 7, 8, 10, 12:
            endDate = 31
            break
        case 4, 6, 9, 11:
            endDate = 30
            break
        case 2:
            endDate = 28
            break
        default:
            endDate = 31
            break
        }
        return endDate - date.day
    }
    
    private static func daysFromStartOfMonth(date:DateInRegion) -> Int {
        return date.day - 1;
    }
}
