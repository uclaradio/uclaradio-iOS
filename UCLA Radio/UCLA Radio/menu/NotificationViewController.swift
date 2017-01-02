//
//  NotificationViewController
//  UCLA Radio
//
//  Created by Nathan Smith on 12/20/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation

private let reuseIdentifier = "NotificationCell"
private let headerReuseIdentifier = "ScheduleHeader"

class NotificationViewController: ScheduleViewController {
    
    override class var storyboardID:String { return "notificationViewController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil
        // Redo this so that it's with NotificationShowCell, not ScheduleShowCell
        tableView.register(NotificationShowCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.sharedInstance.trackPageWithValue("Notifications")
    }
    
    // MARK: - API Fetch Delegate
    
    override func cachedDataAvailable(_ data: Any) {
        handleData(data)
    }
    
    override func didFetchData(_ data: Any) {
        handleData(data)
    }

    private func handleData(_ data: Any) {
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
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NotificationShowCell.preferredHeight((indexPath as NSIndexPath).row == self.tableView(tableView, numberOfRowsInSection: (indexPath as NSIndexPath).section) - 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? NotificationShowCell {
            let lastRowInSection = ((indexPath as NSIndexPath).row == self.tableView(tableView, numberOfRowsInSection: (indexPath as NSIndexPath).section) - 1)
            cell.addBottomPadding = lastRowInSection
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let shows = showsForDay((indexPath as NSIndexPath).section)
        if let showCell = cell as? NotificationShowCell {
            showCell.styleFromShow(shows[(indexPath as NSIndexPath).row])
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete!")
        }
    }
    
    
}
