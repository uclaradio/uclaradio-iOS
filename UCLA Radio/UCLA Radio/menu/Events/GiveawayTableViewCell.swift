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
    
    let ContainerChangeContext:UnsafeMutableRawPointer? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        containerView.layer.borderWidth = 2.0
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.addObserver(self, forKeyPath: "bounds", options: .new, context: ContainerChangeContext)
        
        dateLabel.textAlignment = .center
        containerView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        summaryLabel.numberOfLines = 2
        summaryLabel.textAlignment = .center
        containerView.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(preferredConstraints())
        containerView.addConstraints(containerConstraints())
    }
    
    deinit {
        containerView.layer.removeObserver(self, forKeyPath: "bounds", context: ContainerChangeContext)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func preferredHeight() -> CGFloat {
        return 80.0
    }
    
    // MARK: - Layout
    
    func styleForGiveaway(_ giveaway: Giveaway, infoToggled: Bool) {
        if infoToggled {
            summaryLabel.text = "Ticket Giveaway"
            summaryLabel.font = UIFont.systemFont(ofSize: 21)
            dateLabel.text = ""
            containerView.backgroundColor = Constants.Colors.darkBlue.withAlphaComponent(0.5)
        } else {
            summaryLabel.text = giveaway.summary
            summaryLabel.font = UIFont.systemFont(ofSize: 18)
            dateLabel.text = giveaway.date
            containerView.backgroundColor = UIColor.clear
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            containerView.backgroundColor = Constants.Colors.darkBlue
        } else {
            containerView.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        let metrics = ["padding": Constants.Floats.containerOffset]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[container]-(padding)-|", options: [], metrics: metrics, views: ["container": containerView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[container]-(padding)-|", options: [], metrics: metrics, views: ["container": containerView])
        
        return constraints
    }
    
    func containerConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        let views = ["date": dateLabel, "summary": summaryLabel]
        let metrics = ["date": 40, "padding": Constants.Floats.containerOffset, "dateSpace": 40 + 2*Constants.Floats.containerOffset]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[date]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[summary]-|", options: [], metrics: nil, views: views)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[date(dateSpace)]-(padding)-[summary]-(dateSpace)-|", options: [], metrics: metrics, views: views)
        
        return constraints
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == ContainerChangeContext) {
            containerView.layer.cornerRadius = containerView.frame.size.height/2.0
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}
