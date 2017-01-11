//
//  NotificationDetailViewController.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/23/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

private let reuseIdentifier = "NotificationDetailCell"
private let headerReuseIdentifier = "ScheduleHeader"

class NotificationDetailsViewController: BaseTableViewController {
    
    static let storyboardID = "notificationDetailsViewController"
    
    var show: Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView() // Hide extra separators at end of UITableView
        tableView.register(ScheduleSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.sharedInstance.trackPageWithValue("Notifications Details")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ScheduleSectionHeaderView.height
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let scheduleHeader = view as? ScheduleSectionHeaderView {
            scheduleHeader.styleForString("Remind Me:")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var offset = 0
        
        switch indexPath.row {
        case 0:
            offset = 0
        case 1:
            offset = -15
        case 2:
            offset = -30
        default:
            break
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                NotificationManager.sharedInstance.removeNotificationForShow(show!, withOffset: offset)
            } else {
                cell.accessoryType = .checkmark
                NotificationManager.sharedInstance.addNotificationForShow(show!, withOffset: offset)
            }
        }
    }
}
