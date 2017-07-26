//
//  VillimAmenity.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import Foundation
import UIKit

class VillimAmenity {
    
    public static func getAmenityName(amenityId:Int) -> String {
        switch amenityId {
        case 1:  return NSLocalizedString("bedsheet", comment: "")
        case 2:  return NSLocalizedString("wifi", comment: "")
        case 3:  return NSLocalizedString("tv", comment: "")
        case 4:  return NSLocalizedString("cutlery", comment: "")
        case 5:  return NSLocalizedString("iron", comment: "")
        case 6:  return NSLocalizedString("desk", comment: "")
        case 7:  return NSLocalizedString("towel", comment: "")
        case 8:  return NSLocalizedString("air_conditioner", comment: "")
        case 9:  return NSLocalizedString("computer", comment: "")
        case 10: return NSLocalizedString("fridge", comment: "")
        case 11: return NSLocalizedString("hair_dryer", comment: "")
        case 12: return NSLocalizedString("smoke_detector", comment: "")
        case 13: return NSLocalizedString("first_aid", comment: "")
        case 14: return NSLocalizedString("heating", comment: "")
        case 15: return NSLocalizedString("cooking_ekectronics", comment: "")
        case 16: return NSLocalizedString("washer", comment: "")
        case 17: return NSLocalizedString("closet", comment: "")
        case 18: return NSLocalizedString("fire_extinguisher", comment: "")
        default: return NSLocalizedString("bedsheet", comment: "")
        }
    }
    
    public static func getAmenityImage(amenityId:Int) -> UIImage {
        switch amenityId {
        case 1:  return #imageLiteral(resourceName: "icon_bed")
        case 2:  return #imageLiteral(resourceName: "icon_wifi")
        case 3:  return #imageLiteral(resourceName: "icon_tv")
        case 4:  return #imageLiteral(resourceName: "icon_cutlery")
        case 5:  return #imageLiteral(resourceName: "icon_iron")
        case 6:  return #imageLiteral(resourceName: "icon_desk")
        case 7:  return #imageLiteral(resourceName: "icon_towel")
        case 8:  return #imageLiteral(resourceName: "icon_air_conditioner")
        case 9:  return #imageLiteral(resourceName: "icon_computer")
        case 10: return #imageLiteral(resourceName: "icon_fridge")
        case 11: return #imageLiteral(resourceName: "icon_hair_dryer")
        case 12: return #imageLiteral(resourceName: "icon_smoke_detector")
        case 13: return #imageLiteral(resourceName: "icon_first_aid")
        case 14: return #imageLiteral(resourceName: "icon_heating")
        case 15: return #imageLiteral(resourceName: "icon_toaster")
        case 16: return #imageLiteral(resourceName: "icon_washing_machine")
        case 17: return #imageLiteral(resourceName: "icon_closet")
        case 18: return #imageLiteral(resourceName: "icon_fire_extinguisher")
        default: return #imageLiteral(resourceName: "icon_bed")
        }

    }
}
