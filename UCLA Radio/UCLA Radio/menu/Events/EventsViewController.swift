//
//  EventsViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 10/1/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class EventsViewController: BaseViewController, APIFetchDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    static let storyboardID = "eventsViewController"
    
    fileprivate let reuseIdentifier = "GiveawayCell"
    fileprivate let headerReuseIdentifier = "GiveawayHeaderView"
    
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
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(preferredConstraints())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RadioAPI.fetchGiveaways(self)
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
            return events.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            let months = [String](events.keys)
            return events[months[section]]?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GiveawayTableViewCell.preferredHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return EventsHeaderView.preferredHeight()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let events = events {
            let months = [String](events.keys)
            if let event = events[months[(indexPath as NSIndexPath).section]]?[(indexPath as NSIndexPath).row],
                let giveawayCell = cell as? GiveawayTableViewCell {
                
                giveawayCell.styleForGiveaway(event, infoToggled: (indexPath == expandedCellIndex))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let events = events,
            let view = view as? EventsHeaderView {
            let months = [String](events.keys)
            view.style(month: months[section])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var reloadIndexPaths = [indexPath] as [IndexPath]
        if indexPath != expandedCellIndex {
            if let expandedCellIndex = expandedCellIndex {
                reloadIndexPaths.append(expandedCellIndex)
            }
            expandedCellIndex = indexPath
        } else {
            expandedCellIndex = nil
        }
        tableView.reloadRows(at: reloadIndexPaths, with: .none)
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView])
        
        return constraints
    }
    
}