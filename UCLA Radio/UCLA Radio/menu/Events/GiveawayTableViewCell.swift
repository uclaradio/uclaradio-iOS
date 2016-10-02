//
//  GiveawayTableViewCell.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 10/1/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class GiveawayTableViewCell: UITableViewCell {
    
    let containerView = UILabel()
    let dateLabel = UILabel()
    let summaryLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        containerView.backgroundColor = Constants.Colors.lightBackground
        containerView.layer.borderColor = UIColor.blackColor().CGColor
        containerView.layer.borderWidth = 2.0
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(preferredConstraints())
        containerView.addConstraints(containerConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func preferredHeight() -> CGFloat {
        return 80.0
    }
    
    func styleForGiveaway(giveaway: Giveaway) {
        summaryLabel.text = giveaway.summary
        dateLabel.text = giveaway.date
        
        containerView.layer.cornerRadius = containerView.frame.height / 2
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        let metrics = ["padding": Constants.Floats.containerOffset]
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(padding)-[container]-(padding)-|", options: [], metrics: metrics, views: ["container": containerView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(padding)-[container]-(padding)-|", options: [], metrics: metrics, views: ["container": containerView])
        
        return constraints
    }
    
    func containerConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        let views = ["date": dateLabel, "summary": summaryLabel]
        let metrics = ["date": 40, "padding": Constants.Floats.containerOffset, "dateSpace": 40 + 2*Constants.Floats.containerOffset]
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[date]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[summary]-|", options: [], metrics: nil, views: views)
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(padding)-[date(dateSpace)]-(padding)-[summary]-(dateSpace)-|", options: [], metrics: metrics, views: views)
        
        return constraints
    }
    
}
