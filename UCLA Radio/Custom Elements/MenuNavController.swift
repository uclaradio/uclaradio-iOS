////
////  MenuNavController.swift
////  UCLA Radio
////
////  Created by Joseph Clegg on 11/27/18.
////  Copyright © 2018 UCLA Student Media. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class MenuNavController: UINavigationController {
//    
//    var headers: [String] = ["STREAM", "SHOWS", "DJs", "TICKETS", "ABOUT"]
//    
//    var segmentedControl: UISegmentedControl!
//
//    override init(rootViewController: UIViewController) {
//        super.init(rootViewController: rootViewController)
//
//        segmentedControl = UISegmentedControl(items: headers)
//        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.frame = CGRect(x: 0, y: 50, width: rootViewController.view.frame.width, height: 50)
//        segmentedControl.layer.cornerRadius = 5.0
//        segmentedControl.backgroundColor = UIColor.clear
//        segmentedControl.layer.borderWidth = 0
//        segmentedControl.tintColor = UIColor.white
//
//        self.view.addSubview(segmentedControl)
//
//        self.didMove(toParentViewController: self)
//        self.view.translatesAutoresizingMaskIntoConstraints = false
//        self.view.backgroundColor = Constants.Colors.darkBackground
//        self.navigationBar.barTintColor = UIColor(hex: 0x80333333)
//        // back button color
//        self.navigationBar.tintColor = UIColor.white
//        // title color
//        if let titleFont = UIFont(name: Constants.Fonts.title, size: 21) {
//            self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: titleFont]
//        }
//
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let height: CGFloat = 10 //whatever height you want to add to the existing height
//        let bounds = self.navigationBar.bounds
//        self.navigationBar.frame = CGRect(x: 0, y: 50, width: bounds.width, height: bounds.height+100)
//        //self.view.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 150)
//        //self.view.backgroundColor = Constants.Colors.darkPink
//        //self.navigationBar.barTintColor = UIColor.clear
//        //self.navigationBar.backgroundColor = UIColor.clear
//        self.navigationBar.barTintColor = UIColor(hex: 0x80333333)
//        self.navigationBar.backgroundColor = UIColor(hex: 0x80333333)
//        //print(self.navigationBar.frame.height)
//
//    }
//    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//
