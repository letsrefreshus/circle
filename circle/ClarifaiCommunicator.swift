//
//  ClarifaiCommunicator.swift
//  circle
//
//  Created by Animish Gadve on 3/31/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit
import Alamofire

class ClarifaiCommunicator:NSObject {
    
    let serverURL = "https://api.clarifai.com"
    let clientId = "3Ojmx6vX2rsm32I4tUDlR_U_lqFdgz1MO8sHVbGR"
    let clientSecret = "puUCPazS1AQQDOn6X1dSDL1PG6DykL7PZxmF0hRk"
    var session = ClarifaiSession()
    
    override init() {
        super.init()
        getAccessToken({
            (responseData:NSData) -> Void in
            do {
                let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(responseData, options:.MutableContainers)
                for (key, item) in anyObj as! NSMutableDictionary {
                    if(key as! String == "scope") {
                        self.session.scope = item as! String
                    } else if(key as! String == "token_type") {
                        self.session.tokenType = item as! String
                    } else if(key as! String == "access_token") {
                        self.session.authToken = item as! String
                    } else if(key as! String == "expires_in") {
                        self.session.expiry = NSDate().dateByAddingTimeInterval((item as! NSNumber).doubleValue)
                    }
                }
            }catch {
                NSLog("Serialization to String failed on reading")
            }
        })
    }
    
    func getAccessToken(completion:(responseData:NSData)->Void) {
        Alamofire.request(.POST, serverURL + "/v1/token/",parameters: ["client_id":clientId, "client_secret":clientSecret,"grant_type":"client_credentials"], encoding:Alamofire.ParameterEncoding.URL).responseJSON() {
            response in
            completion(responseData: response.data!)
        }
    }
    
    func getImageData(image:UIImage, completion:(responseData:NSData)->Void) {
        Alamofire.request(.POST, serverURL + "/v1/tag/",parameters: ["access_token":session.authToken, "encoded_data":convertImageToJpeg(image)], encoding:Alamofire.ParameterEncoding.URL).responseJSON() {
            response in
            completion(responseData: response.data!)
        }
    }
    
    func convertImageToJpeg(image:UIImage) -> NSData {
        let size = CGSizeMake(320, 320 * image.size.height / image.size.width)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageJPEGRepresentation(scaledImage, 0.9)!
    }
}
