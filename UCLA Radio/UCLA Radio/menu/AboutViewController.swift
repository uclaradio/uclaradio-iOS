//
//  AboutViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    static let storyboardID = "aboutViewController"
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var tumblrButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.lightPink
    }
    
    // MARK: - Actions
    
    @IBAction func facebookButtonHit(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/UCLARadio")!)
    }
    
    @IBAction func instagramButtonHit(sender: AnyObject) {
        let deepURL = NSURL(string: "instagram:://user?username=uclaradio")!
        if UIApplication.sharedApplication().canOpenURL(deepURL) {
            UIApplication.sharedApplication().openURL(deepURL)
        }
        else {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.instagram.com/uclaradio")!)
        }
    }
    
    @IBAction func twitterButtonHit(sender: AnyObject) {
        let deepURL = NSURL(string: "twitter://user?screen_name=uclaradio")!
        if UIApplication.sharedApplication().canOpenURL(deepURL) {
            UIApplication.sharedApplication().openURL(deepURL)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/uclaradio")!)
        }
    }
    
    @IBAction func tumblrButtonHit(sender: AnyObject) {
        let deepURL = NSURL(string: "tumblr://x-callback-url/blog?blogName=uclaradio")!
        if UIApplication.sharedApplication().canOpenURL(deepURL) {
            UIApplication.sharedApplication().openURL(deepURL)
        }
        else {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://uclaradio.tumblr.com")!)
        }
    }
}
