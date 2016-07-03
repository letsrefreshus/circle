//
//  MatItem.swift
//  circle
//
//  Created by Animish Gadve on 2/26/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit

class MatItem: NSObject {
    var itemId = NSNumber()
    var itemName =  String()
    var itemWeighedDate = String()
    var itemMaxWeight = NSNumber()
    var itemWeight = NSNumber()
    var containerWeight = NSNumber()
    var numUnits = NSNumber()
    var units = String()
    var xCoord = NSNumber()
    var yCoord = NSNumber()
    
    var itemWeightPercentage:NSNumber {
        get {
            if(itemMaxWeight == 0) {
                itemMaxWeight = itemWeight
            }
            if(itemMaxWeight.floatValue < itemWeight.floatValue) {
                return 101
            } else {
                return itemWeight.floatValue/itemMaxWeight.floatValue * 100
            }
        }
    }
}
