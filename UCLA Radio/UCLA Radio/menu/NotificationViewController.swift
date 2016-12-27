//
//  NotificationViewController
//  UCLA Radio
//
//  Created by Nathan Smith on 12/20/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

class NotificationViewController: ScheduleBaseViewController  {
    
    private let reuseIdentifier = "NotificationCell"
    
    static let storyboardID = "notificationViewController"

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
    
    func handleData(_ data: Any) {
        if let schedule = data as? Schedule {
            self.schedule = schedule
            for day in 0...7 {
                for show in showsForDay(day) {
                    if !UserDefaults.standard.bool(forKey: show.title + "-switchState") {
                        self.schedule?.removeShow(show)
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if showsForDay(section).isEmpty {
            return 0
        }
        return ScheduleSectionHeaderView.height
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let show = showsForDay((indexPath as NSIndexPath).section)[(indexPath as NSIndexPath).row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NotificationDetailsViewController.storyboardID)
        if let notificationDetailViewController = vc as? NotificationDetailsViewController {
            notificationDetailViewController.show = show
            navigationController?.pushViewController(notificationDetailViewController, animated: true)
        }
    }
}
