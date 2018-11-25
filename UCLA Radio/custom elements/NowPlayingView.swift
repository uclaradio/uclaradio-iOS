//
//  NowPlayingView.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/19/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

class NowPlayingView: SliderTabView {
    
    static let PreferredHeight: CGFloat = 60
    static let ButtonSize: CGFloat = 110
    static let CallButtonSize: CGFloat = 50
    static let ItemSpacing: CGFloat = 15
    
    var containerView: UIView!
    var playButton: UIButton!
    var callButton: UIButton!
    var onAirButton: UIButton!
    var titleLabel: UILabel!
    var callLabel: UILabel!
    var airLabel: UILabel!
    
    fileprivate var containerConstraintsInstalled: [NSLayoutConstraint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        playButton = UIButton(type: .custom)
        playButton.tintColor = UIColor.white
        playButton.contentMode = .scaleAspectFit
        playButton.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 30)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(hitPlay), for: .touchUpInside)
        playButton.backgroundColor = Constants.Colors.gold
        containerView.addSubview(playButton)
        
        callButton = UIButton(type: .system)
        callButton.tintColor = UIColor.white
        callButton.contentMode = .scaleAspectFit
        callButton.translatesAutoresizingMaskIntoConstraints = false
        callButton.addTarget(self, action: #selector(didTapOnAirCallButton), for: .touchUpInside)
        callButton.setImage(UIImage(named: "phone"), for: UIControlState())
        containerView.addSubview(callButton)
        
        onAirButton = UIButton(type: .system)
        onAirButton.tintColor = UIColor.white
        onAirButton.contentMode = .scaleAspectFit
        onAirButton.translatesAutoresizingMaskIntoConstraints = false
        onAirButton.addTarget(self, action: #selector(didTapRequestCallButton), for: .touchUpInside)
        onAirButton.setImage(UIImage(named: "phone"), for: UIControlState())
        containerView.addSubview(onAirButton)
        
        callLabel = UILabel()
        callLabel.textColor = UIColor.white
        callLabel.textAlignment = .center
        callLabel.font = UIFont(name: Constants.Fonts.title, size: 15)
        callLabel.numberOfLines = 2
        callLabel.isUserInteractionEnabled = false
        callLabel.translatesAutoresizingMaskIntoConstraints = false
        callLabel.text = "Request"
        containerView.addSubview(callLabel)
        
        airLabel = UILabel()
        airLabel.textColor = UIColor.white
        airLabel.textAlignment = .center
        airLabel.font = UIFont(name: Constants.Fonts.title, size: 15)
        airLabel.numberOfLines = 2
        airLabel.isUserInteractionEnabled = false
        airLabel.translatesAutoresizingMaskIntoConstraints = false
        airLabel.text = "On Air"
        containerView.addSubview(airLabel)
        
        titleLabel = UILabel()
        titleLabel.textColor = Constants.Colors.darkBackground
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: Constants.Fonts.title, size: 20)
        titleLabel.numberOfLines = 2
        titleLabel.isUserInteractionEnabled = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        addConstraints(preferredConstraints())
        containerView.addConstraints(containerConstraints())
    }
    
    
    convenience init(canSkipStream: Bool) {
        self.init(frame: CGRect(x: 0, y: 0, width: 400, height: NowPlayingView.PreferredHeight))
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
    
    // MARK: - Actions
    
    @objc func hitPlay(_ button: UIButton) {
        AudioStream.sharedInstance.togglePlay()
    }
    
    
    // MARK: - Notifications
    
    @objc func streamUpdated(_ notification: Notification) {
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
    
    @objc func nowPlayingUpdated(_ notification: Notification) {
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
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[container]-|", options: [], metrics: nil, views: ["container": containerView])
        //containerView.backgroundColor = Constants.Colors.darkPink
        return constraints
    }
    
    let onAirNumber = "3107949348"
    let requestNumber = "3108259999"
    
    func makeCall(phone: String) {
        let phoneUrl = "tel://\(phone)"
        let url:NSURL = NSURL(string: phoneUrl)!
        UIApplication.shared.openURL(url as URL)
    }
    
    @objc func didTapOnAirCallButton(_ button: UIButton) {
        makeCall(phone: onAirNumber)
    }
    
    @objc func didTapRequestCallButton(_ button: UIButton) {
        makeCall(phone: requestNumber)
    }
    
    func containerConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        let metrics = ["item": NowPlayingView.ItemSpacing, "button": NowPlayingView.ButtonSize, "noButton": (NowPlayingView.ButtonSize + 2*NowPlayingView.ItemSpacing)]
        
        // Horizontal
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-|", options: [], metrics: metrics, views: ["title": titleLabel])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[callButton]-[play(button)]-[onAirButton]-|", options: [], metrics: metrics, views: ["callButton": callButton, "play": playButton, "onAirButton": onAirButton])
        // Vertical
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[play(button)]-[title]-|", options: [], metrics: metrics, views: ["play": playButton, "title": titleLabel])
        
        // title & subtitle labels
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 1))
        
        // play button
        constraints.append(NSLayoutConstraint(item: playButton, attribute: .height, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: playButton, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        // call button
        constraints.append(NSLayoutConstraint(item: callButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 0.5, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: callButton, attribute: .width, relatedBy: .equal, toItem: callButton, attribute: .height, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: callButton, attribute: .centerY, relatedBy: .equal, toItem: playButton, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        // onair button
        constraints.append(NSLayoutConstraint(item: onAirButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 0.5, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: onAirButton, attribute: .width, relatedBy: .equal, toItem: onAirButton, attribute: .height, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: onAirButton, attribute: .centerY, relatedBy: .equal, toItem: playButton, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        // call label
        constraints.append(NSLayoutConstraint(item: callLabel, attribute: .bottom, relatedBy: .equal, toItem: callButton, attribute: .top, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: callLabel, attribute: .centerX, relatedBy: .equal, toItem: callButton, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        // air label
        constraints.append(NSLayoutConstraint(item: airLabel, attribute: .bottom, relatedBy: .equal, toItem: onAirButton, attribute: .top, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: airLabel, attribute: .centerX, relatedBy: .equal, toItem: onAirButton, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        return constraints
    }
    
}
