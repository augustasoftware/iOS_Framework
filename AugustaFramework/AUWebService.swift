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
    var sessionManager: SessionManager!
    
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
                                      isCacheEnable:Bool? = false,
                                      successBlock: @escaping kModelSuccessBlock,
                                      failureBlock : @escaping kModelErrorBlock){
//**************************************************** How to use? Start ****************************************************//
//        func getDefaultHeaderDetails() -> [String:String]
//        {
//            //AUTHORIZATION =  Session.sharedInstance.getAccessToken()
//            let headers = ["Authorization":  ""]
//            return headers
//        }
//        
//        func callWebServiceAndTest(){
//            
//            let data = NSMutableDictionary()
//            data.setObject(0, forKey: "id" as NSCopying)
//            data.setObject(0 , forKey: "id" as NSCopying)
//            
//            let service: AUWebService = AUWebService.init(delegate: self, sessionExpiryMessage: "") // provide session expiry message or code to handle session expiry
//            
//            service.callServiceAndGetData(url: url, type: .post, userData: data as! [String : Any], headers: getDefaultHeaderDetails(),  successBlock: {[unowned self] (success, message, reponseObject) in
//                if success {
//                    
//                }
//                else
//                {
//                    
//                }},
//                                          failureBlock: {[unowned self] (errorMesssage) in
//                                            print(errorMesssage)
//                }
//            );
//            
//        }
//        
//        func webServiceGotExpiryMessage(errorMessage: String) {
//            handle session expiry here
//        }
//**************************************************** How to use? end ****************************************************//
        
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
            
            let request = URLRequest(url: NSURL(string: url)! as URL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
            
            if (isCacheEnable)!{
                sessionManager = Alamofire.SessionManager(configuration: AUCacheeManager.shared.configuration(apiName: (request.url?.absoluteString)!))
                sessionManager.request(url, method: httpMethod!, parameters: userData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                    
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
                                if response.result.value != nil{
                                    successBlock(true, "Success",response.result.value as AnyObject)
                                    AUCacheeManager.shared.clearCacheWith(request: request, isForceClear: false)
                                }
                            }
                        }
                        break
                    case .failure(let error):
                        failureBlock(error.localizedDescription as String)
                        break
                    }
                }
            }else {
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
                                if response.result.value != nil{
                                    successBlock(true, "Success",response.result.value as AnyObject)
                                    AUCacheeManager.shared.clearCacheWith(request: request, isForceClear: false)
                                }
                            }
                        }
                        break
                        
                    case .failure(let error):
                        failureBlock(error.localizedDescription as String)
                        break
                    }
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


