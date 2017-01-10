//
//  NotificationDetailViewController.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/23/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

private let reuseIdentifier = "NotificationDetailCell"
private let headerReuseIdentifier = "ScheduleHeader"

class NotificationDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let storyboardID = "notificationDetailsViewController"
    
    var show: Show?
    
    var tableView = UITableView()
    
    private let offsetOptions = [0, 15, 30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NotificationDetailCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(ScheduleSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        view.addConstraints(preferredConstraints())
    }
    
    func goToNavigation() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NotificationViewController.storyboardID)
        if let notificationViewController = vc as? NotificationViewController {
            navigationController?.pushViewController(notificationViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.sharedInstance.trackPageWithValue("Notifications Detail")
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offsetOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NotificationDetailCell.preferredHeight((indexPath as NSIndexPath).row == self.tableView(tableView, numberOfRowsInSection: (indexPath as NSIndexPath).section) - 1)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        /*if let cell = cell as? NotificationDetailCell {
            let lastRowInSection = ((indexPath as NSIndexPath).row == self.tableView(tableView, numberOfRowsInSection: (indexPath as NSIndexPath).section) - 1)
            cell.addBottomPadding = lastRowInSection
        }*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.clear
        return footer
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // We should only have 1 section
        if indexPath.section == 0 {
            if let detailCell = cell as? NotificationDetailCell {
                detailCell.styleFromOffset(offsetOptions[indexPath.row])
            }
        }
        
    }
    /*
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let scheduleHeader = view as? ScheduleSectionHeaderView {
            scheduleHeader.styleForString(stringForDay(section))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = showsForDay((indexPath as NSIndexPath).section)[(indexPath as NSIndexPath).row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ShowViewController.storyboardID)
        if let showViewController = vc as? ShowViewController {
            showViewController.show = show
            navigationController?.pushViewController(showViewController, animated: true)
        }
    }
    */
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let views = ["table": tableView]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: views)
        return constraints
    }
}
