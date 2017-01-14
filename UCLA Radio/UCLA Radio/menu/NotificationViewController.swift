//
//  NotificationViewController
//  UCLA Radio
//
//  Created by Nathan Smith on 12/20/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation

private let reuseIdentifier = "NotificationCell"
private let headerReuseIdentifier = "ScheduleHeader"

class NotificationViewController: BaseTableViewController, APIFetchDelegate {
    
    static let storyboardID = "notificationViewController"
    
    var schedule: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView() // Hide extra separators at end of UITableView
        tableView.register(ScheduleSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = false
        RadioAPI.fetchSchedule(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.sharedInstance.trackPageWithValue("Notifications")
        if let schedule = schedule {
            updateNotificationSchedule(schedule)
        }
    }
    
    func showsForDay(_ day: Int) -> [Show] {
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
    
    func stringForDay(_ day:Int) -> String {
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
    
    func cachedDataAvailable(_ data: Any) {
        updateNotificationSchedule(data)
    }
    
    func didFetchData(_ data: Any) {
        updateNotificationSchedule(data)
    }
    
    func failedToFetchData(_ error: String) { }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsForDay(section).count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if showsForDay(section).isEmpty {
            return 0
        }
        return ScheduleSectionHeaderView.height
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let show = schedule?.showForIndexPath(indexPath) {
            cell.textLabel?.text = show.title
            cell.detailTextLabel?.textColor = UIColor.lightGray
            let formatter = DateFormatter()
            if let notificationDates = NotificationManager.sharedInstance.datesOfWeeklyNotificationsForShow(show) {
                    var text = ""
                    for date in notificationDates {
                        text += formatter.formatDateForShow(date, format: .HourAndMinute)
                        if date != notificationDates.last {
                            text += ", "
                        }
                    }
                    cell.detailTextLabel?.text = text
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.clear
        return footer
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let shows = showsForDay((indexPath as NSIndexPath).section)
        if let showCell = cell as? ScheduleShowCell {
            showCell.styleFromShow(shows[(indexPath as NSIndexPath).row])
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let scheduleHeader = view as? ScheduleSectionHeaderView {
            scheduleHeader.styleForString(stringForDay(section))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = showsForDay((indexPath as NSIndexPath).section)[(indexPath as NSIndexPath).row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NotificationDetailsViewController.storyboardID)
        if let notificationDetailViewController = vc as? NotificationDetailsViewController {
            notificationDetailViewController.show = show
            navigationController?.pushViewController(notificationDetailViewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = showsForDay((indexPath as NSIndexPath).section)[(indexPath as NSIndexPath).row]
        if editingStyle == .delete {
            NotificationManager.sharedInstance.removeAllNotificationsForShow(show)
            self.schedule?.removeShow(show)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: Helper Functions
    
    private func updateNotificationSchedule(_ data: Any) {
        if let schedule = data as? Schedule {
            self.schedule = schedule
            for day in 0...7 {
                for show in showsForDay(day) {
                    if !NotificationManager.sharedInstance.areNotificationsOnForShow(show) {
                        self.schedule?.removeShow(show)
                    }
                }
            }
            tableView.reloadData()
        }
    }
}
