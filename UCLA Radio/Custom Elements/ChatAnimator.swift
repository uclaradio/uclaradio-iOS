//
//  ChatAnimator.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 1/21/19.
//  Copyright © 2019 UCLA Student Media. All rights reserved.
//

import UIKit

//This class is as of yet incomplete.  It will be used to implement the
//vertical sliding segue for our ChatView.

class ChatAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    var popStyle: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    //unused for now but required by the UIViewControllerAnimatedTransitioning protocol
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }

}
