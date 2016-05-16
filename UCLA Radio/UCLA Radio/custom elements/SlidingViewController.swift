//
//  SlidingViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/15/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class SlidingViewController: UIViewController {
    
    private let ClosedHeight: CGFloat = -100
    private let MinimumYPos: CGFloat = 0
    private let MaximumHeight: CGFloat = -80
    private let AnimationDuration = 0.3
    
    var tapGesture: UITapGestureRecognizer?
    var panGesture: UIPanGestureRecognizer?
    private var yPosConstraint: NSLayoutConstraint?
    private var open = false
    private var initialRelativeYPos: CGFloat?
    
    init () {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.greenColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapGesture!)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        view.addGestureRecognizer(panGesture!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateYPosConstraint(true, animated: false)
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: view.superview, attribute: .Width, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: view.superview, attribute: .Height, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: view.superview, attribute: .CenterX, multiplier: 1.0, constant: 0))
        yPosConstraint = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: view.superview, attribute: .Bottom, multiplier: 1.0, constant: 0)
        constraints.append(yPosConstraint!)
        return constraints
    }
    
    func updateYPosConstraint(shouldOpen: Bool, animated: Bool) {
        self.yPosConstraint?.constant = shouldOpen ? -self.view.frame.size.height : self.ClosedHeight
        if (animated) {
            UIView.animateWithDuration(AnimationDuration, animations: {
                    self.view.superview?.layoutIfNeeded()
                })
        }
        open = shouldOpen
    }
    
    func didTap(gesture: UITapGestureRecognizer) {
        updateYPosConstraint(!open, animated: true)
    }
    
    func didPan(gesture: UIPanGestureRecognizer) {
        let touchLocation = gesture.locationInView(view.superview)
        if initialRelativeYPos == nil {
            initialRelativeYPos = gesture.locationInView(view).y
        }
        
        switch(gesture.state) {
        case .Changed:
            if let relativeYPos = initialRelativeYPos {
                let touchYPosition = touchLocation.y - relativeYPos
                let newYPosition: CGFloat = max(MinimumYPos, min(MaximumHeight + view.frame.size.height, touchYPosition))
                view.frame.origin = CGPointMake(0, newYPosition)
            }
            break;
        case .Ended:
            let shouldOpen = touchLocation.y < view.frame.size.height/2 || gesture.velocityInView(view?.superview).y < -300
            updateYPosConstraint(shouldOpen, animated: true)
            initialRelativeYPos = nil
            break;
        default:
            break;
        }
    }
}
