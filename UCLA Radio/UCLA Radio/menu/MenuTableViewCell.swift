//
//  MenuTableViewCell.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 21)
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
    
    func styleForMenuItem(_ item: MenuItem) {
        label.text = item.title
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            containerView.backgroundColor = Constants.Colors.lightBackgroundHighlighted
        } else {
            containerView.backgroundColor = Constants.Colors.lightBackground
        }
    }
    
    fileprivate func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints:[NSLayoutConstraint] = []
        let metrics = ["menu": Constants.Floats.menuOffset, "container": Constants.Floats.containerOffset]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(container)-[container]-(container)-|", options: [], metrics: metrics, views: ["container": containerView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(menu)-[container]-(menu)-|", options: [], metrics: metrics, views: ["container": containerView])
        
        return constraints
    }
    
    fileprivate func preferredContainerConstraints() -> [NSLayoutConstraint] {
        var constraints:[NSLayoutConstraint] = []
        let metrics = ["padding": Constants.Floats.containerOffset]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": label])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[label]-(padding)-|", options: [], metrics: metrics, views: ["label": label])
        
        return constraints
    }
    
}
