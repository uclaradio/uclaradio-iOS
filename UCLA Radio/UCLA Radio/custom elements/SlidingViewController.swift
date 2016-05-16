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
    weak var slider: SlidingViewController? { get set }
    var MaximumHeight: CGFloat { get }
    var MinimumYPosition: CGFloat { get }
    var ClosedHeight: CGFloat { get }
    func openPercentageChanged(percent: CGFloat)
    func positionUpdated(position: SlidingViewControllerPosition)
}

class SlidingViewController: UIViewController {
    
    weak var sliderDelegate: SlidingVCDelegate?
    var position: SlidingViewControllerPosition = .Open
    
    private let AnimationDuration = 0.3
    
    private var panGesture: UIPanGestureRecognizer?
    private var yPositionConstraint: NSLayoutConstraint?
    private var initialRelativeYPosition: CGFloat?
    
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
            sliderDelegate?.slider = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
        yPositionConstraint = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: view.superview, attribute: .Bottom, multiplier: 1.0, constant: 0)
        constraints.append(yPositionConstraint!)
        return constraints
    }
    
    func updatePosition(position: SlidingViewControllerPosition, animated: Bool) {
        switch position {
        case .Open:
            yPositionConstraint?.constant = -view.frame.size.height
        case .Closed:
            if let delegate = sliderDelegate {
                yPositionConstraint?.constant = delegate.ClosedHeight
            }
        }
        view.superview?.setNeedsLayout()
        self.position = position
        sliderDelegate?.positionUpdated(position)
        
        if (animated) {
            UIView.animateWithDuration(AnimationDuration, animations: {
                    self.view.superview?.layoutIfNeeded()
                })
        }
    }
    
    func didPan(gesture: UIPanGestureRecognizer) {
        let touchLocation = gesture.locationInView(view.superview)
        if initialRelativeYPosition == nil {
            initialRelativeYPosition = gesture.locationInView(view).y
        }
        
        switch(gesture.state) {
        case .Began:
            break;
        case .Changed:
            if let relativeYPosition = initialRelativeYPosition, let delegate = sliderDelegate {
                let MaximumYPosition = delegate.MaximumHeight + view.frame.size.height
                let touchYPosition = touchLocation.y - relativeYPosition
                let newYPosition: CGFloat = max(delegate.MinimumYPosition, min(MaximumYPosition, touchYPosition))
                view.frame.origin = CGPointMake(0, newYPosition)
                
                let openPercentage = 1.0 - (newYPosition-delegate.MinimumYPosition)/(MaximumYPosition-delegate.MinimumYPosition)
                sliderDelegate?.openPercentageChanged(openPercentage)
            }
        default:
            let shouldOpen = touchLocation.y < view.frame.size.height/2 || gesture.velocityInView(view?.superview).y < -300
            updatePosition((shouldOpen ? .Open : .Closed), animated: true)
            initialRelativeYPosition = nil
        }
    }
}
