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

    init(hosueInfo:SwiftyJSON.JSON) {
        self.houseId = hosueInfo[VillimKeys.KEY_HOUSE_ID].intValue
        self.houseName = hosueInfo[VillimKeys.KEY_HOUSE_NAME].stringValue
        self.addrFull = hosueInfo[VillimKeys.KEY_ADDR_FULL].stringValue
        self.addrSummary = hosueInfo[VillimKeys.KEY_ADDR_FULL].stringValue
        self.addrDirection = hosueInfo[VillimKeys.KEY_ADDR_DIRECTION].stringValue
        self.description = hosueInfo[VillimKeys.KEY_DESCRIPTION].stringValue
        self.houseType = hosueInfo[VillimKeys.KEY_HOUSE_TYPE].intValue
        self.numGuest = hosueInfo[VillimKeys.KEY_NUM_GUEST].intValue
        self.numBedroom = hosueInfo[VillimKeys.KEY_NUM_BEDROOM].intValue
        self.numBed = hosueInfo[VillimKeys.KEY_NUM_BED].intValue
        self.numBathroom = hosueInfo[VillimKeys.KEY_NUM_BATHROOM].intValue
        self.ratePerMonth = hosueInfo[VillimKeys.KEY_RATE_PER_MONTH].intValue
        self.ratePerNight = hosueInfo[VillimKeys.KEY_RATE_PER_NIGHT].intValue
        self.utilityFee = hosueInfo[VillimKeys.KEY_UTILITY_FEE].intValue
        self.cleaningFee = hosueInfo[VillimKeys.KEY_CLEANING_FEE].intValue
        self.latitude = hosueInfo[VillimKeys.KEY_LATITUDE].doubleValue
        self.longitude = hosueInfo[VillimKeys.KEY_LONGITUDE].doubleValue
        self.housePolicy = hosueInfo[VillimKeys.KEY_HOUSE_POLICY].stringValue
        self.cancellationPolicy = hosueInfo[VillimKeys.KEY_CANCELLATION_POLICY].stringValue
        
        self.hostId = hosueInfo[VillimKeys.KEY_HOST_ID].intValue
        self.hostName = hosueInfo[VillimKeys.KEY_HOST_NAME].stringValue
        self.hostRating = hosueInfo[VillimKeys.KEY_HOST_RATING].floatValue
        self.hostReviewCount = hosueInfo[VillimKeys.KEY_HOST_REVIEW_COUNT].intValue
        self.hostProfilePicUrl = hosueInfo[VillimKeys.KEY_HOST_PROFILE_PIC_URL].stringValue
        self.houseRating = hosueInfo[VillimKeys.KEY_HOUSE_RATING].floatValue
        self.houseReviewCount = hosueInfo[VillimKeys.KEY_HOUSE_REVIEW_COUNT].intValue
        
        self.houseThumbnailUrl = hosueInfo[VillimKeys.KEY_HOUSE_THUMBNAIL_URL].stringValue
        self.amenityIds = hosueInfo[VillimKeys.KEY_AMENITY_IDS].arrayValue.map{ $0.intValue }
        self.housePicUrls = hosueInfo[VillimKeys.KEY_HOUSE_PIC_URLS].arrayValue.map{ $0.stringValue }
    
        let reservationArray = hosueInfo[VillimKeys.KEY_RESERVATIONS].array
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

    
    
    public func getInvalidDates() -> [Date] {
    
        var dates = [Date]()
    
        for reservation in self.reservations {
            let reservedDates = VillimUtils.datesBetween(startDate: reservation.startDate, endDate: reservation.endDate, includeEdges: true);
            dates.append(contentsOf:reservedDates)
        }
    
        return dates
    }
}
