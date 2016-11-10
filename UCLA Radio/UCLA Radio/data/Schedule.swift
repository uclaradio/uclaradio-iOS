//
//  Schedule.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/4/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class Schedule {
    let monday: [Show]
    let tuesday: [Show]
    let wednesday: [Show]
    let thursday: [Show]
    let friday: [Show]
    let saturday: [Show]
    let sunday: [Show]
    
    init(monday: [Show], tuesday: [Show], wednesday: [Show], thursday: [Show], friday: [Show], saturday: [Show], sunday: [Show]) {
        self.monday = Schedule.sortShows(monday)
        self.tuesday = Schedule.sortShows(tuesday)
        self.wednesday = Schedule.sortShows(wednesday)
        self.thursday = Schedule.sortShows(thursday)
        self.friday = Schedule.sortShows(friday)
        self.saturday = Schedule.sortShows(saturday)
        self.sunday = Schedule.sortShows(sunday)
    }
    
    convenience init(shows: [Show]) {
        var monday: [Show] = []
        var tuesday: [Show] = []
        var wednesday: [Show] = []
        var thursday: [Show] = []
        var friday: [Show] = []
        var saturday: [Show] = []
        var sunday: [Show] = []
        for show in shows {
            switch show.time.weekday! {
            case 1:
                sunday.append(show)
            case 2:
                monday.append(show)
            case 3:
                tuesday.append(show)
            case 4:
                wednesday.append(show)
            case 5:
                thursday.append(show)
            case 6:
                friday.append(show)
            case 7:
                saturday.append(show)
            default:
                break
            }
        }
        self.init(monday: monday, tuesday: tuesday,
                  wednesday: wednesday, thursday: thursday,
                  friday: friday, saturday: saturday, sunday: sunday)
    }
    
    static func sortShows(_ shows: [Show]) -> [Show] {
        return shows.sorted { $0.time.hour < $1.time.hour }
    }
    
    /*
    static func sortShows(_ shows: [Show]) -> [Show] {
        var shows = shows
        shows.sort { (a, b) -> Bool in
            var aMatch = matches(for: "[0-9]*", in: a.time)
            var bMatch = matches(for: "[0-9]*", in: b.time)
            let aTime = (Int(aMatch[0]) ?? 0) % 12
            let bTime = (Int(bMatch[0]) ?? 0) % 12
            
            if let _ = a.time.range(of: "am", options: .regularExpression) {
                if let _ = b.time.range(of: "am", options: .regularExpression) {
                    return aTime < bTime
                }
                else {
                    return true
                }
            }
            else {
                if let _ = b.time.range(of: "am", options: .regularExpression) {
                    return false
                }
                else {
                    return aTime < bTime
                }
            }
        }
        return shows
    }
    
    static func matches(for regex: String!, in text: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options:[], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    */
    
}
