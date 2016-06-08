//
//  RadioAPI.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import Alamofire

private let host = "https://radio.chrislaganiere.net"
private let nowPlayingRoute = "/api/nowplaying"
private let scheduleRoute = "/api/schedule"
private let djRoute = "/api/djs"

protocol APIFetchDelegate {
    func cachedDataAvailable(data: AnyObject)
    func didFetchData(data: AnyObject)
    func failedToFetchData(error: String)
}

private let DocumentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as NSString?

class RadioAPI {
    
    static let NowPlayingUpdatedNotification = "NowPlayingUpdated"
    static var nowPlaying: Show?
    
    static func fetchNowPlaying() {
        Alamofire.request(.GET, host+nowPlayingRoute).validate().responseJSON { response in
            switch response.result {
            case .Success(let json):
                if let nowPlaying = Show.showFromJSON(json as! NSDictionary) {
                    self.nowPlaying = nowPlaying
                    NSNotificationCenter.defaultCenter().postNotificationName(NowPlayingUpdatedNotification, object: nil)
                }
            case .Failure:
                // no show playing right now
                nowPlaying = nil
                NSNotificationCenter.defaultCenter().postNotificationName(NowPlayingUpdatedNotification, object: nil)
            }
        }
    }
    
    static func fetchSchedule(delegate: APIFetchDelegate?) {
        fetchSomethingCached(scheduleRoute, key: "shows", success: { (result, cached) in
            if let showsArray = result as? NSArray {
                let schedule = Schedule(shows: Show.showsFromJSON(showsArray))
                if (cached) {
                    delegate?.cachedDataAvailable(schedule)
                }
                else {
                    delegate?.didFetchData(schedule)
                }
            }
            else {
                delegate?.failedToFetchData("wrong data type")
            }
            }) { (error) in
                print(error)
                delegate?.failedToFetchData(error)
        }
    }
    
    static func fetchDJList(delegate: APIFetchDelegate?) {
        fetchSomethingCached(djRoute, key: "djs", success: { (result, cached) in
            if let djsArray = result as? NSArray {
                let djList = DJ.djsFromJSON(djsArray)
                if (cached) {
                    delegate?.cachedDataAvailable(djList)
                }
                else {
                    delegate?.didFetchData(djList)
                }
            }
            else {
                delegate?.failedToFetchData("wrong data type")
            }
            }) { (error) in
                print(error)
                delegate?.failedToFetchData(error)
        }
    }
    
    /**
     Convert relative file path string to absolute url by adding host
     
     - parameter url: relative url string
     
     - returns: absolute url
     */
    static func absoluteURL(url: String) -> NSURL {
        return NSURL(string: host+url)!
    }
    
    // MARK: - Private
    
    /**
     Perform an API fetch with caching. Will call success with cached data if possible, and on request success, or failure once.
     
     - parameter route:   route to fetch, like: "/api/schedule"
     - parameter key:     key of return object in JSON array, like "shows"
     - parameter success: success block, may be called twice with cached data / live data
     - parameter failure: failure block
     */
    private static func fetchSomethingCached(route: String, key: String, success: ((result: AnyObject, cached: Bool) -> ())?, failure: ((error: String) -> ())?) {
        // Caching
        let fileName = fileForRoute(route)
        if let filePath = DocumentsDirectory?.stringByAppendingPathComponent(fileName) {
            if (NSFileManager.defaultManager().fileExistsAtPath(filePath)) {
                // cached file exists
                if let cached = NSArray(contentsOfFile: filePath) {
                    success?(result: cached, cached: true)
                }
                else if let cached = NSDictionary(contentsOfFile: filePath) {
                    success?(result: cached, cached: true)
                }
            }
            
            Alamofire.request(.GET, host+route).validate().responseJSON { response in
                switch response.result {
                case .Success(let json):
                    if let object = json[key] as? NSDictionary {
                        object.writeToFile(filePath, atomically: true)
                        success?(result: object, cached: false)
                    }
                    else if let object = json[key] as? NSArray {
                        object.writeToFile(filePath, atomically: true)
                        success?(result: object, cached: false)
                    }
                case .Failure(let error):
                    failure?(error: error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Local cached filename for a given API route like: /api/schedule (not a url)
     
     - parameter route: API route string
     
     - returns: mapped fileName for local cached object
     */
    private static func fileForRoute(route: String) -> String {
        return route.stringByReplacingOccurrencesOfString("/", withString: "-") + ".json"
    }
    
}
