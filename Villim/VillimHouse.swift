//
//  Villimself.swift
//  Villim
//
//  Created by Seongmin Park on 7/21/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation
import SwiftyJSON

class VillimHouse {

    var houseId : Int
    var houseName : String
    var addrFull : String
    var addrSummary : String
    var addrDirection : String
    var description : String
    var numGuest : Int
    var numBedroom : Int
    var numBed : Int
    var numBathroom : Int
    var ratePerMonth : Int
    var ratePerNight : Int
    var utilityFee : Int
    var cleaningFee : Int
    var latitude : Double
    var longitude : Double
    var housePolicy : String
    var cancellationPolicy : String
    var hostId : Int
    var hostName : String
    var hostRating : Float
    var hostReviewCount : Int
    var hostProfilePicUrl : String
    var houseRating : Float
    var houseReviewCount : Int
    var amenityIds : [Int]
    var houseThumbnailUrl : String
    var housePicUrls : [String]
    var houseType : Int
    var reservations : [VillimReservation]
    
//    private var lockAddr : Int
//    private var lockPc : Int

    init(houseInfo:SwiftyJSON.JSON) {
        self.houseId = houseInfo[VillimKeys.KEY_HOUSE_ID].exists() ? houseInfo[VillimKeys.KEY_HOUSE_ID].intValue : 0
        self.houseName = houseInfo[VillimKeys.KEY_HOUSE_NAME].exists() ? houseInfo[VillimKeys.KEY_HOUSE_NAME].stringValue : ""
        self.addrFull = houseInfo[VillimKeys.KEY_ADDR_FULL].exists() ? houseInfo[VillimKeys.KEY_ADDR_FULL].stringValue : ""
        self.addrSummary = houseInfo[VillimKeys.KEY_ADDR_SUMMARY].exists() ? houseInfo[VillimKeys.KEY_ADDR_SUMMARY].stringValue : ""
        self.addrDirection = houseInfo[VillimKeys.KEY_ADDR_DIRECTION].exists() ? houseInfo[VillimKeys.KEY_ADDR_DIRECTION].stringValue : ""
        self.description = houseInfo[VillimKeys.KEY_DESCRIPTION].exists() ? houseInfo[VillimKeys.KEY_DESCRIPTION].stringValue : ""
        self.houseType = houseInfo[VillimKeys.KEY_HOUSE_TYPE].exists() ? houseInfo[VillimKeys.KEY_HOUSE_TYPE].intValue : 0
        self.numGuest = houseInfo[VillimKeys.KEY_NUM_GUEST].exists() ? houseInfo[VillimKeys.KEY_NUM_GUEST].intValue : 0
        self.numBedroom = houseInfo[VillimKeys.KEY_NUM_BEDROOM].exists() ? houseInfo[VillimKeys.KEY_NUM_BEDROOM].intValue : 0
        self.numBed = houseInfo[VillimKeys.KEY_NUM_BED].exists() ? houseInfo[VillimKeys.KEY_NUM_BED].intValue : 0
        self.numBathroom = houseInfo[VillimKeys.KEY_NUM_BATHROOM].exists() ? houseInfo[VillimKeys.KEY_NUM_BATHROOM].intValue : 0
        self.ratePerMonth = houseInfo[VillimKeys.KEY_RATE_PER_MONTH].exists() ? houseInfo[VillimKeys.KEY_RATE_PER_MONTH].intValue : 0
        self.ratePerNight = houseInfo[VillimKeys.KEY_RATE_PER_NIGHT].exists() ? houseInfo[VillimKeys.KEY_RATE_PER_NIGHT].intValue : 0
        self.utilityFee = houseInfo[VillimKeys.KEY_UTILITY_FEE].exists() ? houseInfo[VillimKeys.KEY_UTILITY_FEE].intValue : 0
        self.cleaningFee = houseInfo[VillimKeys.KEY_CLEANING_FEE].exists() ? houseInfo[VillimKeys.KEY_CLEANING_FEE].intValue : 0
        self.latitude = houseInfo[VillimKeys.KEY_LATITUDE].exists() ? houseInfo[VillimKeys.KEY_LATITUDE].doubleValue : 0.0
        self.longitude = houseInfo[VillimKeys.KEY_LONGITUDE].exists() ? houseInfo[VillimKeys.KEY_LONGITUDE].doubleValue : 0.0
        self.housePolicy = houseInfo[VillimKeys.KEY_HOUSE_POLICY].exists() ? houseInfo[VillimKeys.KEY_HOUSE_POLICY].stringValue : ""
        self.cancellationPolicy = houseInfo[VillimKeys.KEY_CANCELLATION_POLICY].exists() ? houseInfo[VillimKeys.KEY_CANCELLATION_POLICY].stringValue : ""
        
        self.hostId = houseInfo[VillimKeys.KEY_HOST_ID].exists() ? houseInfo[VillimKeys.KEY_HOST_ID].intValue : 0
        self.hostName = houseInfo[VillimKeys.KEY_HOST_NAME].exists() ? houseInfo[VillimKeys.KEY_HOST_NAME].stringValue : ""
        self.hostRating = houseInfo[VillimKeys.KEY_HOST_RATING].exists() ? houseInfo[VillimKeys.KEY_HOST_RATING].floatValue : 0.0
        self.hostReviewCount = houseInfo[VillimKeys.KEY_HOST_REVIEW_COUNT].exists() ? houseInfo[VillimKeys.KEY_HOST_REVIEW_COUNT].intValue : 0
        self.hostProfilePicUrl = houseInfo[VillimKeys.KEY_HOST_PROFILE_PIC_URL].exists() ? houseInfo[VillimKeys.KEY_HOST_PROFILE_PIC_URL].stringValue : ""
        self.houseRating = houseInfo[VillimKeys.KEY_HOUSE_RATING].exists() ? houseInfo[VillimKeys.KEY_HOUSE_RATING].floatValue : 0.0
        self.houseReviewCount = houseInfo[VillimKeys.KEY_HOUSE_REVIEW_COUNT].exists() ? houseInfo[VillimKeys.KEY_HOUSE_REVIEW_COUNT].intValue : 0
        
        self.houseThumbnailUrl = houseInfo[VillimKeys.KEY_HOUSE_THUMBNAIL_URL].exists() ? houseInfo[VillimKeys.KEY_HOUSE_THUMBNAIL_URL].stringValue : ""
        self.amenityIds = houseInfo[VillimKeys.KEY_AMENITY_IDS].exists() ? houseInfo[VillimKeys.KEY_AMENITY_IDS].arrayValue.map{ $0.intValue } : []
        self.housePicUrls = houseInfo[VillimKeys.KEY_HOUSE_PIC_URLS].exists() ? houseInfo[VillimKeys.KEY_HOUSE_PIC_URLS].arrayValue.map{ $0.stringValue } : []
    
        let reservationArray = houseInfo[VillimKeys.KEY_HOUSE_ID].exists() ? houseInfo[VillimKeys.KEY_RESERVATIONS].array : nil
        if (reservationArray != nil) {
            self.reservations = [VillimReservation]()
            for reservationInfo in reservationArray! {
                
                let reservation = VillimReservation();
                reservation.startDate = VillimUtils.dateFromString(dateString: reservationInfo[VillimKeys.KEY_CHECKIN].stringValue)
                reservation.endDate = VillimUtils.dateFromString(dateString: reservationInfo[VillimKeys.KEY_CHECKOUT].stringValue)
                self.reservations.append(reservation)
                
            }
        } else {
            self.reservations = [VillimReservation]()

        }
        
//        self.lockAddr = jsonObject.optInt(KEY_LOCK_ADDR);
//        self.lockPc = jsonObject.optInt(KEY_LOCK_PC);
    }

    public static func getFeaturedHouseArray(jsonHouses:[JSON]) -> [VillimHouse] {
        var houses : [VillimHouse] = []
        
        for jsonHouse in jsonHouses {
            houses.append(VillimHouse(houseInfo: jsonHouse))
        }
        
        return houses
    }
    
    public func getInvalidDates() -> [Date] {
    
        var dates = [Date]()
    
        for reservation in self.reservations {
            let reservedDates = VillimUtils.datesBetween(startDate: reservation.startDate, endDate: reservation.endDate, includeEdges: true);
            dates.append(contentsOf:reservedDates)
        }
    
        return dates
    }
}
