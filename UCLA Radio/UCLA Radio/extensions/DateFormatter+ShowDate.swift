//
//  DateFormatter+ShowDate.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/6/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    enum DateFormat {
        case DayAndTime, Time
    }
    
    func formatDateForShow(_ date: Date, format: DateFormat) -> String {
        amSymbol = amSymbol.lowercased()
        pmSymbol = pmSymbol.lowercased()
        
        switch format {
        case .DayAndTime:
            // Format: Shorterned day of week (EEE), Shortened 12 hour (h), AM/PM (a)
            dateFormat = "EEE ha"
        case .Time:
            // Format: Shortened 12 hour (h), AM/PM (a)
            dateFormat = "ha"
        }
        
        return string(from: date)
    }
}
