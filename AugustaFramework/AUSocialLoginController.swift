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

var socialEmail = String()
var socialID = String()
var firstName = String()
var lastName = String()
var socialAccesstoken = String()
var socialProfileUrl = String()

public enum socialLoginType : Int{
    case FB = 1
    case Twitter = 2
    case Instagram = 3
    case Pinterest = 4
    case youtube = 5
}

public class AUSocialLoginController{
    var controller: UIViewController = UIViewController.init()
   
    public init(callingViewcontroller : UIViewController){
        controller = callingViewcontroller
    }
    
    func socialLoginTapped(selectedSocialLoginType : Int) {
        switch selectedSocialLoginType {
        case socialLoginType.FB.rawValue:
            fbLoginTapped()
        case socialLoginType.Twitter.rawValue:
            fbLoginTapped()
        case socialLoginType.Instagram.rawValue:
            fbLoginTapped()
        case socialLoginType.Pinterest.rawValue:
            fbLoginTapped()
        default:
            fbLoginTapped()
        }
        
    }
    
    /// To Login Via Facebook login
    func fbLoginTapped(){
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(readPermissions: [ .publicProfile, .email], viewController: controller, completion: { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        })
    }
    
    /// To Get the Facebook user details once Facebook logged in successfully
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters:["fields": "id,name,picture.type(large),email,first_name,last_name"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    var data : JSON = JSON(result as AnyObject)
                    print("FBDATA==",data)
                    if data != JSON.null {
                        //socialInformationDict.setValue(data["picture"]["data"]["url"].stringValue, forKey: "profileUrl")
                        socialEmail = (data["email"].stringValue)
                        socialID = data["id"].stringValue
                        firstName = (data["first_name"].stringValue)
                        lastName = (data["last_name"].stringValue)
                        socialAccesstoken = FBSDKAccessToken.current().tokenString
                        socialProfileUrl = (data["picture"]["data"]["url"].stringValue)
                        //self.selectedAccountType = 2
                        //self.toCheckIfSocialUserAlreadyExist(strSocialID: self.socialID, socialAccountType: 1)
                        
//                        Session.sharedInstance.setSocialId(self.socialID)
//                        Session.sharedInstance.setUserEmail(self.socialEmail)
//                        Session.sharedInstance.setUserLogin(withSocialAccount: true)
                    }
                }else{
                    //self.showAlertView(message: "Error in facebook login" , controller: self)
                    print(error?.localizedDescription ??  "error")
                }
            })
        }
    }
    
}
