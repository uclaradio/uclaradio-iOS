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

class NowPlayingViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var controlsParentView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    let player = AVPlayer(URL: NSURL(string: "http://stream.uclaradio.com:8000/listen")!)
    var playing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "radio_banner")
        
        titleLabel.textColor = Constants.Colors.gold
        titleLabel.text = "Live Stream"
        subtitleLabel.textColor = UIColor.whiteColor()
        subtitleLabel.text = "UCLA Radio"
        
        view.backgroundColor = Constants.Colors.darkBlue
        
        playButton.imageView?.contentMode = .ScaleAspectFit
        skipButton.imageView?.contentMode = .ScaleAspectFit
        
        let volumeView = MPVolumeView()
        controlsParentView.addSubview(volumeView)
        controlsParentView.backgroundColor = UIColor.clearColor()
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.setVolumeThumbImage(UIImage(named: "volumeSlider")?.imageWithColor(Constants.Colors.gold), forState: .Normal)
        volumeView.setRouteButtonImage(UIImage(named: "airplayIcon")?.imageWithColor(Constants.Colors.gold), forState: .Normal)
        volumeView.tintColor = Constants.Colors.gold
        
        controlsParentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[play]-(20)-[volume(>=30)]", options: [], metrics: nil, views: ["play": playButton, "volume": volumeView]))
        controlsParentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[volume]-(20)-|", options: [], metrics: nil, views: ["volume": volumeView]))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        styleFromAudioStream()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleFromAudioStream() {
        let name = AudioStream.sharedInstance.playing ? "pause" : "play"
        playButton.setImage(UIImage(named: name), forState: .Normal)
    }

    @IBAction func hitPlayButton(sender: AnyObject) {
        let stream = AudioStream.sharedInstance
        if (stream.playing) {
            stream.pause()
        }
        else {
            stream.play()
        }
        styleFromAudioStream()
    }

    @IBAction func skipButtonHit(sender: AnyObject) {
        AudioStream.sharedInstance.skipToLive()
    }
}

