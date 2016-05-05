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
    
    enum ParametersForOperation{
        case MatFetchData
        case ListFetchData
        case ListItemsFetchData
        case ListAddItem
        case ListDeleteItem
        case ListEditItem
    }
    
    enum HeadersForOperation{
        case Standard
        case MatFetchData
        case ListFetchData
        case ListItemsFetchData
        case ListAddItem
        case ListDeleteItem
        case ListEditItem
    }
    
    
    static let sharedInstance = ServerCommunication()
    let serverURL = "http://evident-relic-120823.appspot.com/"
    
    func getDataFromServer(completion:(responseData:NSData)->Void) {
        Alamofire.request(.GET, serverURL).responseJSON() {
            response in
                completion(responseData: response.data!)
        }
    }
    
    func postDataToServer(parameters:ParametersForOperation, headers:HeadersForOperation, additionalParameters:Dictionary<String,AnyObject>, completion:(responseData:NSData)->Void) {
        var finalParameters = getParameters(parameters)
        finalParameters.merge(additionalParameters)
        Alamofire.request(.POST, serverURL,parameters:finalParameters, encoding:Alamofire.ParameterEncoding.JSON, headers:getHeaders(headers)).responseJSON() {
            response in
            completion(responseData: response.data!)
        }
    }

    func postDataToServer(parameters:ParametersForOperation, headers:HeadersForOperation, completion:(responseData:NSData)->Void) {
        let finalParameters = getParameters(parameters)
        Alamofire.request(.POST, serverURL,parameters:finalParameters, encoding:Alamofire.ParameterEncoding.JSON, headers:getHeaders(headers)).responseJSON() {
            response in
            completion(responseData: response.data!)
        }
    }

    
    func getParameters(operationType:ParametersForOperation) -> [String:AnyObject] {
        var parameters =  Dictionary<String,AnyObject>()
        switch  operationType{
        case .MatFetchData:
            parameters = ["operation":"QUERY", "query_type":"scale"]
            break
        case .ListFetchData:
            parameters =  ["operation":"QUERY", "query_type":"list"]
            break
        case .ListItemsFetchData:
            parameters =  ["operation":"QUERY", "query_type":"listitems"]
            break
        case .ListAddItem:
            parameters =  ["operation":"ADD", "add_type":"list"]
            break
        case .ListDeleteItem:
            parameters =  ["operation":"DELETE", "delete_type":"list"]
            break
        case .ListEditItem:
            parameters = ["operation": "UPDATE", "update_type": "list"]
        }
        return parameters
    }
    
    func getHeaders(operationType:HeadersForOperation) -> [String:String] {
        var headers = [String:String]()
        switch  operationType{
        default:
            headers = ["content-type":"application/json"]
            
        }
        return headers
    }
}
