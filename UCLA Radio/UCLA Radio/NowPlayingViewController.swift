//
//  ViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 4/26/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import ASHorizontalScrollView
import SDWebImage

class RecentTrackView: UIView {
    
    var imageView: UIImageView!
    var title: UILabel!
    var subtitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        title = UILabel()
        title.font = UIFont.systemFontOfSize(10)
        title.textColor = UIColor.whiteColor()
        title.textAlignment = .Center
        subtitle = UILabel()
        subtitle.font = UIFont.systemFontOfSize(8)
        subtitle.textColor = UIColor.lightTextColor()
        subtitle.textAlignment = .Center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(title)
        addSubview(subtitle)
        addConstraints(preferredConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromTrack(track: RecentTrack) {
        if let url = track.image {
            imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "no_artwork"))
        }
        else {
            imageView.image = UIImage(named: "no_artwork")
        }
        title.text = track.title
        subtitle.text = track.artist
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let views = ["image": imageView, "title": title, "subtitle": subtitle]
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[image]-(5)-[title(10)]-(2)-[subtitle(10)]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[image]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[title]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[subtitle]-|", options: [], metrics: nil, views: views)
        return constraints
    }
}

class NowPlayingViewController: UIViewController, HistoryFetchDelegate, AudioStreamDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var controlsParentView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var recentlyPlayedLabel: UILabel!
    var recentlyPlayed: ASHorizontalScrollView!
    
    var recentUpdateTimer: NSTimer?
    
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
        
        controlsParentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[play]-(20)-[volume(>=30)]", options: [], metrics: nil, views: ["play": playButton, "volume": volumeView]))
        controlsParentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[volume]-(20)-|", options: [], metrics: nil, views: ["volume": volumeView]))
        
        recentlyPlayedLabel = UILabel()
        recentlyPlayedLabel.text = "Recently Played"
        recentlyPlayedLabel.textColor = UIColor.lightTextColor()
        recentlyPlayedLabel.font = UIFont.boldSystemFontOfSize(12)
        view.addSubview(recentlyPlayedLabel)
        recentlyPlayedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[recentLabel(150)]", options: [], metrics: nil, views: ["recentLabel": recentlyPlayedLabel]))
        
        // ASHorizontalScrollView is not optimized for auto layout, has to be initialized with frame, use auto layout for positioning
        recentlyPlayed = ASHorizontalScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70))
        
        recentlyPlayed.leftMarginPx = 10
        recentlyPlayed.itemsMargin = 5
        recentlyPlayed.miniMarginPxBetweenItems = 0
        recentlyPlayed.miniAppearPxOfLastItem = 5
        recentlyPlayed.uniformItemSize = CGSizeMake(80, 70)
        //This must be called after changing any size or margin property of this class to get acurrate margin
        recentlyPlayed.setItemsMarginOnce()
        
        self.view.addSubview(recentlyPlayed)
        recentlyPlayed.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[controls]-(>=15)-[recentLabel(15)]-(5)-[recent(70)]-(30)-|", options: [], metrics: nil, views: ["controls": controlsParentView, "recent": recentlyPlayed, "recentLabel": recentlyPlayedLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[recent]|", options: [], metrics: nil, views: ["recent": recentlyPlayed]))
        recentlyPlayed.sizeToFit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        styleFromAudioStream()
        HistoryFetcher.delegate = self
        AudioStream.sharedInstance.delegate = self
        
        recentUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(updateTick), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        HistoryFetcher.delegate = nil
        AudioStream.sharedInstance.delegate = nil
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
    
    // Timers
    
    func updateTick() {
        HistoryFetcher.fetchRecentTracks()
    }
    
    // HistoryFetchDelegate
    
    func updatedHistory() {
        updateRecentlyPlayed()
    }
    
    // AudioStreamDelegate
    
    func streamStatusUpdated() {
        styleFromAudioStream()
    }
}

