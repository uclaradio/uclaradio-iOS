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
    
    func getClosestDateOfShow() -> Date {
        let previous = getPreviousDateOfShow()
        let next = getNextDateOfShow()
        
        if abs(next.timeIntervalSinceNow) < abs(previous.timeIntervalSinceNow) {
            return next
        } else {
            return previous
        }
    }
    
    func getPreviousDateOfShow() -> Date {
        let nextShow = getNextDateOfShow()
        let components = DateComponents(day: -7)
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = self.time.timeZone!
        return calendar.date(byAdding: components, to: nextShow)!
    }
    
    func getNextDateOfShow() -> Date {
        let now = Date()
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = self.time.timeZone!
        return calendar.nextDate(after: now, matching: self.time, options: [.matchNextTime])!
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
            //let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "EEEHa"
            //let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            
            //let date = dateFormatter.date(from: day+time)!
            //print("date: \(date)")
            
            //var components = gregorianCalendar.components([.hour, .weekday], from: date)
            
            
            var components = DateComponents()
            components.timeZone = TimeZone(identifier: "America/Los_Angeles")
            components.hour = formatter.getHourComponentFromString(time)
            components.weekday = formatter.getWeekdayComponentFromString(day)
   
            let newShow = Show(id: id, title: title, time: components, djs: djs)

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
