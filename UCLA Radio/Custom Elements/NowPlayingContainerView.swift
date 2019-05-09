//
//  NowPlayingContainerView.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 11/26/18.
//  Copyright © 2018 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

class NowPlayingContainerView: SliderTabView {
    
    static let PreferredHeight: CGFloat = 60
    static let ButtonSize: CGFloat = 110
    static let CallButtonSize: CGFloat = 50
    static let ItemSpacing: CGFloat = 15
    
    var imageView: UIImageView!
    var imageContainer: UIView!
    var containerView: UIView!
    var playButton: UIButton!
    var callButton: UIButton!
    var onAirButton: UIButton!
    var titleLabel: UILabel!
    var callLabel: UILabel!
    var airLabel: UILabel!
    
    fileprivate var containerConstraintsInstalled: [NSLayoutConstraint]?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //set the background color to be clear
        backgroundColor = UIColor.clear
        
        //NowPlayingContainerView.ButtonSize = self.frame.width/12
        
        imageView = UIImageView()
        imageView.frame = CGRect(x: 30, y: 80, width: self.frame.width-60, height: self.frame.width-60)
        imageView.tintColor = UIColor.white
        imageView.image = UIImage(named: "radio_banner")
        imageView.layer.masksToBounds = true
        
        imageContainer = UIView()
        imageContainer.contentMode = .scaleAspectFit
        imageContainer.addSubview(imageView)
        self.addSubview(imageContainer)
        
        playButton = UIButton(type: .custom)
        playButton.tintColor = UIColor.white
        playButton.contentMode = .scaleAspectFit
        playButton.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(hitPlay), for: .touchUpInside)
        playButton.backgroundColor = Constants.Colors.gold
        
        self.addSubview(playButton)
        
        callButton = UIButton(type: .system)
        callButton.tintColor = UIColor.white
        callButton.contentMode = .scaleAspectFit
        callButton.translatesAutoresizingMaskIntoConstraints = false
        callButton.addTarget(self, action: #selector(didTapOnAirCallButton), for: .touchUpInside)
        callButton.setImage(UIImage(named: "phone"), for: UIControlState())
        self.addSubview(callButton)
        
        onAirButton = UIButton(type: .system)
        onAirButton.tintColor = UIColor.white
        onAirButton.contentMode = .scaleAspectFit
        onAirButton.translatesAutoresizingMaskIntoConstraints = false
        onAirButton.addTarget(self, action: #selector(didTapRequestCallButton), for: .touchUpInside)
        onAirButton.setImage(UIImage(named: "phone"), for: UIControlState())
        self.addSubview(onAirButton)
        
        callLabel = UILabel()
        callLabel.textColor = UIColor.white
        callLabel.textAlignment = .center
        callLabel.font = UIFont(name: Constants.Fonts.title, size: 15)
        callLabel.numberOfLines = 2
        callLabel.isUserInteractionEnabled = false
        callLabel.translatesAutoresizingMaskIntoConstraints = false
        callLabel.text = "Request"
        self.addSubview(callLabel)
        
        airLabel = UILabel()
        airLabel.textColor = UIColor.white
        airLabel.textAlignment = .center
        airLabel.font = UIFont(name: Constants.Fonts.title, size: 15)
        airLabel.numberOfLines = 2
        airLabel.isUserInteractionEnabled = false
        airLabel.translatesAutoresizingMaskIntoConstraints = false
        airLabel.text = "On Air"
        self.addSubview(airLabel)
        
        titleLabel = UILabel()
        titleLabel.textColor = Constants.Colors.darkBackground
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: Constants.Fonts.title, size: 20)
        titleLabel.numberOfLines = 2
        titleLabel.isUserInteractionEnabled = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        addConstraints(preferredConstraints())
        
    }
    
    convenience init(canSkipStream: Bool) {
        self.init(frame: CGRect(x: 0, y: 0, width: 400, height: NowPlayingContainerView.PreferredHeight))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //what happens when you hit the play button
    @objc func hitPlay(_ button: UIButton) {
        AudioStream.sharedInstance.togglePlay()
        if(AudioStream.sharedInstance.playing){
            AudioStream.sharedInstance.skipToLive()
        }
    }
    
    //phone numbers to call for the request button and onAir button
    let onAirNumber = "3107949348"
    let requestNumber = "3108259999"
    
    //function that handles making a phone call
    func makeCall(phone: String) {
        let phoneUrl = "tel://\(phone)"
        let url:NSURL = NSURL(string: phoneUrl)!
        UIApplication.shared.openURL(url as URL)
    }
    
    //what happens when you tap the onAir button
    @objc func didTapOnAirCallButton(_ button: UIButton) {
        makeCall(phone: onAirNumber)
    }
    
    //what happens when you tap the request button
    @objc func didTapRequestCallButton(_ button: UIButton) {
        makeCall(phone: requestNumber)
    }
    
    
    // MARK: - Notifications
    
    @objc func streamUpdated(_ notification: Notification) {
        styleFromStream()
    }
    
    //get info on whether or not the show is paused, so we know whether or not the button should show a play arrow or a pause sign
    func styleFromStream() {
        if (AudioStream.sharedInstance.playing) {
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        }
        else {
            playButton.setImage(UIImage(named: "play"), for: UIControlState())
        }
    }
    
    //update info about the show that is currently playing
    @objc func nowPlayingUpdated(_ notification: Notification) {
        styleFromNowPlaying()
    }
    
    //grab info we need about the show that is currently playing
    func styleFromNowPlaying() {
        if let show = RadioAPI.nowPlaying {
            titleLabel.text = "LIVE: " + show.title
        }
        else {
            titleLabel.text = "LIVE STREAM"
        }
    }
    
    func resetConstraints() {
        if let constraints = containerConstraintsInstalled {
            containerView.removeConstraints(constraints)
            containerConstraintsInstalled = nil
        }
        containerConstraintsInstalled = preferredConstraints()
        containerView.addConstraints(containerConstraintsInstalled!)
    }
    
    //set up the constraints
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        //specify the metrics for our layout
        let metrics = [
            "item": NowPlayingContainerView.ItemSpacing,
            "button": NowPlayingContainerView.ButtonSize,
            "noButton": (NowPlayingContainerView.ButtonSize + 2*NowPlayingContainerView.ItemSpacing)]
        
        
        
        //Use visual format language magic to make autolayout do its thing
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[play(button)]-(130)-|", options: [], metrics: metrics, views: ["play": playButton, "image": imageView, "title": titleLabel])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image]-|", options: [], metrics: metrics, views: ["image": imageContainer])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-|", options: [], metrics: metrics, views: ["title": titleLabel])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[callButton]-[play(button)]-[onAirButton]-(30)-|", options: [], metrics: metrics, views: ["callButton": callButton, "play": playButton, "onAirButton": onAirButton])
        
        //Specify the height and width of the imageView.  The width will be 80% of the screen width, and the height will be equal to the width
        
        constraints.append(NSLayoutConstraint(item: imageContainer, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        
        //specify constraints for the playButton, we want it to always be centered along the x-axis
        constraints.append(NSLayoutConstraint(item: playButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        constraints.append(NSLayoutConstraint(item: playButton, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        
        //specify constraints for the titleLabel, we want it to always be centered along the x-axis and right above the playButton
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: playButton, attribute: .top, multiplier: 1.0, constant: -5.0))
        
        //set the size of the call button and on air button
        constraints.append(NSLayoutConstraint(item: onAirButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 0.5, constant: 1.0))
        constraints.append(NSLayoutConstraint(item: onAirButton, attribute: .height, relatedBy: .equal, toItem: onAirButton, attribute: .width, multiplier: 1.0, constant: 1.0))
        
        constraints.append(NSLayoutConstraint(item: callButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 0.5, constant: 1.0))
        constraints.append(NSLayoutConstraint(item: callButton, attribute: .height, relatedBy: .equal, toItem: onAirButton, attribute: .width, multiplier: 1.0, constant: 1.0))
        
        //lets also make it so the call button and onAirButton are on the same y coordinate as the playButton
        constraints.append(NSLayoutConstraint(item: callButton, attribute: .centerY, relatedBy: .equal, toItem: playButton, attribute: .centerY, multiplier: 1.0, constant: 1.0))
        
        constraints.append(NSLayoutConstraint(item: onAirButton, attribute: .centerY, relatedBy: .equal, toItem: playButton, attribute: .centerY, multiplier: 1.0, constant: 1.0))
        
        //lets make the airLabel and callLabel hug the top of their respective buttons
        constraints.append(NSLayoutConstraint(item: airLabel, attribute: .bottom, relatedBy: .equal, toItem: onAirButton, attribute: .top, multiplier: 1.0, constant: 1.0))
        
        constraints.append(NSLayoutConstraint(item: callLabel, attribute: .bottom, relatedBy: .equal, toItem: callButton, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        //lets make the airLabel and callLabel x-coordinates centered at their respective buttons
        constraints.append(NSLayoutConstraint(item: airLabel, attribute: .centerX, relatedBy: .equal, toItem: onAirButton, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        constraints.append(NSLayoutConstraint(item: callLabel, attribute: .centerX, relatedBy: .equal, toItem: callButton, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        return constraints
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
    
}
