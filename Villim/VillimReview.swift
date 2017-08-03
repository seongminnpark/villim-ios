//
//  Villimself.swift
//  Villim
//
//  Created by Seongmin Park on 8/2/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation
import SwiftDate
import SwiftyJSON

class VillimReview {
    var houseId               : Int!
    var hostId                : Int!
    var reviewerId            : Int!
    var reservationId         : Int!
    var reviewerName          : String!
    var reviewContent         : String!
    var reviewerProfilePicUrl : String!
    var reviewDate            : DateInRegion!
    var overAllRating         : Double!
    var accuracyRating        : Double!
    var communicationRating   : Double!
    var cleanlinessRating     : Double!
    var locationRating        : Double!
    var checkinRating         : Double!
    var valueRating           : Double!
    
    init(reviewInfo:JSON) {
        self.houseId = reviewInfo[VillimKeys.KEY_HOUSE_ID].exists() ? reviewInfo[VillimKeys.KEY_HOUSE_ID].intValue : 0
        self.hostId = reviewInfo[VillimKeys.KEY_HOST_ID].exists() ? reviewInfo[VillimKeys.KEY_HOST_ID].intValue : 0
        self.reviewerId = reviewInfo[VillimKeys.KEY_REVIEWER_ID].exists() ? reviewInfo[VillimKeys.KEY_REVIEWER_ID].intValue : 0
        self.reservationId = reviewInfo[VillimKeys.KEY_RESERVATION_ID].exists() ? reviewInfo[VillimKeys.KEY_RESERVATION_ID].intValue : 0
        self.reviewerName = reviewInfo[VillimKeys.KEY_REVIEWER_NAME].exists() ? reviewInfo[VillimKeys.KEY_REVIEWER_NAME].stringValue : ""
        self.reviewContent = reviewInfo[VillimKeys.KEY_REVIEW_CONTENT].exists() ? reviewInfo[VillimKeys.KEY_REVIEW_CONTENT].stringValue : ""
        self.reviewerProfilePicUrl = reviewInfo[VillimKeys.KEY_REVIEWER_PROFILE_PIC_URL].exists() ? reviewInfo[VillimKeys.KEY_REVIEWER_PROFILE_PIC_URL].stringValue : ""
        let dateString = reviewInfo[VillimKeys.KEY_REVIEW_DATE].exists() ? reviewInfo[VillimKeys.KEY_REVIEW_DATE].stringValue : "1994-06-13"
        self.reviewDate = VillimUtils.dateFromString(dateString: dateString)
        self.overAllRating = reviewInfo[VillimKeys.KEY_RATING_OVERALL].exists() ? reviewInfo[VillimKeys.KEY_RATING_OVERALL].doubleValue : 0.0
        self.accuracyRating = reviewInfo[VillimKeys.KEY_RATING_ACCURACY].exists() ? reviewInfo[VillimKeys.KEY_RATING_ACCURACY].doubleValue : 0.0
        self.communicationRating = reviewInfo[VillimKeys.KEY_RATING_COMMUNICATION].exists() ? reviewInfo[VillimKeys.KEY_RATING_COMMUNICATION].doubleValue : 0.0
        self.cleanlinessRating = reviewInfo[VillimKeys.KEY_RATING_CLEANLINESS].exists() ? reviewInfo[VillimKeys.KEY_RATING_CLEANLINESS].doubleValue : 0.0
        self.locationRating = reviewInfo[VillimKeys.KEY_RATING_LOCATION].exists() ? reviewInfo[VillimKeys.KEY_RATING_LOCATION].doubleValue : 0.0
        self.checkinRating = reviewInfo[VillimKeys.KEY_RATING_CHECKIN].exists() ? reviewInfo[VillimKeys.KEY_RATING_CHECKIN].doubleValue : 0.0
        self.valueRating = reviewInfo[VillimKeys.KEY_RATING_VALUE].exists() ? reviewInfo[VillimKeys.KEY_RATING_VALUE].doubleValue : 0.0
    }
    
    public static func reviewArrayFromJsonArray(jsonReviews:[JSON]) -> [VillimReview] {
        var reviews : [VillimReview] = []
        
        for jsonReview in jsonReviews {
            reviews.append(VillimReview(reviewInfo: jsonReview))
        }
        
        return reviews
    }
}
