//
//  RecentTrackView.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/10/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import UIKit
import SDWebImage

class RecentTrackView: UIView {
    
    var imageView: UIImageView!
    var title: UILabel!
    var subtitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        title = UILabel()
        title.font = UIFont.systemFontOfSize(14)
        title.textColor = UIColor.whiteColor()
        title.textAlignment = .Center
        subtitle = UILabel()
        subtitle.font = UIFont.systemFontOfSize(12)
        subtitle.textColor = UIColor.lightTextColor()
        subtitle.textAlignment = .Center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(title)
        addSubview(subtitle)
        addConstraints(preferredConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromTrack(track: RecentTrack) {
        if let url = track.image {
            imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "no_artwork"))
        }
        else {
            imageView.image = UIImage(named: "no_artwork")
        }
        title.text = track.title
        subtitle.text = track.artist
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let views = ["image": imageView, "title": title, "subtitle": subtitle]
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[image]-(5)-[title(14)]-(2)-[subtitle(12)]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[image]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[title]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[subtitle]-|", options: [], metrics: nil, views: views)
        return constraints
    }
}
