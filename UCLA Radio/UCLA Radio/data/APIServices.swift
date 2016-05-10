//
//  APIServices.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/9/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import Alamofire

struct RecentTrack {
    let title: String
    let artist: String
    let img: String
    
    init(title: String, artist: String, img: String) {
        self.title = title
        self.artist = artist
        self.img = img
    }
}

class APIServices {
    
    
    func fetchRecentTracks() {
        
    }
    
}
