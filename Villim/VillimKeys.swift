//
//  VillimKeys.swift
//  Villim
//
//  Created by Seongmin Park on 7/15/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation

class VillimKeys {
    /* Version Info */
    static let APP_VERSION = "0.8.1";
    
    /* Server constants */
    static let SERVER_SCHEME = "http";
    static let  SERVER_HOST = "175.207.29.19";
    
    /* URLS */
    static let LOGIN_URL = "a/login";
    static let SIGNUP_URL = "a/signup";
    static let CHANGE_PASSCODE_URL = "a/change-passcode";
    static let MY_HOUSE_URL = "a/my-house";
    static let OPEN_DOORLOCK_URL = "a/open-doorlock";
    static let RESERVE_URL = "a/reserve-house";
    static let FEATURED_HOUSES_URL = "a/featured-houses";
    static let HOST_INFO_URL = "a/host-info";
    static let HOUSE_INFO_URL = "a/house-info";
    static let HOUSE_REVIEW_URL = "a/house-reviews";
    static let VISIT_LIST_URL = "a/visit-list";
    static let VISIT_INFO_URL = "a/visit-info";
    static let POST_REVIEW_URL = "a/post-review";
    static let FIND_PASSWORD_URL = "a/find-password";
    static let VISIT_REQUEST_URL = "a/visit-request";
    static let CANCEL_VISIT_URL = "a/cancel-visit";
    static let SEND_VERIFICATION_PHONE_URL = "send-verification-phone";
    static let VERIFY_PHONE_URL = "verify-phone";
    static let SEARCH_URL = "s";
    static let TERMS_OF_SERVICE_URL = "https://www.klondikebar.com/";
    static let UPDATE_PROFILE_URL = "a/update-profile";
    static let FAQ_URL = "https://boo7387.wixsite.com/villim01/faq";
    
    /* Request success codes */
    static let KEY_QUERY_SUCCESS = "query_success";
    
    /* Activity request codes */
    
    
    /* Intent data keys */
    static let KEY_USER = "user";
    
    /* My Key Activity */
    static let KEY_RESERVATION_ACTIVE = "reservation_active";
    
    /* User info */
    static let KEY_LOGIN_SUCCESS = "login_success";
    static let KEY_USER_INFO = "user_info";
    static let KEY_USER_ID = "user_id";
    static let KEY_FULLNAME = "fullname";
    static let KEY_EMAIL = "email";
    static let KEY_PASSWORD = "password";
    static let KEY_PROFILE_PIC_URL = "profile_pic_url";
    static let KEY_ABOUT = "about";
    static let KEY_USER_STATUS = "user_status";
    static let KEY_PUSH_NOTIFICATIONS = "push_notifications";
    static let KEY_PREFERENCE_CURRENCY = "curr";
    static let KEY_PREFERENCE_LANGUAGE = "preferred_language";
    static let KEY_SEX = "sex";
    static let KEY_PHONE_NUMBER = "phone_number";
    static let KEY_CITY_OF_RESIDENCE = "city_of_residence";
    static let KEY_PROFILE_PIC = "profile_pic";
    static let KEY_HOUSE_ID_CONFIRMED = "house_id_confirmed";
    static let KEY_HOUSE_ID_STAYING = "house_id_staying";
    static let KEY_HOUSE_ID_DONE = "house_id_done";
    static let KEY_VISIT_HOUSE_ID_PENDING = "visit_hosue_id_confirmes";
    static let KEY_VISIT_HOUSE_ID_CONFIRMED = "visit_hosue_id_pending";
    static let KEY_VISIT_HOUSE_ID_DONE = "visit_house_id_done";
    static let KEY_HOUSE_TYPE = "house_type";
    
    /* Login Keys */
    static let KEY_MESSAGE = "message";
    
    /* Signup Keys */
    static let KEY_SIGNUP_SUCCESS = "signup_success";
    static let KEY_FIRSTNAME = "firstname";
    static let KEY_LASTNAME = "lastname";
    
    /* House Info */
    static let KEY_HOUSE_INFO = "house_info";
    static let KEY_HOUSE_ID = "house_id";
    static let KEY_HOUSE_NAME = "house_name";
    static let KEY_ADDR_FULL = "addr_full";
    static let KEY_ADDR_SUMMARY = "addr_summary";
    static let KEY_ADDR_DIRECTION = "addr_direction";
    static let KEY_DESCRIPTION = "description";
    static let KEY_NUM_GUEST = "num_guest";
    static let KEY_NUM_BEDROOM = "num_bedroom";
    static let KEY_NUM_BED = "num_bed";
    static let KEY_NUM_BATHROOM = "num_bathroom";
    
    static let KEY_RATE_PER_MONTH = "rate_per_month";
    static let KEY_RATE_PER_NIGHT = "rate_per_night";
    static let KEY_DEPOSIT = "deposit";
    static let KEY_ADDITIONAL_GUEST_FEE = "additional_guest_fee";
    static let KEY_UTILITY_FEE = "utility_fee";
    static let KEY_CLEANING_FEE = "cleaning_fee";
    
    static let KEY_LOCK_ADDR = "lock_addr";
    static let KEY_LOCK_PC = "lock_pw";
    static let KEY_HIT = "hit";
    static let KEY_LATITUDE = "latitude";
    static let KEY_LONGITUDE = "longitude";
    static let KEY_STATUS = "status";
    static let KEY_CREATED = "created";
    static let KEY_MODIFIED = "modified";
    static let KEY_HOUSE_POLICY = "house_policy";
    static let KEY_CANCELLATION_POLICY = "refund_policy";
    
    static let KEY_HOST_ID = "host_id";
    static let KEY_HOST_NAME = "host_name";
    static let KEY_HOST_RATING = "host_rating";
    static let KEY_HOST_REVIEW_COUNT = "host_review_count";
    static let KEY_HOST_PROFILE_PIC_URL = "host_profile_pic_url";
    static let KEY_HOUSE_RATING = "house_rating";
    static let KEY_HOUSE_REVIEW_COUNT = "house_review_count";
    static let KEY_HOUSE_THUMBNAIL_URL = "house_thumbnail_url";
    static let KEY_AMENITY_IDS = "amenity_ids";
    static let KEY_HOUSE_PIC_URLS = "house_pic_urls";
    
    static let KEY_REVIEW_LAST_CONTENT = "review_last_content";
    static let KEY_REVIEW_LAST_REVIEWER = "review_last_reviewer";
    static let KEY_REVIEW_LAST_RATING = "review_last_rating";
    static let KEY_REVIEW_LAST_PROFILE_PIC_URL = "review_last_profile_pic_url";
    
    static let KEY_RESERVATIONS = "reservations";
    
    /* Review info keys */
    static let KEY_REVIEWS = "reviews";
    static let KEY_REVIEW_COUNT = "review_count";
    static let KEY_REVIEWER_ID = "reviewer_id";
    static let KEY_RESERVATION_ID = "reservation_id";
    static let KEY_REVIEWER_NAME = "reviewer_name";
    static let KEY_REVIEW_CONTENT = "review_content";
    static let KEY_REVIEWER_PROFILE_PIC_URL = "reviewer_profile_pic_url";
    static let KEY_REVIEW_DATE = "review_date";
    static let KEY_RATING_OVERALL = "rating_overall";
    static let KEY_RATING_ACCURACY = "rating_accuracy";
    static let KEY_RATING_COMMUNICATION = "rating_communication";
    static let KEY_RATING_CLEANLINESS = "rating_cleanliness";
    static let KEY_RATING_LOCATION = "rating_location";
    static let KEY_RATING_CHECKIN = "rating_checkin";
    static let KEY_RATING_VALUE = "rating_value";
    
    /* Reservation keys */
    static let KEY_RESERVATION_SUCCESS = "reservation_success";
    static let KEY_RESERVATION_INFO = "reservation_info";
    static let KEY_GUEST_ID = "guest_id";
    static let KEY_CHECKIN = "checkin";
    static let KEY_CHECKOUT = "checkout";
    static let KEY_RESERVATION_TIME = "reservation_time";
    static let KEY_RESERVATION_STATUS = "reservation_status";
    static let KEY_RESERVATION_CODE = "reservation_code";
    
    /* Featured list */
    static let KEY_HOUSES = "houses";
    
    /* Visit list */
    static let KEY_VISITS = "visits";
    static let KEY_VISIT_ID = "visit_id";
    static let KEY_VISITOR_ID = "visitor_id";
    static let KEY_VISIT_TIME = "visit_time";
    static let KEY_VISIT_STATUS = "visit_status";
    static let KEY_VISIT_INFO = "visit_info";
    static let KEY_PENDING_VISITS = "pending_visits";
    static let KEY_CONFIRMED_VISITS = "confirmed_visits";
    
    /* DoorlockPAsscodeActivity */
    static let KEY_CHANGE_SUCCESS = "change_success";
    static let KEY_PASSCODE = "passcode";
    static let KEY_PASSCODE_CONFIRM = "passcode_confirm";
    
    /* Doorlock Open */
    static let KEY_OPEN_AUTHORIZED = "open_authorized";
    static let KEY_OPEN_SUCESS = "open_success";
    
    /* Review Activity */
    static let KEY_POST_SUCCESS = "post_success";
    
    /* Visit Detail Activity */
    static let KEY_CANCEL_SUCCESS = "cancel_success";
    
    /* Profile Edit Activity */
    static let KEY_UPDATE_SUCCESS = "update";
    
    /* Success code */
    static let KEY_SUCCESS = "success";
    
    /* Verify phone activity */
    static let KEY_VERIFICATION_CODE =  "verification_code";
    
    /* Search filter */
    static let KEY_LOCATION =  "location";
    
    /* Local store */
    static let KEY_LOCAL_STORE_PROFILE_PICTURE =  "local_store_profile_picture";
}
