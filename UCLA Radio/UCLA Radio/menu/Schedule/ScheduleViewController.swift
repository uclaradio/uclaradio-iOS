//
//  ScheduleViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class ScheduleViewController: ScheduleBaseViewController {

    static let storyboardID = "scheduleViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bell"), style: .plain, target: self, action: #selector(goToNavigation))
    }
    
    func goToNavigation() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NotificationViewController.storyboardID)
        if let notificationViewController = vc as? NotificationViewController {
            navigationController?.pushViewController(notificationViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.sharedInstance.trackPageWithValue("Schedule")
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let show = showsForDay((indexPath as NSIndexPath).section)[(indexPath as NSIndexPath).row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ShowViewController.storyboardID)
        if let showViewController = vc as? ShowViewController {
            showViewController.show = show
            navigationController?.pushViewController(showViewController, animated: true)
        }
    }
}
