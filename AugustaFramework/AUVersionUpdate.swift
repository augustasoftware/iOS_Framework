//
//  AUVersionUpdate.swift
//  AugustaFramework
//
//  Created by iMac Augusta on 7/30/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import UIKit
import Siren

public enum VersionUpdateType: Int {
    case version_FORCE = 1
    case version_OPTION = 2
    case version_SKIP = 3
}

public enum AlertIntervalPeriod: Int {
    case version_IMMEDIATELY = 1
    case version_DAILY = 2
    case version_WEEKLY = 3
}

public class AUVersionUpdate: NSObject {

    public class func setupVersionUpdate(type:VersionUpdateType? = VersionUpdateType.version_SKIP ,interVal:AlertIntervalPeriod? = AlertIntervalPeriod.version_IMMEDIATELY) {
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
        
        //    Update type -> 3 & 4  Merge -> Alert showing based on Reminder interval like Daily/Weekly with Max skip count, once user reached max skip count the alert type changed as force update
        //    Update type -> 2 Alert showing optional type like user always skip the current version
        //    Update type -> 1 Alert showing force type like user need to update current version mandatory
        
        //    Time interval -> Less than 24 will be considered like alert shows when app open every time
        //    Time interval -> Equal to 24 will be considered like alert shows on daily basis
        //    Time interval -> Greater than 24 will be considered like alert shows on weekly basis
        let userDefaults: UserDefaults? = UserDefaults.standard
        if userDefaults?.integer(forKey: "updateType") == 3 {
            let value: Int = userDefaults!.integer(forKey: "reminderInterval")
            let skipCountVal: Int = userDefaults!.integer(forKey: "maxSkipCount")
            let usedCountVal: Int = userDefaults!.integer(forKey: "usedSkipCount")
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
        //  Converted with Swiftify v1.0.6472 - https://objectivec2swift.com/
        let usrDefaults: UserDefaults? = UserDefaults.standard
        if usrDefaults?.integer(forKey: "updateType") == 3 && usrDefaults?.integer(forKey: "maxSkipCount") == 0 {
            UserDefaults.standard.removeObject(forKey: "maxSkipCount")
            UserDefaults.standard.removeObject(forKey: "reminderInterval")
            UserDefaults.standard.removeObject(forKey: "usedSkipCount")
           // Siren.shared.replaceLastVersionDate()
        }
        
    }
    
    public func sirenUserDidCancel() {
        self.increaseUsedCount()
    }
    
    public func sirenUserDidSkipVersion() {
        debugPrint(#function)
    }
    
    public func sirenUserDidLaunchAppStore() {
        self.increaseUsedCount()
        
    }
    
    public func sirenDidFailVersionCheck(error: Error) {
        debugPrint(#function, error)
    }
    
    public func sirenLatestVersionInstalled() {
        debugPrint(#function, "Latest version of app is installed")
    }
    
    // This delegate method is only hit when alertType is initialized to .none
    public func sirenDidDetectNewVersionWithoutAlert(message: String, updateType: UpdateType) {
        debugPrint(#function, "\(message).\nRelease type: \(updateType.rawValue.capitalized)")
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
