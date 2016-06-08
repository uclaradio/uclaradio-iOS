//
//  ShowViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/8/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ShowViewController: UIViewController {
    
    static let storyboardID = "showViewController"
    
    var show: Show?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var djsLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.lightBackground
        
        timeLabel.textColor = UIColor.lightGrayColor()
        
        genreLabel.textColor = UIColor.darkGrayColor()
        blurbLabel.textColor = UIColor.darkGrayColor()
        djsLabel.textColor = UIColor.darkGrayColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let show = show {
            styleForShow(show)
        }
    }
    
    private func styleForShow(show: Show) {
        let string = show.day + " " + show.time
        timeLabel.text = string
        titleLabel.text = show.title
        djsLabel.text = show.djString
        
        imageView.image = UIImage(named: "radio")
        if let picture = show.picture {
            imageView.sd_setImageWithURL(RadioAPI.absoluteURL(picture))
        }
        
        genreLabel.text = ""
        if let genre = show.genre {
            genreLabel.text = genre
        }
        
        blurbLabel.text = ""
        if let blurb = show.blurb {
            blurbLabel.text = blurb
        }
        
    }
}
