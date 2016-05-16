//
//  MenuViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/15/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    // Now Playing slider
    var slider: SlidingViewController!
    var nowPlaying: NowPlayingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        installNowPlayingSlider()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func installNowPlayingSlider() {
        if slider != nil {
            return
        }
        slider = SlidingViewController()
        view.addSubview(slider.view)
        addChildViewController(slider)
        slider.didMoveToParentViewController(self)
        view.addConstraints(slider.preferredConstraints())
        
        if let nowPlaying = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("nowPlaying") as? NowPlayingViewController {
            self.nowPlaying = nowPlaying
            slider.addContent(nowPlaying)
        }
    }
    
}
