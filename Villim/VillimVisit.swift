//
//  VillimVisit.swift
//  Villim
//
//  Created by Seongmin Park on 7/25/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation
import SwiftyJSON

class VillimVisit {
    static let PENDING   = 0
    static let CONFIRMED = 1
    static let DONE      = 2
    
    var visitId     : Int
    var houseId     : Int
    var visitorId   : Int
    var visitTime   : String
    var visitStatus : Int
    
    init(visitInfo:JSON) {
        self.visitId = visitInfo[VillimKeys.KEY_VISIT_ID].exists() ? visitInfo[VillimKeys.KEY_VISIT_ID].intValue : 0
        self.houseId = visitInfo[VillimKeys.KEY_HOUSE_ID].exists() ? visitInfo[VillimKeys.KEY_HOUSE_ID].intValue : 0
        self.visitorId = visitInfo[VillimKeys.KEY_VISITOR_ID].exists() ? visitInfo[VillimKeys.KEY_VISITOR_ID].intValue : 0
        self.visitTime = visitInfo[VillimKeys.KEY_VISIT_TIME].exists() ? visitInfo[VillimKeys.KEY_VISIT_TIME].stringValue : ""
        self.visitStatus = visitInfo[VillimKeys.KEY_VISIT_STATUS].exists() ? visitInfo[VillimKeys.KEY_VISIT_STATUS].intValue : 0
    }
    
    public static func visitArrayFromJsonArray(jsonVisits:[JSON]) -> [VillimVisit] {
        var visits : [VillimVisit] = []
        
        for jsonVisit in jsonVisits {
            visits.append(VillimVisit(visitInfo: jsonVisit))
        }
        
        return visits
    }
    
    public static func stringFromVisitStatus(status:Int) -> String {
        switch (status) {
        case PENDING:
            return NSLocalizedString("status_pending", comment: "")
        case CONFIRMED:
            return NSLocalizedString("status_confirmed", comment: "")
        case DONE:
            return NSLocalizedString("status_done", comment: "")
        default:
            return NSLocalizedString("status_pending", comment: "")
        }
    }
}
