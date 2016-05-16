//
//  SlidingViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/15/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

@objc enum SlidingViewControllerPosition: Int {
    case Open
    case Closed
}

@objc protocol SlidingVCDelegate {
    var MaximumHeight: CGFloat { get }
    var MinimumYPos: CGFloat { get }
    func positionUpdated(position: SlidingViewControllerPosition)
}

class SlidingViewController: UIViewController {
    
    var sliderDelegate: SlidingVCDelegate?
    var position: SlidingViewControllerPosition = .Open
    
    private let ClosedHeight: CGFloat = -100
    private let MinimumYPos: CGFloat = 0
    private let MaximumHeight: CGFloat = -80
    private let AnimationDuration = 0.3
    
    private var tapGesture: UITapGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?
    private var yPosConstraint: NSLayoutConstraint?
    private var initialRelativeYPos: CGFloat?
    
    init () {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addContent(content: UIViewController) {
        addChildViewController(content)
        view.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[content]|", options: [], metrics: nil, views: ["content": content.view]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[content]|", options: [], metrics: nil, views: ["content": content.view]))
        content.didMoveToParentViewController(self)
        if let delegate = content as? SlidingVCDelegate {
            sliderDelegate = delegate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapGesture!)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        view.addGestureRecognizer(panGesture!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updatePosition(.Open, animated: false)
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
    
    func updatePosition(position: SlidingViewControllerPosition, animated: Bool) {
        switch position {
        case .Open:
            yPosConstraint?.constant = -view.frame.size.height
        case .Closed:
            yPosConstraint?.constant = ClosedHeight
        }
        self.position = position
        sliderDelegate?.positionUpdated(position)
        
        if (animated) {
            UIView.animateWithDuration(AnimationDuration, animations: {
                    self.view.superview?.layoutIfNeeded()
                })
        }
    }
    
    func didTap(gesture: UITapGestureRecognizer) {
        var newPosition: SlidingViewControllerPosition!
        switch(position) {
        case .Open:
            newPosition = .Closed
        case .Closed:
            newPosition = .Open
        }
        updatePosition(newPosition, animated: true)
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
            updatePosition((shouldOpen ? .Open : .Closed), animated: true)
            initialRelativeYPos = nil
            break;
        default:
            break;
        }
    }
}
