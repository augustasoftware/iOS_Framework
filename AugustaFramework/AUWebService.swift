//
//  AUWebService.swift
//  AugustaFramework
//
//  Created by augusta on 17/07/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation
import Alamofire

public typealias kModelSuccessBlock = (_ success : Bool, _ message : String, _ responseObject:AnyObject) ->()
public typealias kModelErrorBlock = (_ errorMesssage: String) -> ()

public enum AUWebServiceType {
    case put
    case get
    case delete
    case post
}

public class AUWebService{
    
    public class func callServiceAndGetData(url: String,
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
        
        Alamofire.request(url, method: httpMethod!, parameters: userData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    successBlock(true, "success", response.result.value as AnyObject)
                }
                break
                
            case .failure(let error):
                failureBlock(error.localizedDescription as String)
                break
            }
        }
    }
    
}

