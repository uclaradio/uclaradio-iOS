//
//  Giveaway.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 10/1/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation

class Giveaway {
    let summary: String
    let date: String
    
    init(summary: String, date: String) {
        self.summary = summary
        self.date = date
    }
    
    static func formattedDateFromRawString(rawString: String) -> String? {
        guard let day = Int(rawString) else {
            return nil
        }
        
        if 11...13 ~= day {
            return "\(day)th"
        } else if day % 10 == 1 {
            return "\(day)st"
        } else if day % 10 == 2 {
            return "\(day)nd"
        } else if day % 10 == 3 {
            return "\(day)rd"
        }
        return "\(day)th"
    }
    
    static func giveawaysFromJSON(rawGiveaways: NSArray) -> [String: [Giveaway]] {
        var giveaways = [String: [Giveaway]]()
        
        // regex patterns
        // date format: 2016-10-05T07:00:00.000Z
        let searchPattern = "\\d{4}-\\d+-(\\d+)T\\d+:\\d+:\\d+.\\d+Z"
        let replacementPattern = "$1"
        do {
            let regex = try NSRegularExpression(pattern: searchPattern, options: [])
            
            for rawGiveaway: AnyObject in rawGiveaways {
                if let monthDict = rawGiveaway as? NSDictionary,
                    currentMonth = monthDict["month"] as? String,
                    monthGiveaways = monthDict["arr"] as? NSArray {
                    
                    // giveaways for given month
                    var month = [Giveaway]()
                    for monthGiveaway: AnyObject in monthGiveaways {
                        if let monthGiveaway = monthGiveaway as? NSDictionary,
                            summary = monthGiveaway["summary"] as? String,
                            rawDate = monthGiveaway["start"] as? String {
                            
                            let day = NSMutableString(string: rawDate)
                            regex.replaceMatchesInString(day, options: [], range: NSRange(location: 0, length: rawDate.characters.count), withTemplate: replacementPattern)
                            let date = formattedDateFromRawString(day.substringFromIndex(0)) ?? ""
                            month.append(Giveaway(summary: summary, date: date))
                        }
                    }
                    
                    giveaways[currentMonth] = month
                }
            }
        } catch let error as NSError {
            print("Giveaway regex error: \(error.localizedDescription)")
        }
        
        return giveaways
    }
    
}