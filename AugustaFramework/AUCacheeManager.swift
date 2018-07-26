//
//  AUCacheeManager.swift
//  AugustaFramework
//
//  Created by iMac Augusta on 7/25/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation
import Alamofire

public class AUCacheeManager {
    
    
    class var shared: AUCacheeManager {
        struct Static {
            static let instance = AUCacheeManager()
        }
        return Static.instance
    }
    
    let cacheDate: String = "CACHED_DATE"
    let API: String = "API_NAME"
    
    var timeIntervalInSecods: Int? = 5
    var defaults = UserDefaults()
    var cacheList: NSMutableArray = []
    
    // MARK: - Configure the URLSession
    func configuration(apiName: String) -> URLSessionConfiguration {
        
        let memoryCapacity = 500 * 1024 * 1024; // 500 MB
        let diskCapacity = 500 * 1024 * 1024; // 500 MB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
        
        /*
         * check and set the cache policy,
         * for load response data from local cache if already exists or new from server
         */
        
        let cachePolicy: NSURLRequest.CachePolicy = canRefreshAPICallAndIgnoringCachedData(apiName: apiName) ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad
        
        if cachePolicy == NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData {
            print("Policy type: ---> reloadIgnoringLocalCacheData")
            self.configureDefaults(requestAPIName: apiName)
        }else {
            print("Policy type: ---> returnCacheDataElseLoad")
        }
        
        print(cachePolicy.rawValue.description)
        
        // Create a custom configuration
        let configuration = URLSessionConfiguration.default
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["API-Version"] = "2.0"
        configuration.httpAdditionalHeaders = headers
        configuration.urlCache = cache
        configuration.requestCachePolicy = cachePolicy
        return configuration
    }
    
    /*
     * for refresh API call,
     * the last API call want to done by today and the time greater than 5 sec
     */
    
    func canRefreshAPICallAndIgnoringCachedData(apiName: String) -> Bool {
        
        let lastAPICallTime = getLastAPICallTime(apiName: apiName)
        let differenceInSeconds = lastAPICallTime?.timeIntervalSinceNow
        let hours = Int(differenceInSeconds!) / 3600
        let minutes = -(Int(differenceInSeconds!) / 60) % 60
        let seconds = -(Int(differenceInSeconds!))
        
        print("last date: \(String(describing: lastAPICallTime!)) Now: \(NSDate())")
        print("hours \(hours) min \(minutes) seconds \(seconds)")
        
        let timeDeleayInSecods: Int = self.getCacheTime()
        print(timeDeleayInSecods)
        
        guard NSCalendar.current.isDateInToday(lastAPICallTime! as Date), seconds < timeDeleayInSecods, let asset = cachedInfo(requestAPIName: apiName), asset[API] as? String == apiName else {
            return true
        }
        return false
    }
    public
    func cachedInfo(requestAPIName: String) -> NSDictionary? {
        
        if self.defaults.object(forKey: "list_") != nil {
            self.cacheList = (self.defaults.object(forKey: "list_") as? NSArray)?.mutableCopy() as! NSMutableArray
        }
        if self.cacheList.count > 0 {
            let predicate = NSPredicate(format:"API_NAME == %@", requestAPIName)
            let filteredArray = (self.cacheList as NSMutableArray).filtered(using: predicate)
            print(filteredArray)
            if(filteredArray.count == 0){
                return [API:"CLEAR"]
            }else {
                return filteredArray.first as? NSDictionary
            }
        }
        return self.cacheList.firstObject as? NSDictionary
    }
    
    private
    func configureDefaults(requestAPIName: String) {
        
        let asset = NSMutableDictionary()
        asset.setObject(self.timeNow(), forKey: cacheDate as NSCopying)
        asset.setObject(requestAPIName, forKey: API as NSCopying)
        
        if self.defaults.object(forKey: "list_") != nil {
            self.cacheList = (self.defaults.object(forKey: "list_") as? NSArray)?.mutableCopy() as! NSMutableArray
        }
        
        if self.cacheList.count > 0 {
            let predicate = NSPredicate(format:"API_NAME == %@", requestAPIName)
            let filteredArray = (self.cacheList as NSMutableArray).filtered(using: predicate)
            print(filteredArray)
            if(filteredArray.count == 0){
                self.cacheList.add(asset)
            }else {
                self.cacheList.remove(filteredArray.first!)
                self.cacheList.add(asset)
            }
        }else{
            self.cacheList.add(asset)
        }
        self.defaults.set(self.cacheList, forKey: "list_")
        self.defaults.synchronize()
    }
    
    // MARK: - Time handler
    private
    func timeNow() -> NSDate {
        let now = NSDate() as Date
        return now as NSDate
    }
    
    // for fetch the last api called time
    func getLastAPICallTime(apiName: String) -> NSDate? {
        guard let asset = cachedInfo(requestAPIName: apiName), asset[API] as? String == apiName, let date = asset[cacheDate] as? NSDate else {
            return self.timeNow()
        }
        return date
    }
    
    public
    func setAPICallTime(apiName: String) {
        self.configureDefaults(requestAPIName: apiName)
    }
    
    func clearCacheWith(request: URLRequest, isForceClear: Bool) {
        if isForceClear {
            self.clearCacheValue(requestAPIName: (request.url?.absoluteString)!)
            URLCache.shared.removeCachedResponse(for: request)
        }else {
            if self.canRefreshAPICallAndIgnoringCachedData(apiName: (request.url?.absoluteString)!) {
                self.clearCacheValue(requestAPIName: (request.url?.absoluteString)!)
                URLCache.shared.removeCachedResponse(for: request)
            }
        }
    }
    
    func clearCacheValue(requestAPIName: String) {
        if self.defaults.object(forKey: "list_") != nil {
            self.cacheList = (self.defaults.object(forKey: "list_") as? NSArray)?.mutableCopy() as! NSMutableArray
        }
        if self.cacheList.count > 0 {
            let predicate = NSPredicate(format:"API_NAME == %@", requestAPIName)
            let filteredArray = (self.cacheList as NSMutableArray).filtered(using: predicate)
            print(filteredArray)
            if(filteredArray.count != 0){
                self.cacheList.remove(filteredArray.first!)
                
            }
        }
        self.defaults.set(self.cacheList, forKey: "list_")
        self.defaults.synchronize()
    }
    
    public
    func clearEntireCache() {
        URLCache.shared.removeAllCachedResponses()
        self.cacheList.removeAllObjects()
        self.defaults.set(self.cacheList, forKey: "list_")
        self.defaults.synchronize()
    }
    
    public func setCacheTime(time: Int) {
        UserDefaults.standard.set(time, forKey: "timer")
    }
    
    func getCacheTime() -> Int {
        
        if UserDefaults.standard.object(forKey: "timer") != nil{
            if UserDefaults.standard.integer(forKey: "timer") != 0 {
                return UserDefaults.standard.integer(forKey: "timer")
            }
        }
        return 10 //Default value set 10 Seconds
    }
    /*
     public
     func setAPICacheWith(response:DataResponse<Any>) {
     let cachedURLResponse = CachedURLResponse(response: response.response!, data: ((response.data! as NSData) as Data), userInfo: nil, storagePolicy: .allowed)
     URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
     }
     
     public
     func clearCacheWith(response:DataResponse<Any>) {
     URLCache.shared.removeCachedResponse(for: response.request!)
     }
     
     public
     func clearWholeCache() {
     URLCache.shared.removeAllCachedResponses()
     }*/
    
}
