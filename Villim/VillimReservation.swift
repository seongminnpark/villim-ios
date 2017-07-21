//
//  VillimReservation.swift
//  Villim
//
//  Created by Seongmin Park on 7/21/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation

class VillimReservation {
    
    var reservationId : Int
    var houseId : Int
    var hostId : Int
    var guestId : Int
    var startDate : Date
    var endDate : Date
    var reservationTime : String
    var reservationStatus : Int
    var reservationCode : String
    
    init() {
        self.reservationId = 0
        self.houseId = 0
        self.hostId = 0
        self.guestId = 0
        self.startDate = Date()
        self.endDate = Date()
        self.reservationTime = ""
        self.reservationStatus = 0
        self.reservationCode = ""
    }
    
}
