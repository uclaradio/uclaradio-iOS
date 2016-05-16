//
//  ViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 4/26/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import UIKit
import MediaPlayer
import ASHorizontalScrollView

class NowPlayingViewController: UIViewController, HistoryFetchDelegate, AudioStreamDelegate, SlidingVCDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var controlsParentView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var recentlyPlayedLabel: UILabel!
    var recentlyPlayed: ASHorizontalScrollView!
    
    var recentUpdateTimer: NSTimer?
    var tapGesture: UITapGestureRecognizer?
    
    // SlidingVCDelegate
    var slider: SlidingViewController?
    var MaximumHeight: CGFloat = -80
    var MinimumYPosition: CGFloat = 0
    var ClosedHeight: CGFloat = -100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "radio_banner")
        
        titleLabel.textColor = Constants.Colors.gold
        titleLabel.text = "Live Stream"
        subtitleLabel.textColor = UIColor.whiteColor()
        subtitleLabel.text = "UCLA Radio"
        
        view.backgroundColor = Constants.Colors.darkBlue
        
        playButton.imageView?.contentMode = .ScaleAspectFit
        playButton.tintColor = Constants.Colors.gold
        skipButton.imageView?.contentMode = .ScaleAspectFit
        skipButton.tintColor = Constants.Colors.gold
        
        let volumeView = MPVolumeView()
        controlsParentView.addSubview(volumeView)
        controlsParentView.backgroundColor = UIColor.clearColor()
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.setVolumeThumbImage(UIImage(named: "volumeSlider")?.imageWithColor(Constants.Colors.gold), forState: .Normal)
        volumeView.setRouteButtonImage(UIImage(named: "airplayIcon")?.imageWithColor(Constants.Colors.gold), forState: .Normal)
        volumeView.tintColor = Constants.Colors.gold
        
        controlsParentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[skip]-(15)-[volume(>=30)]", options: [], metrics: nil, views: ["skip": skipButton, "volume": volumeView]))
        controlsParentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[volume]-(20)-|", options: [], metrics: nil, views: ["volume": volumeView]))
        
        recentlyPlayedLabel = UILabel()
        recentlyPlayedLabel.text = "Recently Played"
        recentlyPlayedLabel.textColor = UIColor.lightTextColor()
        recentlyPlayedLabel.font = UIFont.boldSystemFontOfSize(14)
        containerView.addSubview(recentlyPlayedLabel)
        recentlyPlayedLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[recentLabel(150)]", options: [], metrics: nil, views: ["recentLabel": recentlyPlayedLabel]))
        
        let recentTrackSize = CGSize(width: (view.frame.size.width-20)/4, height: 90)
        
        // ASHorizontalScrollView is not optimized for auto layout, has to be initialized with frame, use auto layout for positioning
        recentlyPlayed = ASHorizontalScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: recentTrackSize.height))
        
        recentlyPlayed.leftMarginPx = 10
        recentlyPlayed.itemsMargin = 5
        recentlyPlayed.miniMarginPxBetweenItems = 0
        recentlyPlayed.miniAppearPxOfLastItem = 5
        recentlyPlayed.uniformItemSize = recentTrackSize
        //This must be called after changing any size or margin property of this class to get acurrate margin
        recentlyPlayed.setItemsMarginOnce()
        
        containerView.addSubview(recentlyPlayed)
        recentlyPlayed.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[controls]-(>=15)-[recentLabel(15)]-(5)-[recent(trackHeight@999)]-(30)-|", options: [], metrics: ["trackHeight": recentTrackSize.height], views: ["controls": controlsParentView, "recent": recentlyPlayed, "recentLabel": recentlyPlayedLabel]))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[recent]|", options: [], metrics: nil, views: ["recent": recentlyPlayed]))
        // for smaller screens (iPhone 5)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[controls]-(>=8)-[recent]", options: [], metrics: nil, views: ["controls": controlsParentView, "recent": recentlyPlayed]))
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        styleFromAudioStream()
        HistoryFetcher.delegate = self
        AudioStream.sharedInstance.delegate = self
        
        HistoryFetcher.fetchRecentTracks()
        recentUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(updateTick), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        HistoryFetcher.delegate = nil
        AudioStream.sharedInstance.delegate = nil
        recentUpdateTimer?.invalidate()
        recentUpdateTimer = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleFromAudioStream() {
        let name = AudioStream.sharedInstance.playing ? "pause" : "play"
        playButton.setImage(UIImage(named: name), forState: .Normal)
    }
    
    func updateRecentlyPlayed() {
        recentlyPlayed.removeAllItems()
        for track in HistoryFetcher.recentTracks {
            let trackView = RecentTrackView(frame: CGRectZero)
            trackView.styleFromTrack(track)
            recentlyPlayed.addItem(trackView)
        }
    }

    @IBAction func hitPlayButton(sender: AnyObject) {
        let stream = AudioStream.sharedInstance
        if (stream.playing) {
            stream.pause()
        }
        else {
            stream.play()
        }
    }

    @IBAction func skipButtonHit(sender: AnyObject) {
        AudioStream.sharedInstance.skipToLive()
    }
    
    // Slider
    
    func didTap(gesture: UITapGestureRecognizer) {
        if let slider = slider {
            var newPosition: SlidingViewControllerPosition!
            switch(slider.position) {
            case .Open:
                newPosition = .Closed
            case .Closed:
                newPosition = .Open
            }
            slider.updatePosition(newPosition, animated: true)
        }
    }
    
    // SlidingVCDelegate
    
    func openPercentageChanged(percent: CGFloat) {
        print("open percentage: \(percent)")
    }
    
    func positionUpdated(position: SlidingViewControllerPosition) {
        print("slider position updated")
    }
    
    // HistoryFetchDelegate
    
    func updatedHistory() {
        updateRecentlyPlayed()
    }
    
    // AudioStreamDelegate
    
    func streamStatusUpdated() {
        styleFromAudioStream()
    }
    
    // Timers
    
    func updateTick() {
        HistoryFetcher.fetchRecentTracks()
    }
    
}

