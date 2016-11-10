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
    let time: DateComponents
    let djString: String
    var djs: [String]?
    var genre: String?
    var blurb: String?
    var picture: String? // url to picture on server
    
    init(id: Int, title: String, time: DateComponents, djs: [String], genre: String?, blurb: String?, picture: String?) {
        self.id = id
        self.title = title
        self.time = time
        self.genre = genre
        self.blurb = blurb
        self.picture = picture
        self.djs = djs
        self.djString = Show.makeDjsString(djs)
    }
    
    convenience init(id: Int, title: String, time: DateComponents, djs: [String]) {
        self.init(id: id, title: title, time: time, djs: djs, genre: nil, blurb: nil, picture: nil)
    }
    
    static func showFromJSON(_ dict: NSDictionary) -> Show? {
        if let id = dict["id"] as? Int,
            let title = dict["title"] as? String,
            let day = dict["day"] as? String,
            let time = dict["time"] as? String {
            
            var djs: [String] = [];
            if let djsDict = dict["djs"] as? NSDictionary {
                for o in djsDict.allKeys {
                    if let username = o as? String, let dj = djsDict[username] as? String {
                        djs.append(dj)
                    }
                }
            }
            
            let formatter = DateComponentsFormatter()
            let calendar = Calendar.current
            let now = Date()
            let weekdayToday = calendar.component(.weekday, from: now)
            let weekdayOfShow = formatter.getWeekdayComponentFromString(day)!
            
            let daysToShow = ((7 + weekdayOfShow) - weekdayToday) % 7
            
            let nextShowDate = calendar.date(byAdding: .day, value: daysToShow, to: now)!
            var nextShowComponents = calendar.dateComponents([.month, .day, .year], from: nextShowDate)
            nextShowComponents.hour = formatter.getHourComponentFromString(time)
            nextShowComponents.weekday = weekdayOfShow
            nextShowComponents.timeZone = TimeZone(identifier: "America/Los_Angeles")
            
            
            let newShow = Show(id: id, title: title, time: nextShowComponents, djs: djs)
            
            print("Show \(newShow.title) with time \(newShow.time.hour) at \(newShow.time.weekday)")
            
            // optional properties
            if let genre = dict["genre"] as? String , genre.characters.count > 0 {
                newShow.genre = genre
            }
            if let blurb = dict["blurb"] as? String , blurb.characters.count > 0 {
                newShow.blurb = blurb
            }
            if let picture = dict["picture"] as? String , picture.characters.count > 0 {
                newShow.picture = picture
            }
            
            return newShow
        }
        return nil
    }
    
    static func showsFromJSON(_ shows: NSArray) -> [Show] {
        var result: [Show] = []
        for showObject: Any in shows {
            if let dict = showObject as? NSDictionary, let show = showFromJSON(dict) {
                result.append(show)
            }
        }
        return result
    }
    
    static func makeDjsString(_ djs: [String]) -> String {
        var result = ""
        var comma = false
        for dj: String in djs {
            if (comma) {
                result += ", "
            }
            result += dj
            comma = true
        }
        return result
    }
}
