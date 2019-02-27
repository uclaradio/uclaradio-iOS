//
//  ChatViewController.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 1/21/19.
//  Copyright © 2019 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController: UIViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    let transition = ChatAnimator()
    
    var chatView: ChatView!
    
    override func viewDidLoad() {
        //set background image
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        chatView = ChatView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        self.view.addSubview(chatView)
        
        //self.transitioningDelegate = self
        //navigationController?.delegate = self
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.popStyle = (operation == .push)
        //transition.pushStyle = (operation == .push)
        return transition
    }
    
}

