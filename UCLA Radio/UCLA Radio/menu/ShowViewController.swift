//
//  ShowViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/8/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ShowViewController: BaseViewController {

    static let storyboardID = "showViewController"

    var show: Show?

    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var notificationsImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var djsLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var columnContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsImageView.tintColor = UIColor.lightGray
        timeLabel.textColor = UIColor.lightGray
        genreLabel.textColor = UIColor.darkGray
        blurbLabel.textColor = UIColor.darkGray
        djsLabel.textColor = UIColor.darkGray
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(toggleNotifications))
        timeView.addGestureRecognizer(timeTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let show = show {
            styleForShow(show)
            AnalyticsManager.sharedInstance.trackPageWithValue("Show: \(show.title)")
        }
    }
    
    // MARK: - Styling
    
    private func styleForShow(_ show: Show) {
        let formatter = DateFormatter()
        let showDate = show.getClosestDateOfShow()

        timeLabel.text = formatter.formatDateForShow(showDate, format: .DayAndHour)
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
        let notificationsEnabled = NotificationManager.sharedInstance.areNotificationsOnForShow(show)
        notificationsImageView.image = notificationsEnabled ? #imageLiteral(resourceName: "bell") : #imageLiteral(resourceName: "bell_hollow")
    }

    // MARK: - Actions

    @objc private func toggleNotifications(tap: UITapGestureRecognizer) {
        if let show = show {
            let notificationsEnabled = UserDefaults.standard.bool(forKey: show.title + "-switchState")
            NotificationManager.sharedInstance.toggleNotificationsForShow(show, toggle: !notificationsEnabled)
            UserDefaults.standard.set(!notificationsEnabled, forKey: show.title + "-switchState")
            UserDefaults.standard.synchronize()
            
            styleForShow(show)
            if #available(iOS 10.0, *) {
                // taptic feedback
                UISelectionFeedbackGenerator().selectionChanged()
            }
        }
    }
}
