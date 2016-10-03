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
    
    fileprivate var containerConstraintsInstalled: [NSLayoutConstraint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        playButton = UIButton(type: .system)
        playButton.tintColor = UIColor.white
        playButton.contentMode = .scaleAspectFit
        playButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(hitPlay), for: .touchUpInside)
        containerView.addSubview(playButton)
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 2
        titleLabel.isUserInteractionEnabled = false
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
        NotificationCenter.default.addObserver(self, selector: #selector(streamUpdated), name: NSNotification.Name(rawValue: AudioStream.StreamUpdateNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingUpdated), name: NSNotification.Name(rawValue: RadioAPI.NowPlayingUpdatedNotification), object: nil)
    }
    
    override func willDisappear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addSkipButton() {
        skipButton = UIButton(type: .system)
        skipButton.setImage(UIImage(named: "reset"), for: UIControlState())
        skipButton.tintColor = UIColor.white
        skipButton.contentMode = .scaleAspectFit
        skipButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(hitSkip), for: .touchUpInside)
        containerView.addSubview(skipButton)
        
        canSkipStream = true
        resetConstraints()
    }
    
    // MARK: - Actions
    
    func hitPlay(_ button: UIButton) {
        AudioStream.sharedInstance.togglePlay()
    }
    
    func hitSkip(_ button: UIButton) {
        AudioStream.sharedInstance.skipToLive()
    }
    
    // MARK: - Notifications
    
    func streamUpdated(_ notification: Notification) {
        styleFromStream()
    }
    
    func styleFromStream() {
        if (AudioStream.sharedInstance.playing) {
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        }
        else {
            playButton.setImage(UIImage(named: "play"), for: UIControlState())
        }
    }
    
    func nowPlayingUpdated(_ notification: Notification) {
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
    
    // MARK: - Layout
    
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
        constraints.append(NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8@999)-[container(<=400)]-(8@999)-|", options: [], metrics: nil, views: ["container": containerView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", options: [], metrics: nil, views: ["container": containerView])
        return constraints
    }
    
    func containerConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        let metrics = ["item": NowPlayingView.ItemSpacing, "button": NowPlayingView.ButtonSize, "noButton": (NowPlayingView.ButtonSize + 2*NowPlayingView.ItemSpacing)]
        
        // Horizontal
        if (canSkipStream) {
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(item)-[play(button)]-(item)-[title]-(item)-[skip(button)]-(item)-|", options: [], metrics: metrics, views: ["play": playButton, "title": titleLabel, "skip": skipButton])
            constraints.append(NSLayoutConstraint(item: skipButton, attribute: .height, relatedBy: .equal, toItem: playButton, attribute: .height, multiplier: 1.0, constant: 0.0))
            constraints.append(NSLayoutConstraint(item: skipButton, attribute: .centerY, relatedBy: .equal, toItem: playButton, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        }
        else {
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(item)-[play(button)]-(item)-[title]-(noButton)-|", options: [], metrics: metrics, views: ["play": playButton, "title": titleLabel])
        }
        
        // play button
        constraints.append(NSLayoutConstraint(item: playButton, attribute: .height, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        // title & subtitle labels
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 1))
        return constraints
    }
    
}
