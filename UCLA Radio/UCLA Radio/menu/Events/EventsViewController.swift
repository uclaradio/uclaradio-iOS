//
//  EventsViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 10/1/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

class EventsViewController: BaseViewController, APIFetchDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    static let storyboardID = "eventsViewController"
    
    fileprivate let reuseIdentifier = "GiveawayCell"
    fileprivate let headerReuseIdentifier = "GiveawayHeaderView"
    fileprivate let infoHeaderReuseIdentifier = "GiveawayInfoHeaderView"
    
    var events: [String: [Giveaway]]?
    private var expandedCellIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.lightBlue
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = Constants.Colors.reallyDarkBlue
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(GiveawayTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(EventsHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.register(EventsInfoHeaderView.self, forHeaderFooterViewReuseIdentifier: infoHeaderReuseIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(preferredConstraints())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RadioAPI.fetchGiveaways(self)
        //AnalyticsManager.sharedInstance.trackPageWithValue("Events")
    }
    
    // MARK: - APIFetchDelegate
    
    func cachedDataAvailable(_ data: Any) {
        if let data = data as? [String: [Giveaway]] {
            events = data
            expandedCellIndex = nil
            tableView.reloadData()
        }
    }
    
    func didFetchData(_ data: Any) {
        if let data = data as? [String: [Giveaway]] {
            events = data
            expandedCellIndex = nil
            tableView.reloadData()
        }
    }
    
    func failedToFetchData(_ error: String) {
        // no-op
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let events = events {
            return events.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 0
        default:
            if let events = events {
                let months = Giveaway.sortedMonths(months: [String](events.keys))
                return events[months[section-1]]?.count ?? 0
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch(section) {
        case 0:
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: infoHeaderReuseIdentifier)
            if let infoCell = cell as? EventsInfoHeaderView {
                infoCell.style()
            }
            return cell
        default:
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GiveawayTableViewCell.preferredHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch(section) {
        case 0:
            return EventsInfoHeaderView.preferredHeight()
        default:
            return EventsHeaderView.preferredHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let events = events {
            let months = Giveaway.sortedMonths(months: [String](events.keys))
            if let event = events[months[(indexPath as NSIndexPath).section-1]]?[(indexPath as NSIndexPath).row],
                let giveawayCell = cell as? GiveawayTableViewCell {
                
                giveawayCell.styleForGiveaway(event, infoToggled: (indexPath == expandedCellIndex))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch(section) {
        case 0:
            break
        default:
            if let events = events,
                let view = view as? EventsHeaderView {
                let months = Giveaway.sortedMonths(months: [String](events.keys))
                view.style(month: months[section-1])
            }
        }
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView])
        
        return constraints
    }
    
}
