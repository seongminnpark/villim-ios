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
    
    public static func dateFromString(dateString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = NSLocalizedString("date_format", comment: "")
        return dateFormatter.date(from: dateString)!
    }
    
    public static func dateToString(date:DateInRegion) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = NSLocalizedString("date_format", comment: "")
        return formatter.string(from: date.absoluteDate)
    }
    
    public static func datesBetween(startDate:Date, endDate:Date, includeEdges:Bool) -> [Date] {
        var currDate = startDate;
        
        var dates = [Date]();
        
        if includeEdges { dates.append(startDate) }
        
        while currDate < endDate {
            dates.append(currDate)
            currDate = Calendar.current.date(byAdding: .day, value: 1, to: currDate)!
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
    
}
