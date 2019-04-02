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

class ContainerViewController: UIViewController {
    
    // Menu
    var rootNavController: UINavigationController!
    var navImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = MenuPageViewController()
        rootNavController = UINavigationController(rootViewController: menu)
        rootNavController.navigationBar.isTranslucent = true
        rootNavController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        view.addSubview(rootNavController.view)
        addChildViewController(rootNavController)
        setupCustomNavImage()
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
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[nav]|", options: [], metrics: nil, views: ["nav": view])
        
        return constraints
    }
    
    private func setupCustomNavImage() {
        
        let img = UIImage(named: "uclaradio_banner")
        navImage = UIImageView(image: img!)
        let screenWidth = self.view.frame.width
        navImage.frame = CGRect(x: screenWidth / 3.8, y: screenWidth / 10,  width: screenWidth / 2, height: 25)
//        navImage.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        self.view.addSubview(navImage)
    }
}

extension UINavigationBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 100.0)
    }
    
}
