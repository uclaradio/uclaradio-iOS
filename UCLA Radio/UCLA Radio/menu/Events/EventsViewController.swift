//
//  EventsViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 10/1/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class EventsViewController: UIViewController, APIFetchDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView(frame: CGRectZero, style: .Grouped)
    
    static let storyboardID = "eventsViewController"
    
    private let reuseIdentifier = "GiveawayCell"
    
    var events: [String: [Giveaway]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.lightBlue
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = Constants.Colors.reallyDarkBlue
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(GiveawayTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(preferredConstraints())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RadioAPI.fetchGiveaways(self)
    }
    
    // MARK: - APIFetchDelegate
    
    func cachedDataAvailable(data: AnyObject) {
        if let data = data as? [String: [Giveaway]] {
            events = data
            tableView.reloadData()
        }
    }
    
    func didFetchData(data: AnyObject) {
        if let data = data as? [String: [Giveaway]] {
            events = data
            tableView.reloadData()
        }
    }
    
    func failedToFetchData(error: String) {
        // no-op
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let events = events {
            return events.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            let months = [String](events.keys)
            return events[months[section]]?.count ?? 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let events = events {
            let months = [String](events.keys)
            return months[section] ?? nil
        }
        return nil
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let events = events {
            let months = [String](events.keys)
            if let event = events[months[indexPath.section]]?[indexPath.row],
                giveawayCell = cell as? GiveawayTableViewCell {
                
                giveawayCell.styleForGiveaway(event)
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // TO DO
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView])
        
        return constraints
    }
    
}
