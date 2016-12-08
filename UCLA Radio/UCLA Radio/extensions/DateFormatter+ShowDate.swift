//
//  DateFormatter+ShowDate.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/6/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    enum DateFormat: String {
        case DayAndTime = "EEE ha"
        case Time = "ha"
    }
    
    // Expect string of DayAndTime DateFormat ("EEE ha")
    func formatShowTimeStringToDateComponents(_ s: String) -> DateComponents? {
        dateFormat = DateFormat.DayAndTime.rawValue
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
