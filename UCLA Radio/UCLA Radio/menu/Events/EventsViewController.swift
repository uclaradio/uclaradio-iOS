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
    
    var events: [String: [Giveaway]]?
    
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
            tableView.reloadData()
        }
    }
    
    func didFetchData(_ data: Any) {
        if let data = data as? [String: [Giveaway]] {
            events = data
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let events = events {
            let months = [String](events.keys)
            return months[section]
        }
        return nil
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GiveawayTableViewCell.preferredHeight()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let events = events {
            let months = [String](events.keys)
            if let event = events[months[(indexPath as NSIndexPath).section]]?[(indexPath as NSIndexPath).row],
                let giveawayCell = cell as? GiveawayTableViewCell {
                
                giveawayCell.styleForGiveaway(event)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TO DO
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView])
        
        return constraints
    }
    
}
