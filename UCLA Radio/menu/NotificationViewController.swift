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

    private var editBarButtonItem: UIBarButtonItem?
    private var cancelBarButtonItem: UIBarButtonItem?
    private var deleteBarButtonItem: UIBarButtonItem?
    
    var notificationSchedule: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() // Hide extra separators at end of UITableView
        tableView.register(ScheduleSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = true
        RadioAPI.fetchSchedule(self)

        editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEdit))
        cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(toggleEdit))
        deleteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(commitEdit))

        deleteBarButtonItem?.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.sharedInstance.trackPageWithValue("Notifications")
        if let notificationSchedule = notificationSchedule {
            updateNotificationSchedule(notificationSchedule)
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
        return notificationSchedule?.showsForDay(section).count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let dayEmpty = notificationSchedule?.showsForDay(section).isEmpty,
            dayEmpty {
            return 0
        }
        return ScheduleSectionHeaderView.height
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
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
        if let show = notificationSchedule?.showForIndexPath(indexPath) {
            cell.textLabel?.text = show.title
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
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let scheduleHeader = view as? ScheduleSectionHeaderView {
            let dayString = Schedule.stringForDay(section)
            scheduleHeader.styleForString(dayString)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.isEditing) {
            return
        }

        tableView.deselectRow(at: indexPath, animated: true)

        if let show = notificationSchedule?.showForIndexPath(indexPath) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NotificationDetailsViewController.storyboardID)
            if let notificationDetailViewController = vc as? NotificationDetailsViewController {
                notificationDetailViewController.show = show
                notificationDetailViewController.title = show.title
                navigationController?.pushViewController(notificationDetailViewController, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let show = notificationSchedule?.showForIndexPath(indexPath),
            editingStyle == .delete {
            NotificationManager.sharedInstance.removeAllNotificationsForShow(show)
            notificationSchedule?.removeShow(show)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Editing

    @objc func toggleEdit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItem = tableView.isEditing ? deleteBarButtonItem : editBarButtonItem
        navigationItem.leftBarButtonItem = tableView.isEditing ? cancelBarButtonItem : navigationItem.backBarButtonItem
    }

    @objc func commitEdit() {
        if tableView.isEditing {
            // delete notifications for selected shows
            let selectedRows = tableView.indexPathsForSelectedRows ?? []
            let selectedShows: [Show] = selectedRows.map { indexPath in
                notificationSchedule?.showForIndexPath(indexPath)
                }.compactMap({$0})
            NotificationManager.sharedInstance.removeAllNotificationsForShows(selectedShows)
            notificationSchedule?.removeShows(selectedShows)
            tableView.deleteRows(at: selectedRows, with: .fade)
        }
        toggleEdit()
    }
    
    // MARK: - Helper Functions
    
    private func updateNotificationSchedule(_ data: Any) {
        if let updatedSchedule = data as? Schedule {
            notificationSchedule = updatedSchedule
            for day in notificationSchedule?.week() ?? [] {
                for show in day {
                    if !NotificationManager.sharedInstance.areNotificationsOnForShow(show) {
                        notificationSchedule?.removeShow(show)
                    }
                }
            }
            tableView.reloadData()
        }
    }
}
