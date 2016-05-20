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
    
    var contentViewController: UIViewController?
    var tabView: UIView?
    
    var position: SlidingViewControllerPosition = .Open
    weak var sliderDelegate: SlidingVCDelegate?
    
    private let AnimationDuration = 0.3
    
    private var panGesture: UIPanGestureRecognizer?
    private var tabPanGesture: UIPanGestureRecognizer?
    private var tabTapGesture: UITapGestureRecognizer?
    private var yPositionConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var contentYPositionContraint: NSLayoutConstraint?
    private var contentHeightPositionContraint: NSLayoutConstraint?
    private var initialRelativeYPosition: CGFloat?
    
    init () {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addContent(content: UIViewController) {
        contentViewController = content
        addChildViewController(content)
        view.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        
        contentHeightPositionContraint = NSLayoutConstraint(item: content.view, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0.0)
        view.addConstraint(contentHeightPositionContraint!)
        contentYPositionContraint = NSLayoutConstraint(item: content.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        view.addConstraint(contentYPositionContraint!)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[content]|", options: [], metrics: nil, views: ["content": content.view]))
        content.didMoveToParentViewController(self)
        if let delegate = content as? SlidingVCDelegate {
            sliderDelegate = delegate
            sliderDelegate?.slider = self
        }
    }
    
    func addTabView(tabView: UIView) {
        self.tabView = tabView
        view.addSubview(tabView)
        let tabHeight = tabView.frame.size.height
        tabView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tab]|", options: [], metrics: nil, views: ["tab": tabView]))
        view.addConstraint(NSLayoutConstraint(item: tabView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tabView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: tabHeight))
        view.superview?.setNeedsLayout()
        
        heightConstraint?.constant = tabHeight
        contentYPositionContraint?.constant = tabHeight
        contentHeightPositionContraint?.constant = -tabHeight
        
        tabView.userInteractionEnabled = true
        tabPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        tabView.addGestureRecognizer(tabPanGesture!)
        
        tabTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tabView.addGestureRecognizer(tabTapGesture!)
        
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
        heightConstraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: view.superview, attribute: .Height, multiplier: 1.0, constant: 0)
        constraints.append(heightConstraint!)
        constraints.append(NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: view.superview, attribute: .CenterX, multiplier: 1.0, constant: 0))
        yPositionConstraint = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: view.superview, attribute: .Bottom, multiplier: 1.0, constant: 0)
        constraints.append(yPositionConstraint!)
        return constraints
    }
    
    func updatePosition(position: SlidingViewControllerPosition, animated: Bool) {
        view.superview?.layoutIfNeeded()
        switch position {
        case .Open:
            let constant = -view.frame.size.height
            yPositionConstraint?.constant = constant
        case .Closed:
            var constant: CGFloat = 0
            if let tab = tabView {
                constant -= tab.frame.size.height
            }
            yPositionConstraint?.constant = constant
        }
        view.superview?.setNeedsLayout()
        self.position = position
        sliderDelegate?.positionUpdated(position)
        
        let alpha: CGFloat = (position == .Closed) ? 1.0 : 0.0
        if (animated) {
            UIView.animateWithDuration(AnimationDuration, animations: {
                    self.view.superview?.layoutIfNeeded()
                self.tabView?.alpha = alpha
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
                let MaximumYPosition = 20 + -tabView!.frame.size.height + contentViewController!.view.frame.size.height
                let touchYPosition = touchLocation.y - relativeYPosition
                let newYPosition: CGFloat = max(-tabView!.frame.size.height, min(MaximumYPosition, touchYPosition))
                view.frame.origin = CGPointMake(0, newYPosition)
                
                let openPercentage = 1.0 - (newYPosition-delegate.MinimumYPosition)/(MaximumYPosition-delegate.MinimumYPosition)
//                sliderDelegate?.openPercentageChanged(openPercentage)
                tabView?.alpha = 0.3 + 0.7*(1.0 - openPercentage)
            }
        default:
            let shouldOpen = touchLocation.y < view.frame.size.height/2 || gesture.velocityInView(view?.superview).y < -300
            updatePosition((shouldOpen ? .Open : .Closed), animated: true)
            initialRelativeYPosition = nil
        }
    }
    
    func didTap(gesture: UITapGestureRecognizer) {
        initialRelativeYPosition = nil
        updatePosition((position == .Closed) ? .Open : .Closed, animated: true)
    }
}
