//
//  VillimSession.swift
//  Villim
//
//  Created by Seongmin Park on 7/15/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation

class VillimSession {
    
    private static let KEY_LOGGED_IN = "logged_in";
    
    private static let defaults = UserDefaults.standard
    
    /* Logged in */
    public static func setLoggedIn(loggedIn:Bool) {
    
        if (!loggedIn) {
            /* Clear user defaults */
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
            
            defaults.set(loggedIn, forKey: KEY_LOGGED_IN)
        }
    }
    
    public static func getLoggedIn() -> Bool {
        return defaults.bool(forKey: KEY_LOGGED_IN)
    }

    /* Id */
    public static func setUserId(id:Int) {
        defaults.set(id, forKey: VillimKeys.KEY_USER_ID)
    }
    
    public static func getUserId() -> Int {
        return defaults.integer(forKey: VillimKeys.KEY_USER_ID)
    }
    
    
    /* Fullname */
    public static func setFullName(fullname:String) {
        defaults.set(fullname, forKey: VillimKeys.KEY_FULLNAME)
    }
    
    public static func getFullName() -> String {
        return defaults.string(forKey: VillimKeys.KEY_FULLNAME)!
    }
    
    /* Firstname */
    public static func setFirstName(firstname:String) {
        defaults.set(firstname, forKey: VillimKeys.KEY_FIRSTNAME)
    }
    
    public static func getFirstName() -> String {
        return defaults.string(forKey: VillimKeys.KEY_FIRSTNAME)!
    }
    
    /* Lastname */
    public static func setLastName(lastName:String) {
        defaults.set(lastName, forKey: VillimKeys.KEY_LASTNAME)
    }
    
    public static func getLastName() -> String {
        return defaults.string(forKey: VillimKeys.KEY_LASTNAME)!
    }
    
    /* Email */
    public static func setEmail(email:String) {
        defaults.set(email, forKey: VillimKeys.KEY_EMAIL)
    }
    
    public static func getEmail() -> String {
        return defaults.string(forKey: VillimKeys.KEY_EMAIL)!
    }
    
    /* Profile pic url */
    public static func setProfilePicUrl(url:String?) {
        defaults.set(url, forKey: VillimKeys.KEY_PROFILE_PIC_URL)
    }
    
    public static func getProfilePicUrl() -> String {
        return defaults.string(forKey: VillimKeys.KEY_PROFILE_PIC_URL)!
    }
    
    /* Push Notifications */
    public static func setPushPref(pushPref:Bool) {
        defaults.set(pushPref, forKey: VillimKeys.KEY_PUSH_NOTIFICATIONS)
    }
    
    public static func getPushPref() -> Bool {
        return defaults.bool(forKey: VillimKeys.KEY_PUSH_NOTIFICATIONS)
    }
    
    /* Currency */
    public static func setCurrencyPref(currencyPref:Int) {
         defaults.set(currencyPref, forKey: VillimKeys.KEY_PREFERENCE_CURRENCY)
    }
    
    public static func getCurrencyPref() -> Int {
        return defaults.integer(forKey: VillimKeys.KEY_PREFERENCE_CURRENCY)
    }
    
    /* Language */
    public static func setLanguagePref(languagePref:Int) {
        defaults.set(languagePref, forKey: VillimKeys.KEY_PREFERENCE_LANGUAGE)
    }
    
    public static func getLanguagePref() -> Int {
        return defaults.integer(forKey: VillimKeys.KEY_PREFERENCE_LANGUAGE)
    }
    
    /* Sex */
    public static func setSex(sex:Int) {
        defaults.set(sex, forKey: VillimKeys.KEY_SEX)
    }
    
    public static func getSex() -> Int {
        return defaults.integer(forKey: VillimKeys.KEY_SEX)
    }
    
    /* Phone number */
    public static func setPhoneNumber(phoneNumber:String) {
        defaults.set(phoneNumber, forKey: VillimKeys.KEY_PHONE_NUMBER)
    }
    
    public static func getPhoneNumber() -> String {
        return defaults.string(forKey: VillimKeys.KEY_PHONE_NUMBER)!
    }
    
    /* City of residence */
    public static func setCityOfResidence(city:String) {
        defaults.set(city, forKey: VillimKeys.KEY_CITY_OF_RESIDENCE)
    }
    
    public static func getCityOfResidence() -> String {
        return defaults.string(forKey: VillimKeys.KEY_CITY_OF_RESIDENCE)!
    }
    
    /* House id confirmed */
    public static func setHouseIdConfirmed(houseIdArray:[Int]) {
        defaults.set(houseIdArray, forKey: VillimKeys.KEY_HOUSE_ID_CONFIRMED)
    }
    
    public static func getHosueIdConfirmed() -> [Int] {
        return defaults.array(forKey: VillimKeys.KEY_HOUSE_ID_CONFIRMED)! as! [Int]
    }
    
    /* House id staying */
    public static func setHouseIdStaying(id:Int?) {
        defaults.set(id, forKey: VillimKeys.KEY_HOUSE_ID_STAYING)
    }
    
    public static func getHouseIdStaying() -> Int {
        return defaults.integer(forKey: VillimKeys.KEY_HOUSE_ID_STAYING)
    }
    
    /* House id done */
    public static func setHouseIdDone(houseIdArray:[Int]) {
        defaults.set(houseIdArray, forKey: VillimKeys.KEY_HOUSE_ID_DONE)
    }
    
    public static func getHosueIdDone() -> [Int] {
        return defaults.array(forKey: VillimKeys.KEY_HOUSE_ID_DONE) as! [Int]
    }
    
    /* Visit house id pending */
    public static func setVisitHouseIdPending(houseIdArray:[Int]) {
        defaults.set(houseIdArray, forKey: VillimKeys.KEY_VISIT_HOUSE_ID_PENDING)
    }
    
    public static func getVisitHosueIdPending() -> [Int] {
         return defaults.array(forKey: VillimKeys.KEY_VISIT_HOUSE_ID_PENDING) as! [Int]
    }
    
    /* Visit house id confirmed */
    public static func setVisitHouseIdConfirmed(houseIdArray:[Int]) {
        defaults.set(houseIdArray, forKey: VillimKeys.KEY_VISIT_HOUSE_ID_CONFIRMED)
    }
    
    public static func getVisitHosueIdConfirmed() -> [Int] {
        return defaults.array(forKey: VillimKeys.KEY_VISIT_HOUSE_ID_CONFIRMED) as! [Int]
    }
    
    /* Visit House id done */
    public static func setVisitHouseIdDone(houseIdArray:[Int]) {
        defaults.set(houseIdArray, forKey: VillimKeys.KEY_VISIT_HOUSE_ID_DONE)
    }
    
    public static func getVisitHouseIdDone() -> [Int] {
        return defaults.array(forKey: VillimKeys.KEY_VISIT_HOUSE_ID_DONE) as! [Int]
    }
    
    /* Profile pic path */
    public static func setLocalStoreProfilePicturePath(path:String) {
        defaults.set(path, forKey: VillimKeys.KEY_LOCAL_STORE_PROFILE_PICTURE)
    }
    
    public static func getLocalStoreProfilePicturePath() -> String {
        return defaults.string(forKey: VillimKeys.KEY_LOCAL_STORE_PROFILE_PICTURE)!
    }
    
//    public static func getLocalStoreProfilePictureFile() -> Fil {
//        return null;
//    }
//    
    
    public static func updateUserSession(user:VillimUser) {
        setUserId(id: user.userId)
        setFullName(fullname: user.fullname)
        setFirstName(firstname: user.firstname)
        setLastName(lastName: user.lastname)
        setEmail(email: user.email)
        setProfilePicUrl(url: user.profilePicUrl)
        setPushPref(pushPref: user.pushNotifications)
        setCurrencyPref(currencyPref: user.currencyPref)
        setLanguagePref(languagePref: user.languagePref)
        setSex(sex: user.sex)
        setPhoneNumber(phoneNumber: user.phoneNumber)
        setCityOfResidence(city: user.cityOfResidence)
        setHouseIdConfirmed(houseIdArray: user.houseIdConfirmed)
        setHouseIdStaying(id: user.houseIdStaying)
        setHouseIdDone(houseIdArray: user.houseIdDone)
        setVisitHouseIdPending(houseIdArray: user.visitHouseIdPending)
        setVisitHouseIdConfirmed(houseIdArray: user.visitHouseIdConfirmed)
        setVisitHouseIdDone(houseIdArray: user.visitHouseIdDone)
        defaults.synchronize()
    }
    
}
