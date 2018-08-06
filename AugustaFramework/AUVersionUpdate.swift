//
//  AUVersionUpdate.swift
//  AugustaFramework
//
//  Created by iMac Augusta on 7/30/18.
//  Copyright © 2018 augusta. All rights reserved.
//

/********************************************************/
/*For static version setup*/
/*
 AUVersionUpdate.shared.setupStaticVersionUpdate()
It have two optional method
1.VersionAlertUpdateType
2.AlertIntervalPeriod
 */
//----------------------------(OR)----------------------------//
/*For dynamic version setup
 AUVersionUpdate.shared.dynamicVersionUpdate(parsedObject:NSDictionary)
 parsedObject mandatory key values
 let updateType: Int? = parsedObject["updateType"] as? Int
 let reminderInterval: Int? = parsedObject["reminderInterval"] as? Int
 let maxSkipCount: Int? = parsedObject["maxSkipCount"] as? Int
*/
/*******************************************************/

/********************************************************/
/*For Mandatory Method*/
//func showAlertAfterCurrentVersionHasBeenReleasedForDays(daysInterval:Int? = 1)
/*******************************************************/

/********************************************************/
/*For Optional Method*/
//AUVersionUpdate.shared.delegate = self
/*******************************************************/
 
import UIKit
import Siren

public protocol VersionUpdateDelegate:class {
    func auVersionUpdateAlertDidShowUpdateDialog(alertType: VersionAlertUpdateType)
    func auVersionUpdateAlertUserDidCancel()
    func auVersionUpdateAlertUserDidSkipVersion()
    func auVersionUpdateAlertUserDidLaunchAppStore()
    func auVersionUpdateAlertDidFailVersionCheck(error: Error)
    func auVersionUpdateAlertLatestVersionInstalled()
    func auVersionUpdateAlertDidDetectNewVersionWithoutAlert(message: String, updateType: String)
}

public enum VersionAlertUpdateType: Int {
    case version_FORCE = 1
    case version_OPTION = 2
    case version_SKIP = 3
}

public enum AlertIntervalPeriod: Int {
    case version_IMMEDIATELY = 1
    case version_DAILY = 2
    case version_WEEKLY = 3
}

public enum VersionUpdateType: String {
    case major
    case minor
    case patch
    case revision
    case unknown
}

public class AUVersionUpdate: NSObject {

    public weak var versionDelegate: VersionUpdateDelegate?
    var isDynamic: Bool? = false
    
    public class var shared: AUVersionUpdate {
        struct Static {
            static let instance = AUVersionUpdate()
        }
        return Static.instance
    }
    /// setupStaticVersionUpdate
    /// We can set Vesrion update method statically, It's default behaviour
    /// - Parameters: (All parameters optional)
    ///   - type: VersionAlertUpdateType check enum method
    ///   - interVal: AlertIntervalPeriod check enum method
    public func setupStaticVersionUpdate(type:VersionAlertUpdateType? = VersionAlertUpdateType.version_SKIP ,interVal:AlertIntervalPeriod? = AlertIntervalPeriod.version_IMMEDIATELY) {
        isDynamic = false
        let siren = Siren.shared
        switch type?.rawValue {
        case 1:
            siren.alertType = Siren.AlertType.force
        case 2:
            siren.alertType = Siren.AlertType.option
        case 3:
            siren.alertType = Siren.AlertType.skip
        default:
            break
        }
        switch interVal?.rawValue {
        case 0:
            siren.checkVersion(checkType: .immediately)
        case 1:
            siren.checkVersion(checkType: .daily)
        case 7:
            siren.checkVersion(checkType: .weekly)
        default:
            break
        }
    }
    
    /// showAlertAfterCurrentVersionHasBeenReleasedForDays
    /// This method can be use for show version alert method based on app release days
    /// - Parameter daysInterval: (optional parameter)
    public func showAlertAfterCurrentVersionHasBeenReleasedForDays(daysInterval:Int? = 1){
        Siren.shared.showAlertAfterCurrentVersionHasBeenReleasedForDays = daysInterval!
    }

    /// DynamicVersionUpdate
    ///  We can set Vesrion update method dynamically,
    /// - Parameter parsedObject: In that object we need three Mandatory key values for handling version update alert message
    //Mandatory Keys are :- updateType,reminderInterval,maxSkipCount
    // "usedSkipCount" for dynamicVersionUpdate internally handling purposes
    public func dynamicVersionUpdate(parsedObject:NSDictionary) {
        isDynamic = true
        let userDefaults: UserDefaults? = UserDefaults.standard
        let updateType: Int? = parsedObject["updateType"] as? Int
        let reminderInterval: Int? = parsedObject["reminderInterval"] as? Int
        let maxSkipCount: Int? = parsedObject["maxSkipCount"] as? Int
        userDefaults?.set(updateType!, forKey: "updateType")
        userDefaults?.set(reminderInterval!, forKey: "reminderInterval")
        userDefaults?.set(maxSkipCount!, forKey: "maxSkipCount")
        if maxSkipCount == 0 {
            if userDefaults?.object(forKey: "usedSkipCount") != nil {
                userDefaults?.set(0, forKey: "usedSkipCount")
            }
        }
        userDefaults?.synchronize()
        self.setupDynamicVersionUpdate()
    }
    
    /// Description
    //    Update type -> 3 & 4  Merge -> Alert showing based on Reminder interval like Daily/Weekly with Max skip count, once user reached max skip count the alert type changed as force update
    //    Update type -> 2 Alert showing optional type like user always skip the current version
    //    Update type -> 1 Alert showing force type like user need to update current version mandatory
    
    //    Time interval -> Less than 24 will be considered like alert shows when app open every time
    //    Time interval -> Equal to 24 will be considered like alert shows on daily basis
    //    Time interval -> Greater than 24 will be considered like alert shows on weekly basis
    func setupDynamicVersionUpdate() {
        let usrDefaults: UserDefaults? = UserDefaults.standard
        if usrDefaults?.integer(forKey: "updateType") == 3 {
            let value: Int = usrDefaults!.integer(forKey: "reminderInterval")
            let skipCountVal: Int = usrDefaults!.integer(forKey: "maxSkipCount")
            let usedCountVal: Int = usrDefaults!.integer(forKey: "usedSkipCount")
            if skipCountVal == 0 && value == 0 {
                let siren = Siren.shared
                siren.alertType = Siren.AlertType.force
                siren.checkVersion(checkType: .immediately)
            }
            else{
                if skipCountVal != 0 {
                    if usedCountVal != skipCountVal && usedCountVal < skipCountVal {
                        if value != 0 {
                            if value > 24 {
                                let siren = Siren.shared
                                siren.alertType = Siren.AlertType.option
                                siren.checkVersion(checkType: .weekly)
                            }
                            else {
                                let siren = Siren.shared
                                siren.alertType = Siren.AlertType.option
                                siren.checkVersion(checkType: .daily)
                            }
                        }
                        else {
                            let siren = Siren.shared
                            siren.alertType = Siren.AlertType.option
                            siren.checkVersion(checkType: .immediately)
                        }
                    }
                    else{
                        
                        let siren = Siren.shared
                        siren.alertType = Siren.AlertType.force
                        
                        if value != 0 {
                            if value > 24 {
                                siren.checkVersion(checkType: .weekly)
                            }
                            else {
                                siren.checkVersion(checkType: .daily)
                            }
                        }
                        else {
                            siren.checkVersion(checkType: .immediately)
                        }
                    }
                }
                else{
                    let siren = Siren.shared
                    siren.alertType = Siren.AlertType.force
                    siren.checkVersion(checkType: .immediately)
                }
            }
        }
        else if UserDefaults.standard.integer(forKey: "updateType") == 2 {
            let siren = Siren.shared
            siren.alertType = Siren.AlertType.option
            siren.checkVersion(checkType: .immediately)
        }
        else {
            let siren = Siren.shared
            siren.alertType = Siren.AlertType.force
            siren.checkVersion(checkType: .immediately)
        }
    }
}

extension AUVersionUpdate: SirenDelegate
{
    public func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        switch alertType {
        case .force:
             versionDelegate?.auVersionUpdateAlertDidShowUpdateDialog(alertType: VersionAlertUpdateType.version_FORCE )
        case .option:
            versionDelegate?.auVersionUpdateAlertDidShowUpdateDialog(alertType: VersionAlertUpdateType.version_OPTION )
        case .skip:
            versionDelegate?.auVersionUpdateAlertDidShowUpdateDialog(alertType: VersionAlertUpdateType.version_SKIP )
        case .none:
            versionDelegate?.auVersionUpdateAlertDidShowUpdateDialog(alertType: VersionAlertUpdateType.version_SKIP )
        }
    }
    
    public func sirenUserDidCancel() {
        if isDynamic!{
            self.increaseUsedCount()
        }
        versionDelegate?.auVersionUpdateAlertUserDidCancel()
    }
    
    public func sirenUserDidSkipVersion() {
        debugPrint(#function)
        versionDelegate?.auVersionUpdateAlertUserDidSkipVersion()
    }
    
    public func sirenUserDidLaunchAppStore() {
        if isDynamic!{
           self.increaseUsedCount()
        }
        versionDelegate?.auVersionUpdateAlertUserDidLaunchAppStore()
    }
    
    public func sirenDidFailVersionCheck(error: Error) {
        debugPrint(#function, error)
        versionDelegate?.auVersionUpdateAlertDidFailVersionCheck(error: error)
    }
    
    public func sirenLatestVersionInstalled() {
        debugPrint(#function, "Latest version of app is installed")
        versionDelegate?.auVersionUpdateAlertLatestVersionInstalled()
    }
    
    // This delegate method is only hit when alertType is initialized to .none
    public func sirenDidDetectNewVersionWithoutAlert(message: String, updateType: UpdateType) {
        debugPrint(#function, "\(message).\nRelease type: \(updateType.rawValue.capitalized)")
        let updateString = updateType.rawValue.lowercased()
        versionDelegate?.auVersionUpdateAlertDidDetectNewVersionWithoutAlert(message: message, updateType: updateString)
    }
    
    func increaseUsedCount() {
        let usrDefaults: UserDefaults? = UserDefaults.standard
        if UserDefaults.standard.integer(forKey: "updateType") == 3 {
            var usedCountVal: Int? = usrDefaults?.integer(forKey: "usedSkipCount") ?? 0
            usedCountVal =  usedCountVal ?? 0 + 1
            UserDefaults.standard.set(usedCountVal ?? 0, forKey: "usedSkipCount")
            UserDefaults.standard.synchronize()
        }
    }
    
}
