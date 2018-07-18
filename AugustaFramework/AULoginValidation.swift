//
//  AULoginValidation.swift
//  AugustaFramework
//
//  Created by iMac Augusta on 7/18/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation

public enum AllowedType: Int {
    case pasword_UPPER_LOWER_DIGIT_LIMIT = 1
    case pasword_LOWER_DIGIT_LIMIT = 2
    case pasword_UPPER_DIGIT_LIMIT = 3
    case pasword_UPPER_LOWER_LIMIT = 4
    case pasword_DIGIT_LIMIT = 5
    case pasword_DEFAULT = 6
}

public class AULoginValidation {
    
    public class func validateUserNameValues(username:String,minimumLimitCount:Int,specialChar:Bool? = false,allowedCharacterset:String? = "") -> (Bool, String) {
        
        if self.count(username) < 1{
            return (false,String(format: "Is Empty"))
        }
        if specialChar! {
            let characterset = CharacterSet(charactersIn: allowedCharacterset!)
            if username.rangeOfCharacter(from: characterset.inverted) != nil {
                return (false,"Is contains special characters")
            }
        }
        if count(username) < minimumLimitCount{
            return (false,String(format: "Minimum limit count: %d", minimumLimitCount))
        }
        return (true,"")
    }
    
    
    public class func validateUserNameEmailValues(emailValue:String) -> (Bool, String) {
        
        if count(emailValue) < 1 {
            return (false,String(format: "Is Empty"))
        }
        
        if self.isValidEmailAddress(emailIDValue: emailValue) == false {
            return (false, "Not valid email")
        } else {
            let tempVal = emailValue.components(separatedBy: "@") as NSArray
            if tempVal.count >= 2 {
                if (tempVal[0] as! String).count > 64 {
                    return (true,String(format: "Maximum limit (the account/name) count: 64"))
                }
                else if (tempVal[1] as! String).count > 255 {
                    return (true,String(format: "Maximum limit domain count: 255"))
                }
                else {
                    return (true,"")
                }
            }
        }
        return (true,"")
    }
    
    
   public class func validatePasswordValues(password:String,minimumLimitCount:Int,specialChar:Bool? = false,allowedCharacterset:String? = "",type:AllowedType.RawValue) -> (Bool, String) {
        
        if count(password) < 1{
            return (false,String(format: "Is Empty"))
        }
        
        if specialChar! {
            let characterset = CharacterSet(charactersIn: allowedCharacterset!)
            if password.rangeOfCharacter(from: characterset.inverted) != nil {
                return (false,"Is contains special characters")
            }
        }
        
        if count(password) < minimumLimitCount{
            return (false,String(format: "Minimum limit count: %d", minimumLimitCount))
        }
        
        switch type {
        case 1://pasword_UPPER_LOWER_DIGIT_LIMIT
            let queryStr:String? = String(format: "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{%d,}",minimumLimitCount)
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", queryStr!)
            if  passwordTest.evaluate(with: password) == false{
                return (false,"Not pasword_UPPER_LOWER_DIGIT_LIMIT")
            }
        case 2://pasword_LOWER_DIGIT_LIMIT
            let queryStr:String? = String(format: "(?=.*[0-9])(?=.*[a-z]).{%d,}",minimumLimitCount)
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", queryStr!)
            if  passwordTest.evaluate(with: password) == false{
                return (false,"Not pasword_LOWER_DIGIT_LIMIT")
            }
        case 3://pasword_UPPER_DIGIT_LIMIT
            let queryStr:String? = String(format: "(?=.*[A-Z])(?=.*[0-9]).{%d,}",minimumLimitCount)
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", queryStr!)
            if  passwordTest.evaluate(with: password) == false{
                return (false,"Not pasword_UPPER_DIGIT_LIMIT")
            }
        case 4://pasword_UPPER_LOWER_LIMIT
            let queryStr:String? = String(format: "(?=.*[A-Z])(?=.*[a-z]).{%d,}",minimumLimitCount)
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", queryStr!)
            if  passwordTest.evaluate(with: password) == false{
                return (false,"Not pasword_UPPER_LOWER_LIMIT")
            }
        case 5://pasword_DIGIT_LIMIT
            let queryStr:String? = String(format: "(?=.*[0-9]).{%d,}",minimumLimitCount)
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", queryStr!)
            if  passwordTest.evaluate(with: password) == false{
                return (false,"Not pasword_DIGIT_LIMIT")
            }
        case 6://pasword_DEFAULT
            return (true,"Is Ok")
        default:
            return (true,"Is contains special characters")
        }
        
        return (true,"Is Ok")
    }
    
    public class func validateTextFieldValues(username:String,minimumLimitCount:Int,specialChar:Bool? = false,isValidated:Bool? = false,allowedCharacterset:String? = "") -> (Bool, String) {
        
        if isValidated == true {
            if self.count(username) < 1{
                return (false,String(format: "Is Empty"))
            }
        }
        
        if specialChar! {
            let characterset = CharacterSet(charactersIn: allowedCharacterset!)
            if username.rangeOfCharacter(from: characterset.inverted) != nil {
                return (false,"Is contains special characters")
            }
        }
        
        if count(username) < minimumLimitCount{
            return (false,String(format: "Minimum limit count: %d", minimumLimitCount))
        }
        return (true,"")
    }
    
    public class func isValidEmailAddress (emailIDValue:String)-> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [.caseInsensitive])
        return regex.firstMatch(in: emailIDValue, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, emailIDValue.count)) != nil
    }
    
    public class func count(_ username:String) -> Int {
        return username.count
    }
}
