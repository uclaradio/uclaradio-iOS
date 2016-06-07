//
//  ScheduleSectionHeader.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/6/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

public class ScheduleSectionHeaderView: UITableViewHeaderFooterView {
    
    let label = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Constants.Colors.lightPink
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFontOfSize(16)
        label.textColor = UIColor.whiteColor()
        
        addConstraints(preferredConstraints())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleForString(title: String) {
        label.text = title
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let views = ["label": label]
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views)
        
        return constraints
    }
    
}
