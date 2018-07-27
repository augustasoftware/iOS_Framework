//
//  AUSocialLoginController.swift
//  AugustaFramework
//
//  Created by Augusta on 24/07/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FacebookLogin
import SwiftyJSON
import TwitterKit

var socialEmail = String()

var socialfirstName = String()
var sociallastName = String()
var socialAccesstoken = String()
var socialProfileUrl = String()
var selectedSocialLoginType = String()
public var socialID = String()

public enum socialLoginType : Int{
    case FB = 1
    case Twitter = 2
    case Instagram = 3
    case Pinterest = 4
    case youtube = 5
}
public enum socialResult{
    case success
    case failure
}

public class AUSocialLoginController{
    var controller: UIViewController = UIViewController.init()
    
    public init(callingViewcontroller : UIViewController){
        controller = callingViewcontroller
    }
    
    public func socialLoginTapped(selectedSocialLoginType : Int, completion:@escaping (Bool) -> Void) {
        switch selectedSocialLoginType {
        case socialLoginType.FB.rawValue:
            fbLoginTapped(completion: {_ in
                self.getFBUserData(completion: {_ in
                    completion(true)
                })
            })
        case socialLoginType.Twitter.rawValue:
            break
        case socialLoginType.Instagram.rawValue:
            break
        case socialLoginType.Pinterest.rawValue:
            break
        default:
            break
        }
        
    }
   
    /* Facebook Login and details from SDK start */
    
    /// To Login Via Facebook login
    public func fbLoginTapped(completion:@escaping (Bool) -> Void) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(readPermissions: [ .publicProfile, .email], viewController: controller, completion: { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                completion(true)
            }
        })
    }
    
    
    /// To Get the Facebook user details once Facebook logged in successfully
    func getFBUserData(completion:@escaping (Bool) -> Void){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters:["fields": "id,name,picture.type(large),email,first_name,last_name"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    var data : JSON = JSON(result as AnyObject)
                    print("FBDATA==",data)
                    if data != JSON.null {
                        socialEmail = (data["email"].stringValue)
                        socialID = data["id"].stringValue
                        socialfirstName = (data["first_name"].stringValue)
                        sociallastName = (data["last_name"].stringValue)
                        socialAccesstoken = FBSDKAccessToken.current().tokenString
                        socialProfileUrl = (data["picture"]["data"]["url"].stringValue)
                        completion(true)
                    }
                }else{
                    //self.showAlertView(message: "Error in facebook login" , controller: self)
                    print(error?.localizedDescription ??  "error")
                }
            })
        }
    }
    /* Facebook Login and details from SDK End */
    
    
    /* Twitter Login and details from SDK start */
    
    public func btnTwitterLoginTapped(completion:@escaping (Bool) -> Void) {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("Details: %@ ",session?.authToken ?? "Not received");
                let client = TWTRAPIClient.withCurrentUser()
                client.requestEmail { email, error in
                    // if (email != nil) {
                   socialEmail = email ?? ""
                   socialID = (session?.userID)!
                    
                    client.loadUser(withID: socialID, completion:{ (user, error) in
                        socialfirstName = (user?.name)!
                        socialProfileUrl = (user?.profileImageLargeURL)!
                    })
                    /* } else {
                     self.hideActivityIndicator(self.view)
                     print("error: \(String(describing: error?.localizedDescription))");
                     }*/
                }
                //  print("signed in as \(session?.userName)");
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
    }
    
    /* Twitter Login and details from SDK End */
    
    
    
}
