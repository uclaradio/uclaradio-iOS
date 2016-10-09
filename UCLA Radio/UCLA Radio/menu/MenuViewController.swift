//
//  MenuViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "MenuCell"
private let headerReuseIdentifier = "MenuHeaderView"
private let sectionInset: CGFloat = 25
private let itemSpacing: CGFloat = 15
private let atractiveColorSchemes = ["BuGn", "BuPu", "RdPu", "Reds", "Oranges","Greens", "Blues", "Purples", "PuRd"]

class MenuItem {
    let title: String
    let storyboardID: String? // storyboard ID for view controller to push when tapped (or nil)
    
    init(title: String, storyboardID: String?) {
        self.title = title
        self.storyboardID = storyboardID
    }
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate let items = [
        MenuItem(title: "Schedule", storyboardID: ScheduleViewController.storyboardID),
        MenuItem(title: "DJs", storyboardID: DJListViewController.storyboardID),
        MenuItem(title: "Tickets", storyboardID: EventsViewController.storyboardID),
        MenuItem(title: "About", storyboardID: AboutViewController.storyboardID)
    ]
    
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var triangleView: TrianglifyView!
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        triangleView = TrianglifyView()
        view.addSubview(triangleView)
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.alwaysBounceVertical = true
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(MenuSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(preferredConstraints())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
        
        // randomly set color scheme
        triangleView.colorScheme = atractiveColorSchemes[Int(arc4random_uniform(UInt32(atractiveColorSchemes.count)))]
        
        // track view analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Menu / Now Playing")
        let builder = GAIDictionaryBuilder.createScreenView()
        if let builder = builder {
            tracker?.send(builder.build() as [NSObject : AnyObject])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
    
    // MARK: - Actions
    
    func pushViewController(_ storyboardID: String) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardID)
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MenuTableViewCell.preferredHeight()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = items[(indexPath as NSIndexPath).row]
        if let menuCell = cell as? MenuTableViewCell {
            menuCell.styleForMenuItem(item)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[(indexPath as NSIndexPath).row]
        if let storyboardID = item.storyboardID {
            pushViewController(storyboardID)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MenuSectionHeaderView.preferredHeight()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        // table view
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: ["table": tableView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: [], metrics: nil, views: ["table": tableView])
        
        // trianglify view
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[triangles]|", options: [], metrics: nil, views: ["triangles": triangleView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[triangles]|", options: [], metrics: nil, views: ["triangles": triangleView])
        
        return constraints
    }
    
}
