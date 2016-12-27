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
import UserNotifications

class ShowViewController: BaseViewController {
    
    static let storyboardID = "showViewController"
    
    var show: Show?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var djsLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var notificationsView: UIView!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    
    @IBAction func notificationsToggled(_ sender: UISwitch) {
        if let show = show {
            NotificationManager.sharedInstance.notificationsToggledForShow(show, isOn: notificationsSwitch.isOn)
            UserDefaults.standard.set(notificationsSwitch.isOn, forKey: show.title + "-switchState")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.textColor = UIColor.lightGray
        genreLabel.textColor = UIColor.darkGray
        blurbLabel.textColor = UIColor.darkGray
        djsLabel.textColor = UIColor.darkGray
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let show = show {
            styleForShow(show)
            AnalyticsManager.sharedInstance.trackPageWithValue("Show: \(show.title)")
        }
    }
    
    fileprivate func styleForShow(_ show: Show) {
        
        let formatter = DateFormatter()
        let showDate = show.getClosestDateOfShow()
        
        timeLabel.text = formatter.formatDateForShow(showDate, format: .DayAndTime)
        titleLabel.text = show.title
        djsLabel.text = show.djString
        
        let placeholder = UIImage(named: "radio")
        if let picture = show.picture {
            imageView.sd_setImage(with: RadioAPI.absoluteURL(picture), placeholderImage: placeholder)
        } else {
            imageView.image = placeholder
        }
        
        genreLabel.text = ""
        if let genre = show.genre {
            genreLabel.text = genre
        }
        
        blurbLabel.text = ""
        if let blurb = show.blurb {
            blurbLabel.text = blurb
        }
        
        notificationsSwitch.isOn =  UserDefaults.standard.bool(forKey: show.title + "-switchState")
    }
}
