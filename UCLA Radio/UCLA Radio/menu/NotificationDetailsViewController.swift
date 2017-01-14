//
//  NotificationDetailViewController.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/23/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
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
        styleCells()
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
        toggleNotificationForShow(at: indexPath)
    }
    
    // MARK: Helper Functions
    
    private func styleCells() {
        for offset in NotificationManager.sharedInstance.offsets {
            if NotificationManager.sharedInstance.areNotificationsOnForShow(show!, withOffset: offset),
                let row = convertOffsetToRow(offset) {
                toggleNotificationForShow(at: IndexPath(item: row, section: 0))
            }
        }
    }
    
    private func toggleNotificationForShow(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath),
            let offset = convertRowToOffset(indexPath.row),
            let show = self.show {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                NotificationManager.sharedInstance.removeNotificationForShow(show, withOffset: offset)
            } else {
                cell.accessoryType = .checkmark
                NotificationManager.sharedInstance.addNotificationForShow(show, withOffset: offset)
            }
        }
    }
    
    private func convertOffsetToRow(_ offset: Int) -> Int? {
        switch offset {
        case 0:
            return 0
        case -15:
            return 1
        case -30:
            return 2
        default:
            return nil
        }
    }
    
    private func convertRowToOffset(_ row: Int) -> Int? {
        switch row {
        case 0:
            return 0
        case 1:
            return -15
        case 2:
            return -30
        default:
            return nil
        }
    }
}
