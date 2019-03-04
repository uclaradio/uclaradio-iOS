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
    var rootNavController: UINavigationController!
    
    
    // Chat slider
    var slider: SlidingViewController!
    var nowPlaying: NowPlayingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black

        let menu = MenuPageViewController()
        rootNavController = UINavigationController(rootViewController: menu)
        rootNavController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        rootNavController.navigationBar.shadowImage = UIImage()
        rootNavController.navigationBar.isTranslucent = true
        view.addSubview(rootNavController.view)
        addChildViewController(rootNavController)
        view.addConstraints(preferredConstraints())
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - NowPlayingActionDelegate
    
    func didTapShow(_ show: Show?) {
        //slider.updatePosition(.closed, animated: true)
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
        let view = rootNavController.view!
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(tabSpace)-[nav]-(tabSpace)-|", options: [], metrics: metrics, views: ["nav": view])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[nav]|", options: [], metrics: nil, views: ["nav": rootNavController.view])
        
        return constraints
    }
}
