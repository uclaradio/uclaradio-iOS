//
//  ScheduleViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class ScheduleViewController: UIViewController, APIFetchDelegate {
    
    var shows: [Show] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.greenColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RadioAPI.fetchSchedule(self)
//        currentWeekday()
    }
    
//    func styleFromShows(shows: [Show]) {
//        print("got shows:")
//        for show in shows {
//            print("* \(show.title)")
//        }
//        self.shows = shows
//    }
    
//    func currentWeekday() {
//        let strings = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
//        let c = NSCalendar.currentCalendar().component(.Weekday, fromDate: NSDate())
//        print(strings[c-1])
//    }
    
    // MARK: - API Fetch Delegate
    
    func cachedDataAvailable(data: AnyObject) {
//        if let shows = data as? [Show] {
//            styleFromShows(shows)
//        }
    }
    
    func didFetchData(data: AnyObject) {
//        if let shows = data as? [Show] {
//            styleFromShows(shows)
//        }
    }
    
    func failedToFetchData(error: String) {
        
    }
    
}
