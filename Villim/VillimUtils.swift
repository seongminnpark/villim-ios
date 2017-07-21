//
//  VillimUtils.swift
//  Villim
//
//  Created by Seongmin Park on 7/17/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation
import UIKit

class VillimUtils {
    public static let themeColor = UIColor(red: 237.0/255.0, green: 32.0/255.0, blue: 37.0/255.0, alpha:1.0)
    public static let themeColorHighlighted = UIColor(red: 139.0/255.0, green: 0/255.0, blue: 0/255.0, alpha:1.0)
    public static let loadingIndicatorSize : CGFloat = 150.0
    
    public static func buildURL(endpoint:String) -> String {
        return VillimKeys.SERVER_SCHEME + "://" + VillimKeys.SERVER_HOST + "/" + endpoint
    }
    
    public static func dateFromString(dateString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)!
    }
    
    public static func dateToString(date:Date) -> String {
        return date.description
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
}
