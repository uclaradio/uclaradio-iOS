//
//  Schedule.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/4/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
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

    var monday: [Show]
    var tuesday: [Show]
    var wednesday: [Show]
    var thursday: [Show]
    var friday: [Show]
    var saturday: [Show]
    var sunday: [Show]
    
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
    
    func removeShow(_ show: Show) {
        let notEqualToShow = {$0 != show}
        monday = monday.filter(notEqualToShow)
        tuesday = tuesday.filter(notEqualToShow)
        wednesday = wednesday.filter(notEqualToShow)
        thursday = thursday.filter(notEqualToShow)
        friday = friday.filter(notEqualToShow)
        saturday = saturday.filter(notEqualToShow)
        sunday = sunday.filter(notEqualToShow)
    }
    
    func showWithID(_ id: Int) -> Show? {
        for day in [sunday, monday, tuesday, wednesday, thursday, friday, saturday] {
            for show in day {
                if show.id == id {
                    return show
                }
            }
        }

        return nil
    }
    
    func showForIndexPath(_ indexPath: IndexPath) -> Show? {
        var section = -1
        for day in [sunday, monday, tuesday, wednesday, thursday, friday, saturday] {
            if !day.isEmpty {
                section += 1
            }
            if section == indexPath.section {
                guard indexPath.row < day.count else {
                    break
                }
                return day[indexPath.row]
            }
        }
        return nil
    }
}
