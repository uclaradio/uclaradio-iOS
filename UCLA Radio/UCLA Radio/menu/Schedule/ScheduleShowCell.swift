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
    
    static let height: CGFloat = 80
    static let imageDimensions: CGFloat = 60
    
    let blurbImageView = UIImageView()
    let timeLabel = UILabel()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(blurbImageView)
        blurbImageView.translatesAutoresizingMaskIntoConstraints = false
//        blurbImageView.backgroundColor = UIColor.greenColor()
        
        contentView.addConstraints(preferredConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromShow(show: Show) {
        timeLabel.text = show.time
        titleLabel.text = show.title
        blurbImageView.image = nil
        if let picture = show.picture {
            blurbImageView.sd_setImageWithURL(RadioAPI.absoluteURL(picture))
        }
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        let views = ["time": timeLabel, "title": titleLabel, "image": blurbImageView]
        let imagePadding = (ScheduleShowCell.height - ScheduleShowCell.imageDimensions)/2.0
        let metrics = ["pad": imagePadding, "imageSize": ScheduleShowCell.imageDimensions]
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[time]-[title]-(>=8)-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(pad)-[image]-(pad)-|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[time]-[image(imageSize)]-(pad)-|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[title]-[image(imageSize)]-(pad)-|", options: [], metrics: metrics, views: views)
        return constraints
    }
    
}
