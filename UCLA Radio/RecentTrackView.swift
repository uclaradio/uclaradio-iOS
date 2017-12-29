//
//  RecentTrackView.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/10/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import UIKit
import SDWebImage

class RecentTrackView: UIView {
    
    var track: RecentTrack?
    fileprivate var tapGesture: UITapGestureRecognizer?
    
    var imageView: UIImageView!
    var title: UILabel!
    var subtitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        title = UILabel()
        title.font = UIFont(name: Constants.Fonts.title, size: 14)
        title.textColor = UIColor.white
        title.textAlignment = .center
        subtitle = UILabel()
        subtitle.font = UIFont(name: Constants.Fonts.title, size: 12)
        subtitle.textColor = UIColor.lightText
        subtitle.textAlignment = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(title)
        addSubview(subtitle)
        addConstraints(preferredConstraints())
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromTrack(_ track: RecentTrack) {
        if let url = track.image {
            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "no_artwork"))
        }
        else {
            imageView.image = UIImage(named: "no_artwork")
        }
        title.text = track.title
        subtitle.text = track.artist
        self.track = track
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let views = ["image": imageView, "title": title, "subtitle": subtitle] as [String : Any]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image]-(5)-[title(16)]-(2)-[subtitle(14)]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[subtitle]-|", options: [], metrics: nil, views: views)
        return constraints
    }
    
    // Actions
    
    func didTap(_ tapGesture: UITapGestureRecognizer) {
        if let track = track,
            let url = NSURL(string: track.url) as? URL {
            UIApplication.shared.openURL(url)
        }
    }
    
}
