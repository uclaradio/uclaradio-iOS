//
//  ChatAnimator.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 1/21/19.
//  Copyright © 2019 UCLA Student Media. All rights reserved.
//

import UIKit

class ChatAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    var popStyle: Bool = false
    //var pushStyle: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: .to)!
        
//        containerView.addSubview(toView)
//        toView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//        UIView.animate(withDuration: duration,
//                       animations: {
//                        
//                        toView.bounds = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//        },
//                       completion: { _ in
//                        transitionContext.completeTransition(true)
//        }
//        )
        
        print("animation loaded")
    }

}
