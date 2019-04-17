//
//  ViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 4/26/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import UIKit
import MediaPlayer

protocol NowPlayingActionDelegate {
    func didTapShow(_ show: Show?)
}

class NowPlayingViewController: UIViewController{

    @IBOutlet weak var containerView: UIView!
    var imageView: UIImageView!
    //@IBOutlet weak var controlsParentView: UIView!
    
    var nowPlayingView: NowPlayingContainerView!
    
    var actionDelegate: NowPlayingActionDelegate?
    fileprivate var nowPlaying: Show?
    
    fileprivate var tapGesture: UITapGestureRecognizer?
    private var lastOpenPercentage: CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set the background image
        self.view.backgroundColor = UIColor.clear
        
        nowPlayingView = NowPlayingContainerView(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height))
        
        containerView.addSubview(nowPlayingView)
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[nowPlaying]-|", options: [], metrics: nil, views: ["nowPlaying": nowPlayingView]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[nowPlaying]-|", options: [], metrics: nil, views: ["nowPlaying": nowPlayingView]))
        
        containerView.addConstraint(NSLayoutConstraint(item: nowPlayingView, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 1.0, constant: 0.0))

        containerView.addConstraint(NSLayoutConstraint(item: nowPlayingView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1.0, constant: 0.0))
        
            containerView.addConstraint(NSLayoutConstraint(item: nowPlayingView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        
//        containerView.safeAreaInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        imageView = nowPlayingView.imageView
        imageView.image = UIImage(named: "radio_banner")
        
        // spicy
        containerView.topAnchor.constraint(lessThanOrEqualTo: topLayoutGuide.bottomAnchor).isActive = true
        
        
    }
    
    //while a little bizarre, we must make the playButton circular in the viewDidLayoutSubviews() function of the viewcontroller which ultimately controls it
    override func viewDidLayoutSubviews() {
        let playButton = self.nowPlayingView.playButton!
        playButton.layer.cornerRadius = 0.5*playButton.bounds.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nowPlayingView.willAppear()
        styleFromNowPlaying(RadioAPI.nowPlaying)
        
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingUpdated), name: NSNotification.Name(rawValue: RadioAPI.NowPlayingUpdatedNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //nowPlayingView.willDisappear()

        //NotificationCenter.default.removeObserver(self)
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
    
    // Slider
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        //actionDelegate?.didTapShow(nowPlaying)
    }
    
    // MARK: - Radio APIFetchDelegate
    
    @objc func nowPlayingUpdated(_ notification: Notification) {
        styleFromNowPlaying(RadioAPI.nowPlaying)
    }
    
    // Timers
    
    func updateTick() {
        RadioAPI.fetchNowPlaying()
    }
    
}

