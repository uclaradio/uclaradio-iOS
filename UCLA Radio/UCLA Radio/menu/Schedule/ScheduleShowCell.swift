//
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
    
    static let height: CGFloat = 100
    static let imageDimensions: CGFloat = 92
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    let genreLabel = UILabel()
    let djsLabel = UILabel()
    let blurbImageView = UIImageView()
    
    var hasPicture = false
    var installedConstraints: [NSLayoutConstraint]?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = Constants.Colors.lightBackground
//        containerView.layer.cornerRadius = ScheduleShowCell.containerOffset
//        containerView.layer
        containerView.clipsToBounds = true
        
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: Constants.Fonts.title, size: 21)
        
        containerView.addSubview(timeLabel)
        timeLabel.font = UIFont.boldSystemFontOfSize(14)
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(genreLabel)
        genreLabel.font = UIFont.systemFontOfSize(14)
        genreLabel.textAlignment = .Right
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(djsLabel)
        djsLabel.font = UIFont.systemFontOfSize(16)
        djsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(blurbImageView)
        blurbImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(preferredConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromShow(show: Show) {
        timeLabel.text = show.time
        titleLabel.text = show.title
        djsLabel.text = show.djString
        
        if let genre = show.genre {
            genreLabel.text = genre
        }
        else {
            genreLabel.text = ""
        }
        
        blurbImageView.image = nil
        hasPicture = false
        if let picture = show.picture {
            hasPicture = true
            blurbImageView.sd_setImageWithURL(RadioAPI.absoluteURL(picture))
        }
        
        // update constraints
        if let installed = installedConstraints {
            containerView.removeConstraints(installed)
        }
        installedConstraints = containerConstraints()
        containerView.addConstraints(installedConstraints!)
    }
    
    // MARK: - Layout
    
    override func setSelected(selected: Bool, animated: Bool) {
        UIView.animateWithDuration(0.5) { 
            self.containerView.alpha = selected ? 0.5 : 1.0
        }
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let metrics = ["offset": Constants.Floats.containerOffset, "half": 0.5*Constants.Floats.containerOffset]
        let views = ["container": containerView]
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(half)-[container]-(half)-|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(offset)-[container]-(offset)-|", options: [], metrics: metrics, views: views)
        
        return constraints
    }
    
    func containerConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        let views = ["time": timeLabel, "title": titleLabel, "image": blurbImageView, "genre": genreLabel, "djs": djsLabel]
        let imagePadding = (ScheduleShowCell.height - 2*Constants.Floats.containerOffset - ScheduleShowCell.imageDimensions)/2.0
        let metrics = ["pad": imagePadding, "imageSize": ScheduleShowCell.imageDimensions, "bump": 5, "indent": 23]
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(bump)-[time]", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(bump)-[genre]", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[djs]-(bump)-|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(pad)-[image]-(pad)-|", options: [], metrics: metrics, views: views)
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: containerView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        if (hasPicture) {
            // with picture on right
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(indent)-[title]-(indent)-[image(imageSize)]-(pad)-|", options: [], metrics: metrics, views: views)
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[time]-(>=15)-[genre]-[image(imageSize)]-(pad)-|", options: [], metrics: metrics, views: views)
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[djs]-[image]", options: [], metrics: metrics, views: views)
        }
        else {
            // without picture
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(indent)-[title]-(indent)-|", options: [], metrics: metrics, views: views)
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[time]-(>=15)-[genre]-|", options: [], metrics: metrics, views: views)
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[djs]-|", options: [], metrics: metrics, views: views)
        }
        
        return constraints
    }
    
}
