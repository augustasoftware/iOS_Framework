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
import PinterestSDK

public var socialEmail = String()
public var socialUserName = String()
public var socialfirstName = String()
public var sociallastName = String()
public var socialAccesstoken = String()
public var socialProfileUrl = String()
public var selectedSocialLoginType = String()
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
            self.btnTwitterLoginTapped(completion: {_ in
                completion(true)
            })
            break
        case socialLoginType.Instagram.rawValue:
            break
        case socialLoginType.Pinterest.rawValue:
            self.btnPinterestLoginTapped(completion: {_ in
                completion(true)
            })
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
                        completion(true)
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
    
    
    /* Pinterest Login and details from SDK start */
    
    func btnPinterestLoginTapped(completion:@escaping (Bool) -> Void) {
        
        var pinterestUser = PDKUser()
        
        PDKClient.clearAuthorizedUser()
        
        //MARK: - Authenticating user, this will get the auth token... but to get the user profile, see MARK: Getting User Profile
        
        PDKClient.sharedInstance().authenticate(withPermissions: [PDKClientReadPublicPermissions,PDKClientWritePublicPermissions,PDKClientReadRelationshipsPermissions,PDKClientWriteRelationshipsPermissions], withSuccess: { (PDKResponseObject) in
            var parameters : [String:String] = [:]
            socialAccesstoken = PDKClient.sharedInstance().oauthToken
        
            //socialID = PDKClient.sharedInstance().appId //API_PININTREST_ID
           /* PDKClient.sharedInstance().getAuthenticatedUserBoards(withFields: NSSet(array: ["id","name","description", "image[medium]"]) as Set, success: { (responseObject: PDKResponseObject!) -> Void in
                for object in responseObject.boards(){
                    if let boardValue = object as? PDKBoard{
                        print(boardValue.descriptionText  , "descriptionText")
                        print(boardValue.name , "name")
                        print(boardValue.identifier , "name")
                        self.pinIntrestBoards.append(boardValue)
                        PDKClient.sharedInstance().getBoardPins(boardValue.identifier, fields: NSSet(array: ["id","name"]) as Set, withSuccess: { (responseObject: PDKResponseObject!) -> Void in
                            for object in responseObject.boards(){
                                if let boardValue = object as? PDKBoard{
                                    print(boardValue.pins , "Pins")
                                }
                            }
                        }, andFailure: nil)
                    }
                }
                self.hideActivityIndicator(self.view)
                if self.pinIntrestBoards.count > 0 {
                    self.showSelectBusinessPopup(viaFacebookAction: false)
                }else {
                    self.showAlertView(message: "You need to create board to your Pinterest account and proceed further.", controller: self)
                }
                
                
            }){
                (Error) in
                if let error = Error
                {
                    self.hideActivityIndicator(self.view)
                    //                    let alert = UIAlertController(title: "GetAuthenticatedUserBoards API", message: (error.localizedDescription), preferredStyle: UIAlertControllerStyle.alert)
                    //                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
                    //                        UIAlertAction in
                    //
                    //                    }
                    //                    alert.addAction(okAction)
                    //                    self.present(alert, animated: true, completion: nil)
                    print((error.localizedDescription))
                }
            }*/
            parameters =  [ "fields":  "first_name,id,last_name,url,image,username,bio,counts,created_at,account_type"] //these fields will be fetched for the loggd in user
            PDKClient.sharedInstance().getPath("/v1/me/", parameters: parameters, withSuccess: {
                (PDKResponseObject) in
                
                pinterestUser = (PDKResponseObject?.user())!
                if let url = JSON(PDKResponseObject?.user().images["564x"] as Any)["url"].string {
                    print(url)
                    socialProfileUrl = url
                    socialfirstName = pinterestUser.firstName
                    sociallastName = pinterestUser.lastName
                    socialUserName = pinterestUser.username
                    completion(true)
                    //self.pinIntrestBusinessName = String(format:"%@ %@",self.pinIntrestUser.firstName,self.pinIntrestUser.lastName)
                }
            }) {
                (Error) in
                if let error = Error
                {
                    print("Error on other else part",(error.localizedDescription))
                }
            }
            
        }) {
            (Error) in
            if let error = Error
            {
                print("Error on authenticate part",(error.localizedDescription))
            }
        }
        
        
    }
    /* Pinterest Login and details from SDK End */
}
