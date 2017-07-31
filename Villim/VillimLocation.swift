//
//  VillimLocation.swift
//  Villim
//
//  Created by Seongmin Park on 7/30/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation

class VillimLocation {
    var name          : String
    var addrFull      : String
    var addrSummary   : String
    var addrDirection : String
    var latitude      : Double
    var longitude     : Double
    
    init(name:String, addrFull:String, addrSummary:String, addrDirection:String, latitude:Double, longitude:Double) {
        self.name = name;
        self.addrFull = addrFull
        self.addrSummary = addrSummary
        self.addrDirection = addrDirection
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}
