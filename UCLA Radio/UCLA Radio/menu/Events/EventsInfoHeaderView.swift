//
//  EventsInfoHeaderView.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 10/4/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import UIKit

class EventsInfoHeaderView: UITableViewHeaderFooterView {

    let label = UILabel()
    
    static let info = "We're always hosting events and doing giveaways. Listen and follow us on Facebook and Instagram for your chance to win tickets!"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(preferredConstraints())
        
        label.text = EventsInfoHeaderView.info;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
