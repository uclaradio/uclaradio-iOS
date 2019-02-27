//
//  ChatBubbleData.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 2/14/19.
//  Copyright © 2019 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

class ChatBubbleData{
    
    var user: Bool = false;
    
    var message: String!
    var userName: String!
    var time: String!
    
    init(message: String, username: String, time: String, user: Bool){
        self.message = message
        self.userName = username
        self.time = time
        self.user = user
    }
    
}
