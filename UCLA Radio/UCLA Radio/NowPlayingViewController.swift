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

class NowPlayingViewController: UIViewController, HistoryFetchDelegate, APIFetchDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var controlsParentView: UIView!
    
    var nowPlayingView: NowPlayingView!
    var recentlyPlayedLabel: UILabel!
    var recentlyPlayed: ASHorizontalScrollView!
    
    var recentUpdateTimer: NSTimer?
    var tapGesture: UITapGestureRecognizer?
    
    // SlidingVCDelegate
    var slider: SlidingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.darkBlue
        
        imageView.image = UIImage(named: "radio_banner")
        
        nowPlayingView = NowPlayingView(canSkipStream: true)
        nowPlayingView.translatesAutoresizingMaskIntoConstraints = false
        controlsParentView.addSubview(nowPlayingView)
        
        let volumeView = MPVolumeView()
        controlsParentView.addSubview(volumeView)
        controlsParentView.backgroundColor = UIColor.clearColor()
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.setVolumeThumbImage(UIImage(named: "volumeSlider")?.imageWithColor(Constants.Colors.gold), forState: .Normal)
        volumeView.setRouteButtonImage(UIImage(named: "airplayIcon")?.imageWithColor(Constants.Colors.gold), forState: .Normal)
        volumeView.tintColor = Constants.Colors.gold
        
        let controlsViews = ["nowPlaying": nowPlayingView, "volume": volumeView]
        controlsParentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[nowPlaying]-[volume(30)]|", options: [], metrics: nil, views: controlsViews))
        controlsParentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[nowPlaying]-|", options: [], metrics: nil, views: controlsViews))
        controlsParentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(40)-[volume]-(40)-|", options: [], metrics: nil, views: controlsViews))
        
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
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[controls]-(>=15)-[recentLabel(15)]-(5)-[recent(trackHeight@999)]-(30@998,>=8)-|", options: [], metrics: ["trackHeight": recentTrackSize.height], views: ["controls": controlsParentView, "recent": recentlyPlayed, "recentLabel": recentlyPlayedLabel]))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[recent]|", options: [], metrics: nil, views: ["recent": recentlyPlayed]))
        // for smaller screens (iPhone 5)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[controls]-(>=8)-[recent]", options: [], metrics: nil, views: ["controls": controlsParentView, "recent": recentlyPlayed]))
        
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
//        imageView.userInteractionEnabled = true
//        imageView.addGestureRecognizer(tapGesture!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nowPlayingView.willAppear()
        
        // fetch recently played
        HistoryFetcher.delegate = self
        HistoryFetcher.fetchRecentTracks()
        recentUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(updateTick), userInfo: nil, repeats: true)
        
        RadioAPI.fetchNowPlaying(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        nowPlayingView.willDisappear()
        
        // stop fetching recently played
        HistoryFetcher.delegate = nil
        recentUpdateTimer?.invalidate()
        recentUpdateTimer = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleFromNowPlaying(nowPlaying: Show?) {
        if let nowPlaying = nowPlaying, let picture = nowPlaying.picture {
            imageView.sd_setImageWithURL(NSURL(string: RadioAPI.absoluteURL(picture)), placeholderImage: UIImage(named: "radio_banner"))
        }
        else {
            imageView.image = UIImage(named: "radio_banner")
        }
    }
    
    func updateRecentlyPlayed() {
        recentlyPlayed.removeAllItems()
        for track in HistoryFetcher.recentTracks {
            let trackView = RecentTrackView(frame: CGRectZero)
            trackView.styleFromTrack(track)
            recentlyPlayed.addItem(trackView)
        }
    }
    
    // Slider
    
//    func didTap(gesture: UITapGestureRecognizer) {
//
//    }
    
    // MARK: - Radio APIFetchDelegate
    
    func cachedDataAvailable(data: AnyObject) {
        if let show = data as? Show {
            styleFromNowPlaying(show)
        }
    }
    
    func didFetchData(data: AnyObject) {
        if let show = data as? Show {
            styleFromNowPlaying(show)
        }
    }
    
    func failedToFetchData(error: String) {
        styleFromNowPlaying(nil)
    }
    
    // HistoryFetchDelegate
    
    func updatedHistory() {
        updateRecentlyPlayed()
    }
    
    // Timers
    
    func updateTick() {
        HistoryFetcher.fetchRecentTracks()
        RadioAPI.fetchNowPlaying(self)
    }
    
}

