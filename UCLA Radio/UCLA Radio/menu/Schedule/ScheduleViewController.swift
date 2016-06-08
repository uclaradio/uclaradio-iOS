//
//  ScheduleViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "ScheduleCell"
private let headerReuseIdentifier = "ScheduleHeader"

class ScheduleViewController: UIViewController, APIFetchDelegate, UITableViewDataSource, UITableViewDelegate {
    
    static let storyboardID = "scheduleViewController"
    
    var tableView = UITableView()
    
    var schedule: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClass(ScheduleShowCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.registerClass(ScheduleSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        
        view.backgroundColor = Constants.Colors.lightBlue
        
        view.addConstraints(preferredConstraints())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RadioAPI.fetchSchedule(self)
        scrollToToday()
    }
    
    func today() -> Int {
        var day =  NSCalendar.currentCalendar().component(.Weekday, fromDate: NSDate())
//        var hour =  NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        // convert from Apple format (Sunday starting) to our format (Monday starting)
        day -= 2
        if (day < 0) {
            day += 7
        }
        return day
    }
    
    func showsForDay(day: Int) -> [Show] {
        if let schedule = schedule {
            switch(day) {
            case 0:
                return schedule.monday
            case 1:
                return schedule.tuesday
            case 2:
                return schedule.wednesday
            case 3:
                return schedule.thursday
            case 4:
                return schedule.friday
            case 5:
                return schedule.saturday
            case 6:
                return schedule.sunday
            default:
                break
            }
        }
        return []
    }
    
    func stringForDay(day:Int) -> String {
        switch(day) {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
        case 6:
            return "Sunday"
        default:
            return ""
        }
    }
    
    // MARK: - API Fetch Delegate
    
    func cachedDataAvailable(data: AnyObject) {
        if let schedule = data as? Schedule {
            self.schedule = schedule
            tableView.reloadData()
            scrollToToday()
        }
    }
    
    func didFetchData(data: AnyObject) {
        if let schedule = data as? Schedule {
            self.schedule = schedule
            tableView.reloadData()
            scrollToToday()
        }
    }
    
    func failedToFetchData(error: String) {
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsForDay(section).count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ScheduleShowCell.height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerReuseIdentifier)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.clearColor()
        return footer
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let shows = showsForDay(indexPath.section)
        if let showCell = cell as? ScheduleShowCell {
            showCell.styleFromShow(shows[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let scheduleHeader = view as? ScheduleSectionHeaderView {
            scheduleHeader.styleForString(stringForDay(section))
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let show = showsForDay(indexPath.section)[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ShowViewController.storyboardID)
        if let showViewController = vc as? ShowViewController {
            showViewController.show = show
            navigationController?.pushViewController(showViewController, animated: true)
        }
    }
    
    // MARK: - Layout
    
    func scrollToToday() {
        if (showsForDay(today()).count > 0) {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: today()), atScrollPosition: .Top, animated: false)
        }
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let views = ["table": tableView]
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[table]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[table]|", options: [], metrics: nil, views: views)
        return constraints
    }
    
}
