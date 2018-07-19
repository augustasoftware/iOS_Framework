//
//  AUSessionManager.swift
//  AugustaFramework
//
//  Created by augusta on 19/07/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation

public class AUSesionManager{
    
    var userDefaults :UserDefaults
    
    public class var sharedInstance: AUSesionManager {
        struct Static {
            static let instance = AUSesionManager()
        }
        return Static.instance
    }
    
    init() {
        self.userDefaults = UserDefaults()
    }
    
    public func clearAll()  {
        let defaults = userDefaults
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            print(key)
            if key != "UserInfo"{
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    public func setData(object: Any, key: String)
    {
        self.userDefaults.set(object, forKey: key)
        self.userDefaults.synchronize()
    }
    
    public func getData(key: String) -> Any?
    {
        return self.userDefaults.object(forKey: key)
    }
}
