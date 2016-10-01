//
//  MenuTableViewCell.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .Center
        label.font = UIFont(name: Constants.Fonts.title, size: 21)
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(preferredConstraints())
        containerView.addConstraints(preferredContainerConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func preferredHeight() -> CGFloat {
        return 90.0
    }
    
    func styleForMenuItem(item: MenuItem) {
        label.text = item.title
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            containerView.backgroundColor = Constants.Colors.lightBackgroundHighlighted
        } else {
            containerView.backgroundColor = Constants.Colors.lightBackground
        }
    }
    
    private func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints:[NSLayoutConstraint] = []
        let metrics = ["menu": Constants.Floats.menuOffset, "container": Constants.Floats.containerOffset]
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(container)-[container]-(container)-|", options: [], metrics: metrics, views: ["container": containerView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(menu)-[container]-(menu)-|", options: [], metrics: metrics, views: ["container": containerView])
        
        return constraints
    }
    
    private func preferredContainerConstraints() -> [NSLayoutConstraint] {
        var constraints:[NSLayoutConstraint] = []
        let metrics = ["padding": Constants.Floats.containerOffset]
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: [], metrics: nil, views: ["label": label])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(padding)-[label]-(padding)-|", options: [], metrics: metrics, views: ["label": label])
        
        return constraints
    }
    
}
