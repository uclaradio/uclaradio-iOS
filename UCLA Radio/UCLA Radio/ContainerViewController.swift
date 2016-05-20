//
//  ContainerViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/15/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController {
    
    // Now Playing slider
    var slider: SlidingViewController!
    var nowPlaying: NowPlayingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = Constants.Colors.lightBlue
        
        let root = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("rootNav")
        view.addSubview(root.view)
        addChildViewController(root)
        root.didMoveToParentViewController(self)
        root.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[root]", options: [], metrics: nil, views: ["root": root]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[root]", options: [], metrics: nil, views: ["root": root]))
        
        installNowPlayingSlider()
    }
    
    func installNowPlayingSlider() {
        if slider != nil {
            return
        }
        // set up slider view controller (container)
        slider = SlidingViewController()
        view.addSubview(slider.view)
        addChildViewController(slider)
        slider.didMoveToParentViewController(self)
        view.addConstraints(slider.preferredConstraints())
        
        // set up content (NowPlayingViewController)
        if let nowPlaying = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("nowPlaying") as? NowPlayingViewController {
            self.nowPlaying = nowPlaying
            slider.addContent(nowPlaying)
            
            // set up slider tab (NowPlayingView)
            let tabView = NowPlayingView(canSkipStream: false)
            slider.addTabView(tabView)
        }
    }
    
}
