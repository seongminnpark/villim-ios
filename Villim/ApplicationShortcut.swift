//
//  ApplicationShortcut.swift
//  Villim
//
//  Created by Seongmin Park on 7/28/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation

enum TouchActions: String {
    case key = "key"
    case visit = "visit"
    case discover = "discover"
    
    var number: Int {
        switch  self {
        case .discover:
            return 0
        case .key:
            return 1
        case .visit:
            return 2
        }
    }
}
