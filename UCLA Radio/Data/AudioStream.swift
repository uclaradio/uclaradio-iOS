//
//  AudioStream.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/2/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import SDWebImage

// will be overriden by api at uclaradio.com/api/streamurl
fileprivate let DefaultStreamURL = "http://uclaradio.com:8000/listen"

class AudioStream: NSObject, APIFetchDelegate {
    
    static let sharedInstance = AudioStream()
    static let StreamUpdateNotificationKey = "StreamUpdated"
    
    var readyToPlay = false
    var playing = false
    private var streamURL = URL(string: DefaultStreamURL)!
    
    private var audioPlayer = AVPlayer()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func play() {
        if (!readyToPlay) {
            setupStream()
            readyToPlay = true
        }
        
        if !playing {
            audioPlayer.play()
            playing = true
            UIApplication.shared.beginReceivingRemoteControlEvents()
            NotificationCenter.default.post(name: Notification.Name(rawValue: AudioStream.StreamUpdateNotificationKey), object: nil)
        }
    }
    
    func pause() {
        if playing {
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
    
    private func setupStream() {
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
        
        let newItem = AVPlayerItem(url: streamURL)
        audioPlayer.replaceCurrentItem(with: newItem)
        RadioAPI.fetchStreamURL(self)
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
    @objc func updateNowPlaying() {
        var nowPlayingDict: [String: AnyObject] = [:]
        nowPlayingDict[MPMediaItemPropertyArtist] = "UCLA Radio" as AnyObject?
        let title =  RadioAPI.nowPlaying?.title ?? "Live Stream"
        
        var artworkSet = false
        if let picture = RadioAPI.nowPlaying?.picture {
            let imageURL = RadioAPI.absoluteURL(picture)
            // Picture available for show
            if SDWebImageManager.shared().cachedImageExists(for: imageURL),
                let picture = SDImageCache.shared().imageFromMemoryCache(forKey: SDWebImageManager.shared().cacheKey(for: imageURL)) {
                // Set image
                let artwork = MPMediaItemArtwork(image: picture)
                nowPlayingDict[MPMediaItemPropertyArtwork] = artwork
                artworkSet = true
            } else {
                // Download image
                SDWebImageManager.shared().downloadImage(with: imageURL, options: [.continueInBackground], progress: nil, completed: { (image, error, source, finished, url) in
                    self.updateNowPlaying()
                })
            }
        }
        if !artworkSet, let picture = UIImage(named: "radio") {
            // No picture for show, use placeholder
            let artwork = MPMediaItemArtwork(image: picture)
            nowPlayingDict[MPMediaItemPropertyArtwork] = artwork
        }
        
        nowPlayingDict[MPMediaItemPropertyTitle] = title as AnyObject?
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingDict
    }
    
    // MARK:- APIFetchDelegate
    
    func cachedDataAvailable(_ data: Any) {
        if let streamURLString = data as? String,
            streamURLString != self.streamURL.absoluteString,
            let streamURL = URL(string: streamURLString) {
            self.streamURL = streamURL
            skipToLive()
        }
    }
    
    func didFetchData(_ data: Any) {
        if let streamURLString = data as? String,
            streamURLString != self.streamURL.absoluteString,
            let streamURL = URL(string: streamURLString) {
            self.streamURL = streamURL
            skipToLive()
        }
    }
    
    func failedToFetchData(_ error: String) {
        // No-op
    }
    
    // Notifications
    
    @objc func sessionInterrupted(_ notification: Notification) {
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
