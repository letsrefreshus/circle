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
    var itemWeighedDate = NSDate()
    var itemMaxWeight = NSNumber()
    var itemWeight = NSNumber()
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
