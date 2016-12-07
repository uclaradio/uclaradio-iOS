//
//  DateComponentsFormatter+String.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 11/2/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
    
    // Expect string of format of "1pm"
    func getHourComponentFromString(_ s: String) -> Int? {

        let stringHour = s.substring(to: s.index(before: s.index(s.endIndex, offsetBy: -1)))
        if var hour = Int(stringHour) {
            if s.hasSuffix("am") && hour == 12 {
                hour = 0
            } else if s.hasSuffix("pm") && hour != 12 {
                hour += 12
            }

            return hour
        }
        return nil
    }
    
    func getWeekdayComponentFromString(_ s: String) -> Int? {
        var weekday:Int?
        
        switch s {
        case "Sun": weekday = 1
        case "Mon": weekday = 2
        case "Tue": weekday = 3
        case "Wed": weekday = 4
        case "Thu": weekday = 5
        case "Fri": weekday = 6
        case "Sat": weekday = 7
        default: weekday = nil
        }
        
        return weekday
    }
}
