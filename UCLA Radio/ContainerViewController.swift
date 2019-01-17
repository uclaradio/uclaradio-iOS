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

class ContainerViewController: UIViewController{
    
    // Menu
    //var rootNavController: MenuNavController!
    var rootNavController: UINavigationController!
    
    var navImage: UIImageView!
    
    // Now Playing slider
    var slider: SlidingViewController!
    var nowPlaying: NowPlayingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        

        let menu = MenuPageViewController()
        
        //rootNavController = MenuNavController(rootViewController: menu)
        rootNavController = UINavigationController(rootViewController: menu)
        //rootNavController = MenuNavController(rootViewController: menu)
        //rootNavController.view.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 400)
        view.addSubview(rootNavController.view)
        addChildViewController(rootNavController)
        //self.navigationItem.title = "U C L A R A D I O"
        installNowPlayingSlider()
        //view.addSubview(navImage)
        
        if let navController = rootNavController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
        
        view.addConstraints(preferredConstraints())
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
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
        
        let chatView = ChatView()
        let tabView = chatView
        slider.addTabView(tabView)
        tabView.backgroundColor = UIColor.black
        
        // set up content (NowPlayingViewController)
        //if let nowPlaying = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nowPlaying") as? NowPlayingViewController {
            //self.nowPlaying = nowPlaying
            //nowPlaying.actionDelegate = self
            //slider.addContent(nowPlaying)
            
            // set up slider tab (NowPlayingView)
            //let tabView = NowPlayingView(canSkipStream: false)
            //slider.addTabView(tabView)
            //tabView.backgroundColor = UIColor.black
        //}
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
        
        let metrics = ["tabSpace": NowPlayingContainerView.PreferredHeight]
        //constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[header]-|", options: [], metrics: metrics, views: ["header": navImage])
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[nav]|", options: [], metrics: nil, views: ["nav": rootNavController.view])
        //constraints.append(NSLayoutConstraint(item: navImage, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 1.0))
        //constraints.append(NSLayoutConstraint(item: rootNavController.view, attribute: .top, relatedBy: .equal, toItem: navImage, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        return constraints
    }
    
    struct System {
        static func clearNavigationBar(forBar navBar: UINavigationBar) {
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }

}
