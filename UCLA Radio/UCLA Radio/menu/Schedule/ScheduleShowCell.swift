//
//  ScheduleShowCell.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/5/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class ScheduleShowCell: UITableViewCell {
    
    var timeLabel = UILabel()
    var titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromShow(show: Show) {
        timeLabel.text = show.time
        titleLabel.text = show.title
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[time]-[title]-(>=8)-|", options: [], metrics: nil, views: ["time": timeLabel, "title": titleLabel])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[time]-|", options: [], metrics: nil, views: ["time": timeLabel, "title": titleLabel])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[title]-|", options: [], metrics: nil, views: ["time": timeLabel, "title": titleLabel])
        return constraints
    }
    
}
