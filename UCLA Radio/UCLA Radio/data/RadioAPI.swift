//
//  RadioAPI.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import Alamofire

private let host = "https://uclaradio.com"
private let nowPlayingRoute = "/api/nowplaying"
private let scheduleRoute = "/api/schedule"
private let djRoute = "/api/djs"
private let giveawayDescriptionRoute = "/api/giveawayDescription"
private let streamURLRoute = "/api/streamURL"
private let giveawaysRoute = "/GiveawayCalendar/data"

protocol APIFetchDelegate {
    func cachedDataAvailable(_ data: Any)
    func didFetchData(_ data: Any)
    func failedToFetchData(_ error: String)
}

private let DocumentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as NSString?

class RadioAPI {
    
    static let NowPlayingUpdatedNotification = "NowPlayingUpdated"
    static var nowPlaying: Show?
    
    static func fetchNowPlaying() {
        Alamofire.request(host+nowPlayingRoute).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                if let nowPlaying = Show.showFromJSON(json as! NSDictionary) {
                    self.nowPlaying = nowPlaying
                } else {
                    nowPlaying = nil
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NowPlayingUpdatedNotification), object: nil)
            case .failure:
                // no show playing right now
                nowPlaying = nil
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NowPlayingUpdatedNotification), object: nil)
            }
        }
    }
    
    static func fetchSchedule(_ delegate: APIFetchDelegate?) {
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
    
    static func fetchDJList(_ delegate: APIFetchDelegate?) {
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
    
    static func fetchGiveaways(_ delegate: APIFetchDelegate?) {
        fetchSomethingCached(giveawaysRoute, key: "events", success: { (result, cached) in
            if let eventsMonthsArray = result as? NSArray {
                let giveaways = Giveaway.giveawaysFromJSON(eventsMonthsArray)
                if (cached) {
                    delegate?.cachedDataAvailable(giveaways)
                }
                else {
                    delegate?.didFetchData(giveaways)
                }
            }
            else {
                delegate?.failedToFetchData("wrong data type: should be [String: [Giveaway]]")
            }
        }) { (error) in
            print(error)
            delegate?.failedToFetchData(error)
        }
    }
    
    static func fetchGiveawayDescription(_ delegate: APIFetchDelegate?) {
        fetchSomethingCached(giveawayDescriptionRoute, key: "info", success: { (result, cached) in
            if let description = result as? String {
                if cached {
                    delegate?.cachedDataAvailable(description)
                } else {
                    delegate?.didFetchData(description)
                }
            } else {
                delegate?.failedToFetchData("wrong data type: should be String")
            }
        }) { (error) in
            print(error)
            delegate?.failedToFetchData(error)
        }
    }
    
    static func fetchStreamURL(_ delegate: APIFetchDelegate?) {
        fetchSomethingCached(streamURLRoute, key: "url", success: { (result, cached) in
            if let description = result as? String {
                if cached {
                    delegate?.cachedDataAvailable(description)
                } else {
                    delegate?.didFetchData(description)
                }
            } else {
                delegate?.failedToFetchData("wrong data type: should be String")
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
    static func absoluteURL(_ url: String) -> URL {
        return URL(string: host+url)!
    }
    
    // MARK: - Private
    
    /**
     Perform an API fetch with caching. Will call success with cached data if possible, and on request success, or failure once.
     
     - parameter route:   route to fetch, like: "/api/schedule"
     - parameter key:     key of return object in JSON array, like "shows"
     - parameter success: success block, may be called twice with cached data / live data
     - parameter failure: failure block
     */
    fileprivate static func fetchSomethingCached(_ route: String, key: String, success: ((_ result: Any, _ cached: Bool) -> ())?, failure: ((_ error: String) -> ())?) {
        // Caching
        let fileName = fileForRoute(route)
        if let filePath = DocumentsDirectory?.appendingPathComponent(fileName) {
            if (FileManager.default.fileExists(atPath: filePath)) {
                // cached file exists
                if let cached = NSArray(contentsOfFile: filePath) {
                    success?(cached, true)
                }
                else if let cached = NSDictionary(contentsOfFile: filePath) {
                    success?(cached, true)
                }
                else {
                    do {
                        let cached = try String(contentsOfFile: filePath, encoding: .utf8)
                        success?(cached, true)
                    } catch let error {
                        print("radio cache read error: \(error.localizedDescription)")
                    }
                }
            }
            
            Alamofire.request(host+route).validate().responseJSON { response in
switch response.result {
                case .success(let json):
                    if let json = json as? NSDictionary,
                        let object = json[key] as? NSDictionary {
                        object.write(toFile: filePath, atomically: true)
                        success?(object, false)
                    }
                    if let json = json as? NSDictionary,
                        let object = json[key] as? String {
                        do {
                            try object.write(toFile: filePath, atomically: true, encoding: .utf8)
                        } catch let error {
                            print("radio api cache save file error: \(error.localizedDescription)")
                        }
                        success?(object, false)
                    }
                    else if let json = json as? NSDictionary,
                        let object = json[key] as? NSArray {
                        object.write(toFile: filePath, atomically: true)
                        success?(object, false)
                    }
                case .failure(let error):
                    failure?(error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Local cached filename for a given API route like: /api/schedule (not a url)
     
     - parameter route: API route string
     
     - returns: mapped fileName for local cached object
     */
    fileprivate static func fileForRoute(_ route: String) -> String {
        return route.replacingOccurrences(of: "/", with: "-") + ".json"
    }
    
}
