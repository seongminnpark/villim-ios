//
//  Villimself.swift
//  Villim
//
//  Created by Seongmin Park on 7/16/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation
import SwiftyJSON

class VillimUser {
    public var userId : Int
    public var fullname : String
    public var firstname : String
    public var lastname : String
    public var email : String
    public var profilePicUrl : String?
    public var about : String
    
    public var sex : Int
    public var phoneNumber : String
    public var cityOfResidence : String
    public var pushNotifications : Bool
    public var currencyPref : Int
    public var languagePref : Int
    
    public var houseIdConfirmed : [Int]
    public var houseIdStaying : Int?
    public var houseIdDone : [Int]
    
    public var visitHouseIdPending : [Int]
    public var visitHouseIdConfirmed : [Int]
    public var visitHouseIdDone : [Int]
    
    init(userInfo:SwiftyJSON.JSON) {
        /* No need to null check here because if we dont set it, it's going to be null anyway */
        self.userId                = userInfo[VillimKeys.KEY_USER_ID].intValue
        self.fullname              = userInfo[VillimKeys.KEY_FULLNAME].stringValue
        self.firstname             = userInfo[VillimKeys.KEY_FIRSTNAME].stringValue
        self.lastname              = userInfo[VillimKeys.KEY_LASTNAME].stringValue
        self.email                 = userInfo[VillimKeys.KEY_EMAIL].stringValue
        let hasPofilePicUrl : Bool = userInfo[VillimKeys.KEY_PROFILE_PIC_URL].string != "null"
        self.profilePicUrl         = hasPofilePicUrl ? userInfo[VillimKeys.KEY_PROFILE_PIC_URL].stringValue : nil
        self.about                 = userInfo[VillimKeys.KEY_ABOUT].stringValue
        self.sex                   = userInfo[VillimKeys.KEY_SEX].intValue
        self.phoneNumber           = userInfo[VillimKeys.KEY_PHONE_NUMBER].stringValue
        self.cityOfResidence       = userInfo[VillimKeys.KEY_CITY_OF_RESIDENCE].stringValue
        self.pushNotifications     = userInfo[VillimKeys.KEY_PUSH_NOTIFICATIONS].boolValue
        self.currencyPref          = userInfo[VillimKeys.KEY_PREFERENCE_CURRENCY].intValue
        self.languagePref          = userInfo[VillimKeys.KEY_PREFERENCE_LANGUAGE].intValue
        self.houseIdConfirmed      = userInfo[VillimKeys.KEY_HOUSE_ID_CONFIRMED].arrayValue.map{$0.intValue}
        let hasStaying : Bool      = userInfo[VillimKeys.KEY_HOUSE_ID_STAYING].string != "null"
        self.houseIdStaying        = hasStaying ? userInfo[VillimKeys.KEY_HOUSE_ID_STAYING].intValue : nil
        self.houseIdDone           = userInfo[VillimKeys.KEY_HOUSE_ID_DONE].arrayValue.map{$0.intValue}
        self.visitHouseIdPending = userInfo[VillimKeys.KEY_VISIT_HOUSE_ID_PENDING].arrayValue.map{$0.intValue}
        self.visitHouseIdConfirmed = userInfo[VillimKeys.KEY_VISIT_HOUSE_ID_CONFIRMED].arrayValue.map{$0.intValue}
        self.visitHouseIdDone      = userInfo[VillimKeys.KEY_VISIT_HOUSE_ID_DONE].arrayValue.map{$0.intValue}
    }
}
