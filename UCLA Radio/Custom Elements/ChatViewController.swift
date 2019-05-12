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
        
        //this line of code makes the chatbox lose focus when we tap outside of it and also makes the
        //keyboard go away when the chatbox loses focus
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.popStyle = (operation == .push)
        return transition
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}

