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

let streamURL = NSURL(string: "http://stream.uclaradio.com:8000/listen")!

class AudioStream: NSObject {
    
    static let sharedInstance = AudioStream()
    static let StreamUpdateNotificationKey = "StreamUpdated"
    
    var readyToPlay = false
    var playing = false
    
    private var audioPlayer = AVPlayer(URL: streamURL)
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func play() {
        if (!readyToPlay) {
            setupStream()
            readyToPlay = true
        }
        
        if (audioPlayer.status == .ReadyToPlay && !playing) {
            audioPlayer.play()
            playing = true
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
            NSNotificationCenter.defaultCenter().postNotificationName(AudioStream.StreamUpdateNotificationKey, object: nil)
        }
    }
    
    func pause() {
        if (playing) {
            audioPlayer.pause()
            playing = false
            NSNotificationCenter.defaultCenter().postNotificationName(AudioStream.StreamUpdateNotificationKey, object: nil)
        }
    }
    
    func togglePlay() {
        if (playing) {
            pause()
        }
        else {
            play()
        }
    }
    
    func setupStream() {
        // Set up AVAudioSession
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        audioPlayer.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .New, context: nil)
        audioPlayer.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .New, context: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sessionInterrupted), name: AVAudioSessionInterruptionNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateNowPlaying), name: RadioAPI.NowPlayingUpdatedNotification, object: nil)
        
        updateNowPlaying()
    }
    
    /**
     Reset audio stream to get live stream
     */
    func skipToLive() {
        let newItem = AVPlayerItem(URL: streamURL)
        audioPlayer.replaceCurrentItemWithPlayerItem(newItem)
        play()
        NSNotificationCenter.defaultCenter().postNotificationName(AudioStream.StreamUpdateNotificationKey, object: nil)
    }
    
    /**
     Update now playing information which is used by iOS in the control center, lock screen
     */
    func updateNowPlaying() {
        var nowPlayingDict: [String: AnyObject] = [:]
        nowPlayingDict[MPMediaItemPropertyArtist] = "UCLA Radio"
        var title = "Live Stream"
        if let nowPlayingTitle = RadioAPI.nowPlaying?.title {
            title = nowPlayingTitle
        }
        nowPlayingDict[MPMediaItemPropertyTitle] = title
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingDict
    }
    
    // Notifications
    
    func sessionInterrupted(notification: NSNotification) {
        playing = false
        readyToPlay = false
        NSNotificationCenter.defaultCenter().postNotificationName(AudioStream.StreamUpdateNotificationKey, object: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let player = object as? AVPlayer {
            if keyPath == "playbackBufferEmpty" {
                if let empty = player.currentItem?.playbackBufferEmpty where empty {
                    player.play()
                    print("playbackBufferEmpty")
                }
                else {
                    print("playbackBuffer not Empty")
                }
            }
            else if keyPath == "playbackLikelyToKeepUp" {
                print("playbackLikelyToKeepUp")
            }
        }
    }
    
}
