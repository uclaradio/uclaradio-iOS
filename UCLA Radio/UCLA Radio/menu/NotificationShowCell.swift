//
//  NotificationShowCell.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/22/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

class NotificationShowCell: UITableViewCell {
    
    fileprivate static let height: CGFloat = 60
    
    var addBottomPadding = false
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    
    fileprivate var installedConstraints: [NSLayoutConstraint]?
    fileprivate var installedContainerConstraints: [NSLayoutConstraint]?
    
    override required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        //accessoryType = .disclosureIndicator
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = Constants.Colors.lightBackground
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .left
        timeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        timeLabel.textColor = UIColor.lightGray
        containerView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromShow(_ show: Show) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        if let notificationDate = NotificationManager.sharedInstance.dateOfNextNotificationForShow(show) {
            timeLabel.text = formatter.formatDateForShow(notificationDate, format: .HourAndMinute)
        }
        
        titleLabel.text = show.title
        
        // update constraints
        if let installed = installedConstraints {
            contentView.removeConstraints(installed)
        }
        installedConstraints = preferredConstraints()
        contentView.addConstraints(installedConstraints!)
        
        if let installedContainerConstraints = installedContainerConstraints {
            containerView.removeConstraints(installedContainerConstraints)
        }
        installedContainerConstraints = containerConstraints()
        containerView.addConstraints(installedContainerConstraints!)
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
        return addBottomPadding ? NotificationShowCell.height + Constants.Floats.containerOffset : NotificationShowCell.height
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
        
        let views = ["time": timeLabel, "title": titleLabel]
        let metrics = ["bump": 7, "indent": 15, "timeWidth": 40]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title][time]-|", options: [], metrics: metrics, views: views)
        //constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(bump)-[genre]", options: [], metrics: metrics, views: views)
        //constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[djs]-(bump)-|", options: [], metrics: metrics, views: views)
        //constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .leftMargin , relatedBy: .equal, toItem: containerView, attribute: .leftMargin, multiplier: 1.0, constant: 0.0))
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(bump)-[title]", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(bump)-[time]", options: [], metrics: metrics, views: views)
        
        
        return constraints
    }
}
