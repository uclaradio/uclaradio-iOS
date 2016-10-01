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
    
    init(title: String, image: String, storyboardID: String?) {
        self.title = title
        self.storyboardID = storyboardID
    }
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let items = [MenuItem(title: "Schedule", image: "schedule", storyboardID: ScheduleViewController.storyboardID),
                         MenuItem(title: "DJs", image: "djs", storyboardID: DJListViewController.storyboardID),
                         MenuItem(title: "About", image: "about", storyboardID: AboutViewController.storyboardID)]
    
    var tableView = UITableView(frame: CGRectZero, style: .Grouped)
    var triangleView: TrianglifyView!
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        triangleView = TrianglifyView()
        view.addSubview(triangleView)
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.alwaysBounceVertical = true
        tableView.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.registerClass(MenuSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .None
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(preferredConstraints())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
        
        // randomly set color scheme
        triangleView.colorScheme = atractiveColorSchemes[Int(arc4random_uniform(UInt32(atractiveColorSchemes.count)))]
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
    
    // MARK: - Actions
    
    func pushViewController(storyboardID: String) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MenuTableViewCell.preferredHeight()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        if let menuCell = cell as? MenuTableViewCell {
            menuCell.styleForMenuItem(item)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let item = items[indexPath.row]
        if let storyboardID = item.storyboardID {
            pushViewController(storyboardID)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MenuSectionHeaderView.preferredHeight()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerReuseIdentifier)
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        // table view
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[table]|", options: [], metrics: nil, views: ["table": tableView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[table]|", options: [], metrics: nil, views: ["table": tableView])
        
        // trianglify view
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[triangles]|", options: [], metrics: nil, views: ["triangles": triangleView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[triangles]|", options: [], metrics: nil, views: ["triangles": triangleView])
        
        return constraints
    }
    
}
