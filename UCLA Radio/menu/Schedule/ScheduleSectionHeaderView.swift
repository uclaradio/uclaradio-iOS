//
//  ScheduleSectionHeader.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/6/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

class ScheduleSectionHeaderView: UITableViewHeaderFooterView {
    
    static let height: CGFloat = 30
    
    let label = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Constants.Colors.darkPink
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Fonts.titleBold, size: 16)
        label.textColor = UIColor.white
        
        addConstraints(preferredConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleForString(_ title: String) {
        label.text = title
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let views = ["label": label]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views)
        
        return constraints
    }
    
}
