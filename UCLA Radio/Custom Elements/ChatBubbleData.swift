//
//  ChatBubbleData.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 2/14/19.
//  Copyright © 2019 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

//This class is a simple data structure which holds all the necessary information
//to create a chat message.  We do this to save on resource usage etc associated
//with creating and accessing ChatBubbleCells over and over again, instead simply
//creating cells with data from these ChatBubbleData objects, which are comparatively
//fast and easy to manipulate and access.  Additionally the implementation of
//the UITableViewController itself necessitates an array of objects holding data
//for the TableViewCells.

class ChatBubbleData{
    
    var user: Bool = false;
    
    var message: String
    var userName: String
    var time: String
    
    init(message: String, username: String, time: String, user: Bool){
        self.message = message
        self.userName = username
        self.time = time
        self.user = user
    }
    
}
