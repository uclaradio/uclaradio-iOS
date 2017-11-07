
//  ScheduleShowCell.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/5/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
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
    let blurbImageView = UIImageView()
    
    fileprivate var installedConstraints: [NSLayoutConstraint]?
    fileprivate var installedContainerConstraints: [NSLayoutConstraint]?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = Constants.Colors.lightBackground
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: Constants.Fonts.title, size: 21)
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.font = UIFont(name: Constants.Fonts.titleBold, size: 14)
        timeLabel.textColor = UIColor.lightGray
        containerView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genreLabel.font = UIFont(name: Constants.Fonts.title, size: 14)
        genreLabel.textColor = UIColor.darkGray
        genreLabel.textAlignment = .right
        containerView.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        djsLabel.font = UIFont(name: Constants.Fonts.title, size: 16)
        djsLabel.textColor = UIColor.darkGray
        containerView.addSubview(djsLabel)
        djsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(blurbImageView)
        blurbImageView.translatesAutoresizingMaskIntoConstraints = false
        blurbImageView.contentMode = .scaleAspectFill
        blurbImageView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromShow(_ show: Show) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        let showDate = show.getClosestDateOfShow()
        
        timeLabel.text = formatter.formatDateForShow(showDate, format: .Hour)
        titleLabel.text = show.title
//        djsLabel.text = show.djString
        blurbImageView.sd_cancelCurrentImageLoad()
        
        if let genre = show.genre {
            genreLabel.text = genre
        } else {
            genreLabel.text = ""
        }
        
        let placeholder = UIImage(named: "radio")
        if let picture = show.picture {
            blurbImageView.sd_setImage(with: RadioAPI.absoluteURL(picture), placeholderImage: placeholder)
        } else {
            blurbImageView.image = placeholder
        }
        
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
        
        let views = ["time": timeLabel, "title": titleLabel, "image": blurbImageView, "genre": genreLabel, "djs": djsLabel]
        let imageSize = (ScheduleShowCell.height - 2*Constants.Floats.containerOffset)
        let metrics = ["imageSize": imageSize, "bump": 5, "indent": 23, "timeWidth": 40]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(bump)-[time]", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(bump)-[genre]", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[djs]-(bump)-|", options: [], metrics: metrics, views: views)
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        // with picture on right
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[image]|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(indent)-[title]-(indent)-[image(imageSize)]|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[time(timeWidth)]-(>=15)-[genre]-[image(imageSize)]|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[djs]-[image]", options: [], metrics: metrics, views: views)
        
        return constraints
    }
    
}
