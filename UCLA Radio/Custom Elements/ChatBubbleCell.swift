//
//  ChatBubbleCell.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 1/31/19.
//  Copyright © 2019 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

class ChatBubbleCell: UITableViewCell {
    
    var bubbleColor: UIColor!
    var isRight: Bool = false;
    
    //This is important.  UITableViewCells can have various different styles dealing with how the different
    //views contained in them are arranged.  We use the subtitle style, because it most fits our needs, it has
    //one big text field with a smaller one underneath, so one big field for our text, and a smaller one for
    //username and time.
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        var bezierPath = UIBezierPath()
  
        //this is where we draw the chat bubble shape itself.
        bezierPath = UIBezierPath(roundedRect: CGRect(x: (self.textLabel?.frame.minX)!-10, y: (self.textLabel?.frame.maxY)!, width: (self.textLabel?.bounds.width)!+20, height: (self.textLabel?.bounds.height)!),
                                    byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight],
                                    cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        //This part's a little confusing.  We invert the contents of the cell, effectively making it an upside
        //down cell.  We do this because we flipped the ChatView upside down in its class in order to have cells
        //appear from the bottom to the top, so we have to flip our cells upside down to account for that.
        self.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        bubbleColor.setFill()
        bezierPath.fill()
        bezierPath.close()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //This block just says, if our cell is supposed to be on the right side of the screen, push everything
        //over to the right.  We use it because user-messages are on the right, and others are on the left.
        
        if(isRight){
            let width = self.frame.width
        
            self.textLabel?.frame = CGRect(x: width - (self.textLabel?.frame.maxX)!, y: (self.textLabel?.frame.minY)!, width: (self.textLabel?.frame.width)!, height: (self.textLabel?.frame.height)!)
        
            self.detailTextLabel?.frame = CGRect(x: width - (self.detailTextLabel?.frame.maxX)!, y: (self.detailTextLabel?.frame.minY)!, width: (self.detailTextLabel?.frame.width)!, height: (self.detailTextLabel?.frame.height)!)
            
        }
    }
    
}
