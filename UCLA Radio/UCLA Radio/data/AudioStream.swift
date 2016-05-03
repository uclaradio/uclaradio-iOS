//
//  AudioStream.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/2/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioStream {
    
    static let sharedInstance = AudioStream()
    
    var playing = false
    
    private let streamUrl = "http://stream.uclaradio.com:8000/listen"
    private var audioPlayer = AVPlayer(URL: NSURL(string: "http://stream.uclaradio.com:8000/listen")!)
    
    // prevents others from using default '()' initializer for this class
    private init () {
        // Set up AVAudioSession
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        updateNowPlaying()
    }
    
    func togglePlay() {
        if (audioPlayer.status == .ReadyToPlay) {
            if (playing) {
                audioPlayer.pause()
                playing = false
            }
            else {
                audioPlayer.play()
                playing = true
                UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
            }
        }
    }
    
    func skipToLive() {
        
    }
    
    func updateNowPlaying() {
        var nowPlayingDict: [String: AnyObject] = [:]
        nowPlayingDict[MPMediaItemPropertyArtist] = "UCLA Radio"
        nowPlayingDict[MPMediaItemPropertyTitle] = "Pirate Radio"
        nowPlayingDict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingDict
    }
    
}
