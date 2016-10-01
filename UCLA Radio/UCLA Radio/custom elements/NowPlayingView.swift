//
//  NowPlayingView.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/19/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class NowPlayingView: SliderTabView {
    
    static let PreferredHeight: CGFloat = 60
    static let ButtonSize: CGFloat = 40
    static let ItemSpacing: CGFloat = 15
    
    var canSkipStream = false
    
    var containerView: UIView!
    var playButton: UIButton!
    var skipButton: UIButton!
    var titleLabel: UILabel!
    
    private var containerConstraintsInstalled: [NSLayoutConstraint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.clearColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        playButton = UIButton(type: .System)
        playButton.tintColor = UIColor.whiteColor()
        playButton.contentMode = .ScaleAspectFit
        playButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(hitPlay), forControlEvents: .TouchUpInside)
        containerView.addSubview(playButton)
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.numberOfLines = 2
        titleLabel.userInteractionEnabled = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        addConstraints(preferredConstraints())
        containerView.addConstraints(containerConstraints())
    }
    
    convenience init(canSkipStream: Bool) {
        self.init(frame: CGRect(x: 0, y: 0, width: 400, height: NowPlayingView.PreferredHeight))
        if (canSkipStream) {
            addSkipButton()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willAppear() {
        styleFromStream()
        styleFromNowPlaying()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(streamUpdated), name: AudioStream.StreamUpdateNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(nowPlayingUpdated), name: RadioAPI.NowPlayingUpdatedNotification, object: nil)
    }
    
    override func willDisappear() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func addSkipButton() {
        skipButton = UIButton(type: .System)
        skipButton.setImage(UIImage(named: "reset"), forState: .Normal)
        skipButton.tintColor = UIColor.whiteColor()
        skipButton.contentMode = .ScaleAspectFit
        skipButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(hitSkip), forControlEvents: .TouchUpInside)
        containerView.addSubview(skipButton)
        
        canSkipStream = true
        resetConstraints()
    }
    
    // Actions
    
    func hitPlay(button: UIButton) {
        AudioStream.sharedInstance.togglePlay()
    }
    
    func hitSkip(button: UIButton) {
        AudioStream.sharedInstance.skipToLive()
    }
    
    // Notifications
    
    func streamUpdated(notification: NSNotification) {
        styleFromStream()
    }
    
    func styleFromStream() {
        if (AudioStream.sharedInstance.playing) {
            playButton.setImage(UIImage(named: "pause"), forState: .Normal)
        }
        else {
            playButton.setImage(UIImage(named: "play"), forState: .Normal)
        }
    }
    
    func nowPlayingUpdated(notification: NSNotification) {
        styleFromNowPlaying()
    }
    
    func styleFromNowPlaying() {
        if let show = RadioAPI.nowPlaying {
            titleLabel.text = "LIVE: " + show.title
        }
        else {
            titleLabel.text = "LIVE STREAM"
        }
    }
    
    // Layout
    
    func resetConstraints() {
        if let constraints = containerConstraintsInstalled {
            containerView.removeConstraints(constraints)
            containerConstraintsInstalled = nil
        }
        containerConstraintsInstalled = containerConstraints()
        containerView.addConstraints(containerConstraintsInstalled!)
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        // container view (max at 400 width)
        constraints.append(NSLayoutConstraint(item: containerView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(8@999)-[container(<=400)]-(8@999)-|", options: [], metrics: nil, views: ["container": containerView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[container]|", options: [], metrics: nil, views: ["container": containerView])
        return constraints
    }
    
    func containerConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        let metrics = ["item": NowPlayingView.ItemSpacing, "button": NowPlayingView.ButtonSize, "noButton": (NowPlayingView.ButtonSize + 2*NowPlayingView.ItemSpacing)]
        
        // Horizontal
        if (canSkipStream) {
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(item)-[play(button)]-(item)-[title]-(item)-[skip(button)]-(item)-|", options: [], metrics: metrics, views: ["play": playButton, "title": titleLabel, "skip": skipButton])
            constraints.append(NSLayoutConstraint(item: skipButton, attribute: .Height, relatedBy: .Equal, toItem: playButton, attribute: .Height, multiplier: 1.0, constant: 0.0))
            constraints.append(NSLayoutConstraint(item: skipButton, attribute: .CenterY, relatedBy: .Equal, toItem: playButton, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        }
        else {
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(item)-[play(button)]-(item)-[title]-(noButton)-|", options: [], metrics: metrics, views: ["play": playButton, "title": titleLabel])
        }
        
        // play button
        constraints.append(NSLayoutConstraint(item: playButton, attribute: .Height, relatedBy: .Equal, toItem: playButton, attribute: .Width, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: playButton, attribute: .CenterY, relatedBy: .Equal, toItem: containerView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        // title & subtitle labels
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: containerView, attribute: .CenterY, multiplier: 1.0, constant: 1))
        return constraints
    }
    
}
