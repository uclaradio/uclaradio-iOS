//
//  ContainerViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/15/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit
import KRLCollectionViewGridLayout

class ContainerViewController: UIViewController, NowPlayingActionDelegate {
    
    // Menu
    var rootNavController: UINavigationController!
    
    // Now Playing slider
    var slider: SlidingViewController!
    var nowPlaying: NowPlayingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        let menu = MenuViewController()
        rootNavController = UINavigationController(rootViewController: menu)
        view.addSubview(rootNavController.view)
        addChildViewController(rootNavController)
        rootNavController.didMove(toParentViewController: self)
        rootNavController.view.translatesAutoresizingMaskIntoConstraints = false
        rootNavController.view.backgroundColor = Constants.Colors.lightPink
        rootNavController.navigationBar.barTintColor = Constants.Colors.darkPink
        // back button color
        rootNavController.navigationBar.tintColor = UIColor.white
        // title color
        if let titleFont = UIFont(name: Constants.Fonts.title, size: 21) {
            rootNavController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: titleFont]
        }
        
        installNowPlayingSlider()
        
        view.addConstraints(preferredConstraints())
    }
    
    func installNowPlayingSlider() {
        if slider != nil {
            return
        }
        // set up slider view controller (container)
        slider = SlidingViewController()
        view.addSubview(slider.view)
        addChildViewController(slider)
        slider.didMove(toParentViewController: self)
        view.addConstraints(slider.preferredConstraints())
        
        // set up content (NowPlayingViewController)
        if let nowPlaying = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nowPlaying") as? NowPlayingViewController {
            self.nowPlaying = nowPlaying
            nowPlaying.actionDelegate = self
            slider.addContent(nowPlaying)
            
            // set up slider tab (NowPlayingView)
            let tabView = NowPlayingView(canSkipStream: false)
            slider.addTabView(tabView)
            tabView.backgroundColor = UIColor.black
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - NowPlayingActionDelegate
    
    func didTapShow(_ show: Show?) {
        slider.updatePosition(.closed, animated: true)
        if let show = show, show.picture != nil {
            if let showVC = rootNavController.visibleViewController as? ShowViewController, let presentedShow = showVC.show {
                if (show.id == presentedShow.id) {
                    // don't push the show's view controller if it's already up
                    return
                }
            }
            
            if let showViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ShowViewController.storyboardID) as? ShowViewController {
                
                showViewController.show = show
                delay(0.3, closure: {
                    self.rootNavController.pushViewController(showViewController, animated: true)
                })
            }
        }
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        let metrics = ["tabSpace": NowPlayingView.PreferredHeight]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[nav]-(tabSpace)-|", options: [], metrics: metrics, views: ["nav": rootNavController.view])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[nav]|", options: [], metrics: nil, views: ["nav": rootNavController.view])
        
        return constraints
    }

}
