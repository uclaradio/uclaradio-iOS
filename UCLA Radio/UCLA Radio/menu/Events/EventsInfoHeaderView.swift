//
//  EventsInfoHeaderView.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 10/4/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import UIKit

class EventsInfoHeaderView: UITableViewHeaderFooterView, APIFetchDelegate {

    let label = UILabel()
    
    // returned from server, default value:
    static var info: String = "We give a lot of tickets away to our listeners.. Tune in and follow us on Facebook and Instagram for your chance to see these shows!"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(preferredConstraints())
        
        RadioAPI.fetchGiveawayDescription(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style() {
        label.text = EventsInfoHeaderView.info;
    }
    
    // MARK: - APIFetchDelegate
    
    func cachedDataAvailable(_ data: Any) {
        if let info = data as? String {
            EventsInfoHeaderView.info = info
            style()
        }
    }
    
    func didFetchData(_ data: Any) {
        if let info = data as? String {
            EventsInfoHeaderView.info = info
            style()
        }
    }
    
    func failedToFetchData(_ error: String) {
        
    }
    
    // MARK: - Layout
    
    static func preferredHeight() -> CGFloat {
        return 120.0
    }
    
    private func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        let metrics = ["pad": Constants.Floats.menuOffset]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": label])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(pad)-[label]-(pad)-|", options: [], metrics: metrics, views: ["label": label])
        
        return constraints
    }

}
