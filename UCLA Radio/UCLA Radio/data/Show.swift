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
    
    init(id: Int, title: String, day: String, time: String, djs: [DJ]?, genre: String?, blurb: String?, picture: String?) {
        self.id = id
        self.title = title
        self.day = day
        self.time = time
        self.djs = djs
        self.genre = genre
        self.blurb = blurb
        self.picture = picture
    }
    
    convenience init(id: Int, title: String, day: String, time: String) {
        self.init(id: id, title: title, day: day, time: time, djs: nil, genre: nil, blurb: nil, picture: nil)
    }
    
    static func showFromJSON(dict: NSDictionary) -> Show? {
        if let id = dict["id"] as? Int,
            let title = dict["title"] as? String,
            let day = dict["day"] as? String,
            let time = dict["time"] as? String {
            
            let newShow = Show(id: id, title: title, day: day, time: time)
            
            // optional properties
            if let genre = dict["genre"] as? String where genre.characters.count > 0 {
                newShow.genre = genre
            }
            if let blurb = dict["blurb"] as? String where blurb.characters.count > 0 {
                newShow.blurb = blurb
            }
            if let picture = dict["picture"] as? String where picture.characters.count > 0 {
                newShow.picture = picture
            }
            
            return newShow
        }
        return nil
    }
    
    static func showsFromJSON(shows: NSArray) -> [Show] {
        var result: [Show] = []
        for showObject: AnyObject in shows {
            if let dict = showObject as? NSDictionary, show = showFromJSON(dict) {
                result.append(show)
            }
        }
        return result
    }
}
