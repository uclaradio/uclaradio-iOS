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
            let date = show.getClosestDateOfShow()
            let weekday = Calendar.current.component(.weekday, from: date)
        
            switch weekday {
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
        return shows.sorted { $0.getClosestDateOfShow() < $1.getClosestDateOfShow() }
    }
}
