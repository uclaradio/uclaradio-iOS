//
//  ViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 4/26/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import UIKit
import MediaPlayer
import ASHorizontalScrollView

protocol NowPlayingActionDelegate {
    func didTapShow(_ show: Show?)
}

class NowPlayingViewController: UIViewController, HistoryFetchDelegate, SlidingVCDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var controlsParentView: UIView!
    @IBOutlet weak var pullTabImageView: UIImageView!
    
    var nowPlayingView: NowPlayingView!
    var recentlyPlayedLabel: UILabel!
    var recentlyPlayed: ASHorizontalScrollView!
    weak var sliderDelegate: SlidingVCDelegate?
    
    var actionDelegate: NowPlayingActionDelegate?
    fileprivate var nowPlaying: Show?
    
    fileprivate var recentUpdateTimer: Timer?
    fileprivate var tapGesture: UITapGestureRecognizer?
    private var lastOpenPercentage: CGFloat?
    
    // SlidingVCDelegate
    var slider: SlidingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.reallyDarkBlue
        
        imageView.image = UIImage(named: "radio_banner")
        
        nowPlayingView = NowPlayingView(canSkipStream: true)
        nowPlayingView.translatesAutoresizingMaskIntoConstraints = false
        controlsParentView.addSubview(nowPlayingView)
        
        let volumeView = MPVolumeView()
        controlsParentView.addSubview(volumeView)
        controlsParentView.backgroundColor = UIColor.clear
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.setVolumeThumbImage(UIImage(named: "volumeSlider")?.imageWithColor(UIColor.white), for: UIControlState())
        volumeView.setRouteButtonImage(UIImage(named: "airplayIcon")?.imageWithColor(UIColor.white), for: UIControlState())
        volumeView.tintColor = UIColor.white
        
        let controlsViews: [String: UIView] = ["nowPlaying": nowPlayingView, "volume": volumeView]
        controlsParentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nowPlaying]-[volume(30)]|", options: [], metrics: nil, views: controlsViews))
        controlsParentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[nowPlaying]-|", options: [], metrics: nil, views: controlsViews))
        controlsParentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[volume]-(40)-|", options: [], metrics: nil, views: controlsViews))
        
        recentlyPlayedLabel = UILabel()
        recentlyPlayedLabel.text = "Recently Played"
        recentlyPlayedLabel.textColor = UIColor.lightText
        recentlyPlayedLabel.font = UIFont(name: Constants.Fonts.titleBold, size: 14)
        containerView.addSubview(recentlyPlayedLabel)
        recentlyPlayedLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[recentLabel(150)]", options: [], metrics: nil, views: ["recentLabel": recentlyPlayedLabel]))
        
        let recentTrackSize = CGSize(width: (view.frame.size.width-20)/4, height: 90)
        
        // ASHorizontalScrollView is not optimized for auto layout, has to be initialized with frame, use auto layout for positioning
        recentlyPlayed = ASHorizontalScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: recentTrackSize.height))

        recentlyPlayed.defaultMarginSettings = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 10, miniAppearWidthOfLastItem: 5)
        recentlyPlayed.itemsMargin = 5
        recentlyPlayed.uniformItemSize = recentTrackSize
        //This must be called after changing any size or margin property of this class to get acurrate margin
        recentlyPlayed.setItemsMarginOnce()
        
        containerView.addSubview(recentlyPlayed)
        recentlyPlayed.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[controls]-(>=15)-[recentLabel(15)]-(5)-[recent(trackHeight)]-(30@998,>=8)-|", options: [], metrics: ["trackHeight": recentTrackSize.height], views: ["controls": controlsParentView, "recent": recentlyPlayed, "recentLabel": recentlyPlayedLabel]))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[recent]|", options: [], metrics: nil, views: ["recent": recentlyPlayed]))
        // for smaller screens (iPhone 5)
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[controls]-(>=8)-[recent]", options: [], metrics: nil, views: ["controls": controlsParentView, "recent": recentlyPlayed]))
        
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageView.addGestureRecognizer(tapGesture!)
        
        // pull tab
        pullTabImageView.image = UIImage(named: "pull_tab")
        pullTabImageView.isUserInteractionEnabled = true
        pullTabImageView.tintColor = UIColor.white
        let pullTabTap = UITapGestureRecognizer(target: self, action: #selector(didTapPullTab))
        pullTabImageView.addGestureRecognizer(pullTabTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nowPlayingView.willAppear()
        
        // fetch recently played
        HistoryFetcher.delegate = self
        HistoryFetcher.fetchRecentTracks()
        recentUpdateTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateTick), userInfo: nil, repeats: true)
        styleFromNowPlaying(RadioAPI.nowPlaying)
        
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingUpdated), name: NSNotification.Name(rawValue: RadioAPI.NowPlayingUpdatedNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nowPlayingView.willDisappear()
        
        // stop fetching recently played
        HistoryFetcher.delegate = nil
        recentUpdateTimer?.invalidate()
        recentUpdateTimer = nil
        
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleFromNowPlaying(_ nowPlaying: Show?) {
        if let nowPlaying = nowPlaying, let picture = nowPlaying.picture {
            imageView.sd_setImage(with: RadioAPI.absoluteURL(picture), placeholderImage: UIImage(named: "radio_banner"))
        }
        else {
            imageView.image = UIImage(named: "radio_banner")
        }
        self.nowPlaying = nowPlaying
    }
    
    func updateRecentlyPlayed() {
        if recentlyPlayed.items.count > 0 {
            if !recentlyPlayed.removeAllItems() {
                print("failed to remove recently played items")
            }
        }
        for track in HistoryFetcher.recentTracks {
            let trackView = RecentTrackView(frame: CGRect.zero)
            trackView.styleFromTrack(track)
            recentlyPlayed.addItem(trackView)
        }
    }
    
    // Slider
    
    func didTap(_ gesture: UITapGestureRecognizer) {
        actionDelegate?.didTapShow(nowPlaying)
    }
    
    func didTapPullTab(_ gesture: UITapGestureRecognizer) {
        actionDelegate?.didTapShow(nil)
    }
    
    // MARK: - SlidingVCDelegate
    
    func positionUpdated(_ position: SlidingViewControllerPosition) {
        if let slider = slider {
            if (slider.position == .closed) {
                pullTabImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)
            } else {
                pullTabImageView.transform = CGAffineTransform.identity
            }
        }
        lastOpenPercentage = nil
    }
    
    func openPercentageChanged(_ openPercentage: CGFloat) {
        if let lastOpenPercentage = lastOpenPercentage {
            if (openPercentage < lastOpenPercentage) {
                pullTabImageView.transform = CGAffineTransform.identity
            } else {
                pullTabImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)
            }
        }
        lastOpenPercentage = openPercentage
    }
    
    // MARK: - Radio APIFetchDelegate
    
    func nowPlayingUpdated(_ notification: Notification) {
        styleFromNowPlaying(RadioAPI.nowPlaying)
    }
    
    // HistoryFetchDelegate
    
    func updatedHistory() {
        updateRecentlyPlayed()
    }
    
    // Timers
    
    func updateTick() {
        HistoryFetcher.fetchRecentTracks()
        RadioAPI.fetchNowPlaying()
    }
    
}

