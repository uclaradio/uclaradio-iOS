//
//  ViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 4/26/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    let player = AVPlayer(URL: NSURL(string: "http://stream.uclaradio.com:8000/listen")!)
    var playing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.setTitle("Play", forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func hitPlayButton(sender: AnyObject) {
        if (player.status == .ReadyToPlay) {
            if (playing) {
                player.pause()
                playing = false
                playButton.setTitle("Play", forState: .Normal)
            }
            else {
                player.play()
                playing = true
                playButton.setTitle("Pause", forState: .Normal)
            }
        }
    }

}

