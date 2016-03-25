//
//  ServerCommunication.swift
//  Yojo
//
//  Created by Animish Gadve on 1/21/16.
//  Copyright © 2016 OMFG Studios. All rights reserved.
//

import Foundation
import Alamofire


/*
data = {"operation": "QUERY", "query_type": "scale"}
headers = {'content-type': 'application/json'}
*/

class ServerCommunication: NSObject {
    
    let serverURL = "http://evident-relic-120823.appspot.com/"
    
    func getDataFromServer(completion:(responseData:NSData)->Void) {
        Alamofire.request(.GET, serverURL).responseJSON() {
            response in
                completion(responseData: response.data!)
        }
    }
    
    func postDataForServer(completion:(responseData:NSData)->Void) {
        Alamofire.request(.POST, serverURL,parameters: ["operation":"QUERY", "query_type":"scale"], encoding:Alamofire.ParameterEncoding.JSON, headers:["content-type":"application/json"]).responseJSON() {
            response in
            completion(responseData: response.data!)
        }
    }
}