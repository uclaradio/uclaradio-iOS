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
    
    var chatViewController: ChatViewController!
    
    var chatButton: UIButton!
    
    // Chat slider
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

        //installNowPlayingSlider()
        //view.addSubview(navImage)
        chatViewController = ChatViewController()
        
        
        if let navController = rootNavController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
        

//        installChatSlider()
    
//        to get rid of hairline
//        if let navController = rootNavController {
//            System.clearNavigationBar(forBar: navController.navigationBar)
//            navController.view.backgroundColor = .clear
//            navController.navigationBar.setValue(true, forKey: "hidesShadow")
//        }
//

        view.addConstraints(preferredConstraints())
        
        let button = UIButton(frame: CGRect(x: 0, y: self.view.frame.size.height-50, width: self.view.frame.width, height: 50))
        button.backgroundColor = Constants.Colors.darkBackground
        //button.backgroundColor = UIColor(white: 1, alpha: 0.5)
        button.backgroundColor?.withAlphaComponent(0.5)
        button.setTitle("Chat", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        //self.navigationController?.pushViewController(chatViewController, animated: false)
        //chatViewController.transitioningDelegate = chatViewController
        if chatViewController.viewIfLoaded?.window != nil {
            // viewController is visible
            
        } else {
            self.rootNavController.pushViewController(chatViewController, animated: true)
        }
    }
    
//    func installChatSlider() {
//        if slider != nil {
//            return
//        }
//        // set up slider view controller (container)
//        slider = SlidingViewController()
//        view.addSubview(slider.view)
//        addChildViewController(slider)
//        slider.didMove(toParentViewController: self)
//        view.addConstraints(slider.preferredConstraints())
//
//        // set up content (NowPlayingViewController)
//        if let nowPlaying = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nowPlaying") as? NowPlayingViewController {
//            self.nowPlaying = nowPlaying
//            nowPlaying.actionDelegate = self
//            slider.addContent(nowPlaying)
//
//            // set up slider tab (NowPlayingView)
//            let tabView = NowPlayingView(canSkipStream: false)
//            slider.addTabView(tabView)
//            tabView.backgroundColor = UIColor.black
//        }
//    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - NowPlayingActionDelegate
    
    
    
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        let metrics = ["tabSpace": NowPlayingContainerView.PreferredHeight]
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
