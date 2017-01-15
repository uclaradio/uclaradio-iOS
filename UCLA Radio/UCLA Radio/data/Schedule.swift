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

    var sunday: [Show]
    var monday: [Show]
    var tuesday: [Show]
    var wednesday: [Show]
    var thursday: [Show]
    var friday: [Show]
    var saturday: [Show]

    func week() -> [[Show]] {
        return [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
    }
    
    var isEmpty: Bool {
        for day in week() {
            if !day.isEmpty {
                return false
            }
        }
        return true
    }
    
    init(sunday: [Show], monday: [Show], tuesday: [Show], wednesday: [Show], thursday: [Show], friday: [Show], saturday: [Show]) {
        self.sunday = Schedule.sortShows(sunday)
        self.monday = Schedule.sortShows(monday)
        self.tuesday = Schedule.sortShows(tuesday)
        self.wednesday = Schedule.sortShows(wednesday)
        self.thursday = Schedule.sortShows(thursday)
        self.friday = Schedule.sortShows(friday)
        self.saturday = Schedule.sortShows(saturday)
    }
    
    convenience init(shows: [Show]) {
        var sunday: [Show] = []
        var monday: [Show] = []
        var tuesday: [Show] = []
        var wednesday: [Show] = []
        var thursday: [Show] = []
        var friday: [Show] = []
        var saturday: [Show] = []
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
        self.init(sunday: sunday, monday: monday, tuesday: tuesday,
                  wednesday: wednesday, thursday: thursday,
                  friday: friday, saturday: saturday)
    }
    
    static func sortShows(_ shows: [Show]) -> [Show] {
        return shows.sorted {
            ($0.time.hour < $1.time.hour) || ($0.time.hour == $1.time.hour && $0.time.minute < $1.time.minute)
        }
    }
    
    func removeShow(_ show: Show) {
        let notEqualToShow = {$0 != show}
        sunday = sunday.filter(notEqualToShow)
        monday = monday.filter(notEqualToShow)
        tuesday = tuesday.filter(notEqualToShow)
        wednesday = wednesday.filter(notEqualToShow)
        thursday = thursday.filter(notEqualToShow)
        friday = friday.filter(notEqualToShow)
        saturday = saturday.filter(notEqualToShow)
    }

    func removeShows(_ shows: [Show]) {
        for show in shows {
            removeShow(show)
        }
    }
    
    func showWithID(_ id: Int) -> Show? {
        for day in week() {
            for show in day {
                if show.id == id {
                    return show
                }
            }
        }

        return nil
    }
    
    func showForIndexPath(_ indexPath: IndexPath) -> Show? {
        var section = 0
        for day in week() {
            if section == indexPath.section {
                guard indexPath.row < day.count else {
                    break
                }
                return day[indexPath.row]
            }
            section += 1
        }
        return nil
    }

    func showsForDay(_ day: Int) -> [Show] {
        return week()[day]
    }

    class func stringForDay(_ day:Int) -> String {
        switch(day) {
        case 0:
            return "Sunday"
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        default:
            return ""
        }
    }

}
