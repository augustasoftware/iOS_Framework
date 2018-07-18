//
//  AUWebService.swift
//  AugustaFramework
//
//  Created by augusta on 17/07/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias kModelSuccessBlock = (_ success : Bool, _ message : String, _ responseObject:AnyObject) ->()
public typealias kModelErrorBlock = (_ errorMesssage: String) -> ()

public enum AUWebServiceType {
    case put
    case get
    case delete
    case post
}

public protocol AUWebServiceDelegate{
    func webServiceGotExpiryMessage(errorMessage: String)
}

public class AUWebService{
    
    var delegate:AUWebServiceDelegate?
    
    var sessionExpiryMessage: String = ""
    
    
    /// initing the AUWebService class
    ///
    /// - Parameters:
    ///   - delegate: mandatory delegate to be assigned
    ///   - sessionExpiryMessage: session expiry message/code which server is sending. Leave it empty if there is no session expiry to be handled
    public init(delegate: AUWebServiceDelegate, sessionExpiryMessage: String = ""){
        self.delegate = delegate
        self.sessionExpiryMessage = sessionExpiryMessage
    }
    
    /// Call this method to get data/ error message in web service. Need not print anything, method prints all params in debug mode. Failure block will be called if Rechability fails
    ///
    /// - Parameters:
    ///   - url: String Url. In case of get|put|delete full url with params
    ///   - type: AUWebServiceType(get|post|delete|put)
    ///   - userData: in case of post send [String:any], others nil should be suffice
    ///   - headers: accessToken - default header details and other headers
    ///   - successBlock: success block
    ///   - failureBlock: failure block
    /// - Returns: Success/Failure block. If session expiry message is set, and if service get the message, delegate will be called to handle the session expiry
    public func callServiceAndGetData(url: String,
                                      type: AUWebServiceType,
                                      userData: [String: Any]?,
                                      headers: [String:String]?,
                                      successBlock: @escaping kModelSuccessBlock,
                                      failureBlock : @escaping kModelErrorBlock){
        
        var httpMethod: HTTPMethod?
        
        // type
        switch type {
        case .put:
            httpMethod = .put
        case .get:
            httpMethod = .get
        case .delete:
            httpMethod = .delete
        case .post:
            httpMethod = .post
        }
        if Reachability.isConnectedToNetwork() == true {
            Alamofire.request(url, method: httpMethod!, parameters: userData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        debugPrint(url)
                        debugPrint(type)
                        debugPrint(userData ?? "")
                        debugPrint(headers ?? "")
                        debugPrint(response.result.value ?? "")
                        if(!self.checkForSessionExpiryAndPop(result: response.result.value ?? ""))
                        {
                            successBlock(true, "Success",response.result.value as AnyObject)
                        }
                    }
                    break
                    
                case .failure(let error):
                    failureBlock(error.localizedDescription as String)
                    break
                }
            }
        
        }
        else{
            failureBlock("Please check your internet connection" as String)
        }
    }
    
    
    
    func checkForSessionExpiryAndPop(result: Any)-> Bool
    {
        var data : JSON = JSON(result as AnyObject)
        
        if(self.sessionExpiryMessage != "" && data["Message"].stringValue.range(of:self.sessionExpiryMessage) != nil)
        {
            debugPrint("Augusta Framework: Session expiry message matches with the web service message, Calling session expiry delegate...")
            self.delegate?.webServiceGotExpiryMessage(errorMessage: data["Message"].stringValue)
            return true
        }
        return false
    }
    
}


