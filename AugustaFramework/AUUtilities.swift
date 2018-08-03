//
//  AUUtilities.swift
//  AugustaFramework
//
//  Created by augusta on 03/08/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation

public class AUUtilities{
    
    public class func removeWhiteSpace(text:String) -> String
    {
        return text.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
}
