//
//  DateFormatter+ShowDate.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/6/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    // See https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html for date formatting
    enum DateFormat: String {
        case DayAndHour = "EEE ha"
        case Hour = "ha"
        case HourAndMinute = "h:mma"
    }

    // Expect string of DayAndTime DateFormat ("EEE ha")
    func formatShowTimeStringToDateComponents(_ s: String) -> DateComponents? {
        dateFormat = DateFormat.DayAndHour.rawValue
        locale = Locale(identifier: "en_US")
        if let date = self.date(from: s) {
            var components = Calendar(identifier: .gregorian).dateComponents([.hour, .weekday], from: date)
            components.timeZone = TimeZone(identifier: "America/Los_Angeles")
            
            return components
        }
        return nil
    }
    
    func formatDateForShow(_ date: Date, format: DateFormat) -> String {
        amSymbol = amSymbol.lowercased()
        pmSymbol = pmSymbol.lowercased()
        dateFormat = format.rawValue
        
        return string(from: date)
    }
}
