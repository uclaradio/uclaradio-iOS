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
private let scheduleRoute = "/api/schedule"
private let djRoute = "/api/djs"

protocol APIFetchDelegate {
    func cachedDataAvailable(data: AnyObject)
    func didFetchData(data: AnyObject)
    func failedToFetchData(error: String)
}

class RadioAPI {
    
    static var scheduleCache: [Show]?
    static var djListCache: [DJ]?
    
    static func fetchSchedule(delegate: APIFetchDelegate?) {
        if let cache = scheduleCache {
            delegate?.cachedDataAvailable(cache)
        }
        
        Alamofire.request(.GET, host+scheduleRoute).validate().responseJSON { response in
            switch response.result {
            case .Success(let json):
                if let shows = json["shows"] as? NSArray {
                    scheduleCache = Show.showsFromJSON(shows)
                    delegate?.didFetchData(scheduleCache!)
                }
            case .Failure(let error):
                delegate?.failedToFetchData(error.localizedDescription)
                print(error)
            }
        }
    }
    
    static func fetchDJList(delegate: APIFetchDelegate?) {
        if let cache = djListCache {
            delegate?.cachedDataAvailable(cache)
        }
        
        Alamofire.request(.GET, host+djRoute).validate().responseJSON { response in
            switch response.result {
            case .Success(let json):
                if let djs = json["djs"] as? NSArray {
                    djListCache = DJ.djsFromJSON(djs)
                    delegate?.didFetchData(djListCache!)
                }
            case .Failure(let error):
                delegate?.failedToFetchData(error.localizedDescription)
                print(error)
            }
        }
    }
    
}
