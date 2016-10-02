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

let streamURL = URL(string: "http://stream.uclaradio.com:8000/listen")!

class AudioStream: NSObject {
    
    static let sharedInstance = AudioStream()
    static let StreamUpdateNotificationKey = "StreamUpdated"
    
    var readyToPlay = false
    var playing = false
    
    fileprivate var audioPlayer = AVPlayer(url: streamURL)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func play() {
        if (!readyToPlay) {
            setupStream()
            readyToPlay = true
        }
        
        if (audioPlayer.status == .readyToPlay && !playing) {
            audioPlayer.play()
            playing = true
            UIApplication.shared.beginReceivingRemoteControlEvents()
            NotificationCenter.default.post(name: Notification.Name(rawValue: AudioStream.StreamUpdateNotificationKey), object: nil)
        }
    }
    
    func pause() {
        if (playing) {
            audioPlayer.pause()
            playing = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: AudioStream.StreamUpdateNotificationKey), object: nil)
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
        
        audioPlayer.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        audioPlayer.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sessionInterrupted), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNowPlaying), name: NSNotification.Name(rawValue: RadioAPI.NowPlayingUpdatedNotification), object: nil)
        
        updateNowPlaying()
    }
    
    /**
     Reset audio stream to get live stream
     */
    func skipToLive() {
        let newItem = AVPlayerItem(url: streamURL)
        audioPlayer.replaceCurrentItem(with: newItem)
        play()
        NotificationCenter.default.post(name: Notification.Name(rawValue: AudioStream.StreamUpdateNotificationKey), object: nil)
    }
    
    /**
     Update now playing information which is used by iOS in the control center, lock screen
     */
    func updateNowPlaying() {
        var nowPlayingDict: [String: AnyObject] = [:]
        nowPlayingDict[MPMediaItemPropertyArtist] = "UCLA Radio" as AnyObject?
        var title = "Live Stream"
        if let nowPlayingTitle = RadioAPI.nowPlaying?.title {
            title = nowPlayingTitle
        }
        nowPlayingDict[MPMediaItemPropertyTitle] = title as AnyObject?
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingDict
    }
    
    // Notifications
    
    func sessionInterrupted(_ notification: Notification) {
        playing = false
        readyToPlay = false
        NotificationCenter.default.post(name: Notification.Name(rawValue: AudioStream.StreamUpdateNotificationKey), object: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let player = object as? AVPlayer {
            if keyPath == "playbackBufferEmpty" {
                if let empty = player.currentItem?.isPlaybackBufferEmpty , empty {
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
