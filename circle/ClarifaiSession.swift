//
//  ClarifaiSession.swift
//  circle
//
//  Created by Animish Gadve on 4/1/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import Foundation

class ClarifaiSession {
    var tokenType = String()
    var expiry = NSDate()
    var scope = String()
    var authToken = String()

    func isValidAuthToken()->Bool{
        return NSCalendar.currentCalendar().components(.Second, fromDate: expiry).second < 0
    }
}