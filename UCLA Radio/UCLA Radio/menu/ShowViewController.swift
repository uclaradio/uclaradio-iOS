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
    
    
    
    @IBAction func notificationsToggled(_ sender: UISwitch) {
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            if let show = show {
                if sender.isOn {
    
                        let formatter = DateComponentsFormatter()
                        formatter.calendar = Calendar.current
                        var dateComponents = DateComponents()
                        dateComponents.hour = formatter.getHourComponentFromString(show.time)
                        dateComponents.weekday = formatter.getWeekdayComponentFromString(show.day)
                        
                        let requestIdentifier = show.title
                        
                        let content = UNMutableNotificationContent()
                        content.title = "UCLA Radio"
                        content.subtitle = show.title + " is on right now!"
                        content.body = "Woah! These new notifications look amazing! Don’t you agree?"
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                                    repeats: true)
                        
                        let request = UNNotificationRequest(identifier: requestIdentifier,
                                                            content: content,
                                                            trigger: trigger)
                        
                        current.add(request) { (error) in
                            print("Formatted: \(formatter.string(from: dateComponents)!)")
                            print("Date Components (hour): \(dateComponents.hour!)")
                            print("Date Components (weekday): \(dateComponents.weekday!)")
                        }
                } else {
                    current.removePendingNotificationRequests(withIdentifiers: [show.title])
                }
            }
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
            
            // track view analytics
            let tracker = GAI.sharedInstance().defaultTracker
            tracker?.set(kGAIScreenName, value: "Show: \(show.title)")
            let builder = GAIDictionaryBuilder.createScreenView()
            if let builder = builder {
                tracker?.send(builder.build() as [NSObject : AnyObject])
            }
        }
    }
    
    fileprivate func styleForShow(_ show: Show) {
        let string = show.day + " " + show.time
        timeLabel.text = string
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
    }
}
