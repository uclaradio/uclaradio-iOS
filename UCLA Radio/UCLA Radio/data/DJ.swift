//
//  DJ.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation

class DJ {
    let username: String
    var fullName: String?
    var djName: String?
    var picture: String?
    
    init(username: String, fullName: String?, djName: String?, picture: String?) {
        self.username = username
        self.fullName = fullName
        self.djName = djName
        self.picture = picture
    }
    
    convenience init(username: String) {
        self.init(username: username, fullName: nil, djName: nil, picture: nil)
    }
    
    static func djsFromJSON(shows: NSArray) -> [DJ] {
        var result: [DJ] = []
        for djObject: AnyObject in shows {
            if let dj = djObject as? NSDictionary, let username = dj["username"] as? String {
                let newDJ = DJ(username: username)
                
                // optional properties
                if let fullName = dj["fullName"] as? String where fullName.characters.count > 0 {
                    newDJ.fullName = fullName
                }
                if let djName = dj["djName"] as? String where djName.characters.count > 0 {
                    newDJ.djName = djName
                }
                if let picture = dj["picture"] as? String where picture.characters.count > 0 {
                    newDJ.picture = picture
                }
                
                result.append(newDJ)
            }
        }
        return result
    }
}
