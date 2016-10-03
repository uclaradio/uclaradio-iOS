
//  ScheduleShowCell.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/5/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ScheduleShowCell: UITableViewCell {
    
    fileprivate static let height: CGFloat = 100
    
    var addBottomPadding = false
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    let genreLabel = UILabel()
    let djsLabel = UILabel()
    
    fileprivate var installedConstraints: [NSLayoutConstraint]?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = Constants.Colors.lightBackground
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 21)
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        timeLabel.textColor = UIColor.lightGray
        containerView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genreLabel.font = UIFont.systemFont(ofSize: 14)
        genreLabel.textColor = UIColor.darkGray
        genreLabel.textAlignment = .right
        containerView.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        djsLabel.font = UIFont.systemFont(ofSize: 16)
        djsLabel.textColor = UIColor.darkGray
        containerView.addSubview(djsLabel)
        djsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addConstraints(containerConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromShow(_ show: Show) {
        timeLabel.text = show.time
        titleLabel.text = show.title
        djsLabel.text = show.djString
        
        if let genre = show.genre {
            genreLabel.text = genre
        } else {
            genreLabel.text = ""
        }
        
        // update constraints
        if let installed = installedConstraints {
            contentView.removeConstraints(installed)
        }
        installedConstraints = preferredConstraints()
        contentView.addConstraints(installedConstraints!)
    }
    
    // MARK: - Layout
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            containerView.backgroundColor = Constants.Colors.lightBackgroundAltHighlighted
        } else {
            containerView.backgroundColor = Constants.Colors.lightBackground
        }
    }
    
    static func preferredHeight(_ addBottomPadding: Bool) -> CGFloat {
        return addBottomPadding ? ScheduleShowCell.height + Constants.Floats.containerOffset : ScheduleShowCell.height
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let metrics = ["offset": Constants.Floats.containerOffset, "bottomOffset": addBottomPadding ? Constants.Floats.containerOffset : 0]
        let views = ["container": containerView]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(offset)-[container]-(bottomOffset)-|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(offset)-[container]-(offset)-|", options: [], metrics: metrics, views: views)
        
        return constraints
    }
    
    func containerConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        let views = ["time": timeLabel, "title": titleLabel, "genre": genreLabel, "djs": djsLabel]
        let imageSize = (ScheduleShowCell.height - 2*Constants.Floats.containerOffset)
        let metrics = ["imageSize": imageSize, "bump": 5, "indent": 23]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(bump)-[time]", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(bump)-[genre]", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[djs]-(bump)-|", options: [], metrics: metrics, views: views)
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat:"H:|-(indent)-[title]-(indent)-|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat:"H:|-[time]-(>=15)-[genre]-|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat:"H:|-[djs]-|", options: [], metrics: metrics, views: views)
        
        return constraints
    }
    
}
