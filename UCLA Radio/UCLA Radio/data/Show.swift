//
//  Show.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation

class Show {
    let id: Int
    let title: String
    let day: String
    let time: String
    var djs: [DJ]?
    var genre: String?
    var blurb: String?
    var picture: String? // url to picture on server
    
    init(id: Int, title: String, day: String, time: String) {
        self.id = id
        self.title = title
        self.day = day
        self.time = time
    }
    
    static func showsFromJSON(shows: NSArray) -> [Show] {
        var result: [Show] = []
        for showObject: AnyObject in shows {
            if let show = showObject as? NSDictionary, let id = show["id"] as? Int, let title = show["title"] as? String, let day = show["day"] as? String, let time = show["time"] as? String {
                result.append(Show(id: id, title: title, day: day, time: time))
            }
        }
        return result
    }
}
