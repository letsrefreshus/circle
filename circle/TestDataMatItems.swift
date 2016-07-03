//
//  TestDataMatItems.swift
//  circle
//
//  Created by Animish Gadve on 6/15/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit

class TestDataMatItems: NSObject {
    
    var testListItems = Array<Array<MatItem>>()
    
    override init() {
        super.init()
        
        var sectionArray = Array<MatItem>()
        
        let item1 = MatItem()
        item1.itemName = "Milk"
        item1.itemId = 1
        item1.containerWeight = 0
        item1.itemMaxWeight = 100
        item1.itemWeight = 75
        item1.xCoord = 7
        item1.yCoord = 20
        sectionArray.append(item1)
        
        let item2 = MatItem()
        item2.itemName = "Eggs"
        item2.itemId = 2
        item2.containerWeight = 0
        item2.itemMaxWeight = 100
        item2.itemWeight = 55
        item2.xCoord = 67
        item2.yCoord = 45
        sectionArray.append(item2)
        testListItems.append(sectionArray)
        sectionArray = Array<MatItem>()
        
        let item3 = MatItem()
        item3.itemName = "Orange Juice"
        item3.itemId = 3
        item3.containerWeight = 0
        item3.itemMaxWeight = 100
        item3.itemWeight = 23
        item3.xCoord = 86
        item3.yCoord = 10
        sectionArray.append(item3)
        
        
        
        testListItems.append(sectionArray)
    }
    
}
