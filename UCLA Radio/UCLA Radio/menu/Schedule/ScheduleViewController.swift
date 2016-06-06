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
    
    var schedule: Schedule?
    
    // temp solution for presentation
    var dayVC: ScheduleDayViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // temp
        title = "Schedule (" + currentWeekday() + ")"
        
//        view.backgroundColor = UIColor.greenColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RadioAPI.fetchSchedule(self)
    }
    
//    func styleFromShows(shows: [Show]) {
//        print("got shows:")
//        for show in shows {
//            print("* \(show.title)")
//        }
//        self.shows = shows
//    }
    
    func currentWeekday() -> String {
        let strings = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let c = NSCalendar.currentCalendar().component(.Weekday, fromDate: NSDate())
        return strings[c-1]
    }
    
    // temp solution
    func setupDayVC(schedule: Schedule) {
        if let _ = dayVC {
            // do nothing
        }
        else {
            var shows: [Show]
            switch(NSCalendar.currentCalendar().component(.Weekday, fromDate: NSDate())) {
            case 1:
                shows = schedule.sunday
            case 2:
                shows = schedule.monday
            case 3:
                shows = schedule.tuesday
            case 4:
                shows = schedule.wednesday
            case 5:
                shows = schedule.thursday
            case 6:
                shows = schedule.friday
            case 7:
                shows = schedule.saturday
            default:
                shows = []
            }
            dayVC = ScheduleDayViewController(shows: shows)
            addChildViewController(dayVC!)
            view.addSubview(dayVC!.view)
            dayVC!.view.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[day]|", options: [], metrics: nil, views: ["day": dayVC!.view]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[day]|", options: [], metrics: nil, views: ["day": dayVC!.view]))
            dayVC?.didMoveToParentViewController(self)
        }
    }
    
    // MARK: - API Fetch Delegate
    
    func cachedDataAvailable(data: AnyObject) {
        if let schedule = data as? Schedule {
            setupDayVC(schedule)
        }
    }
    
    func didFetchData(data: AnyObject) {
        if let schedule = data as? Schedule {
            setupDayVC(schedule)
        }
    }
    
    func failedToFetchData(error: String) {
        
    }
    
}
