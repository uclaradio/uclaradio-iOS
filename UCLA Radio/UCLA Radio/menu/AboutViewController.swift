//
//  AboutViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: BaseViewController {
    
    static let storyboardID = "aboutViewController"
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var tumblrButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //AnalyticsManager.sharedInstance.trackPageWithValue("About")
    }
    
    // MARK: - Actions
    
    @IBAction func facebookButtonHit(_ sender: AnyObject) {
        guard let deepURL = URL(string: "fb://page/uclaradio") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(deepURL) {
            UIApplication.shared.openURL(deepURL)
        } else {
            UIApplication.shared.openURL(URL(string: "https://www.facebook.com/UCLARadio")!)
        }
    }
    
    @IBAction func instagramButtonHit(_ sender: AnyObject) {
        guard let deepURL = URL(string: "instagram://user?username=uclaradio") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(deepURL) {
            UIApplication.shared.openURL(deepURL)
        }
        else {
            UIApplication.shared.openURL(URL(string: "https://www.instagram.com/uclaradio")!)
        }
    }
    
    @IBAction func twitterButtonHit(_ sender: AnyObject) {
        guard let deepURL = URL(string: "twitter://user?screen_name=uclaradio") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(deepURL) {
            UIApplication.shared.openURL(deepURL)
        } else {
            UIApplication.shared.openURL(URL(string: "https://twitter.com/uclaradio")!)
        }
    }
    
    @IBAction func tumblrButtonHit(_ sender: AnyObject) {
        guard let deepURL = URL(string: "tumblr://x-callback-url/blog?blogName=uclaradio") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(deepURL) {
            UIApplication.shared.openURL(deepURL)
        }
        else {
            UIApplication.shared.openURL(URL(string: "https://uclaradio.tumblr.com")!)
        }
    }
}
