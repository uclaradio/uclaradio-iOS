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
    var chatViewController: ChatViewController!
    var chatButton: UIButton!
    
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
        
        // Mark: - CHAT
        chatViewController = ChatViewController()
        
        let button = UIButton(frame: CGRect(x: 0, y: self.view.frame.size.height-50, width: self.view.frame.width, height: 50))
        button.backgroundColor = Constants.Colors.darkBackground
        button.backgroundColor?.withAlphaComponent(0.1)
        button.setTitle("Chat", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        
    } // END VIEWDIDLOAD
    
    // CHAT BUTTON
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        if chatViewController.viewIfLoaded?.window != nil {
            //view controller is visible
        } else {
            self.rootNavController.pushViewController(chatViewController, animated: true)
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
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
        self.view.addSubview(navImage)
    }
}

extension UINavigationBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 100.0)
    }
    
}
