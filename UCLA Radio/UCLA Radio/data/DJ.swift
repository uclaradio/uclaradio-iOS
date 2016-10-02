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
    
    init(username: String, djName: String, fullName: String?, picture: String?) {
        self.username = username
        self.djName = djName
        self.fullName = fullName
        self.picture = picture
    }
    
    convenience init(username: String, djName: String) {
        self.init(username: username, djName: djName, fullName: nil, picture: nil)
    }
    
    static func djsFromJSON(_ djsArray: NSArray) -> [DJ] {
        var result: [DJ] = []
        for djObject: Any in djsArray {
            if let dj = djObject as? NSDictionary, let username = dj["username"] as? String, let djName = dj["djName"] as? String {
                let newDJ = DJ(username: username, djName: djName)
                
                // optional properties
                if let fullName = dj["fullName"] as? String , fullName.characters.count > 0 {
                    newDJ.fullName = fullName
                }
                if let picture = dj["picture"] as? String , picture.characters.count > 0 {
                    newDJ.picture = picture
                }
                
                result.append(newDJ)
            }
        }
        return result
    }
}
