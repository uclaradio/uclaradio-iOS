//
//  BaseViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 10/2/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        if let navigationController = navigationController {
//            navigationController.navigationBar.barTintColor = UIColor(hex: 0x80333333)
//        }
        
        //make the background of any BaseViewController transparent
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
    }

}

class BaseTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = Constants.Colors.lightPink
//        if let navigationController = navigationController {
//            navigationController.navigationBar.barTintColor = Constants.Colors.darkBackground
//        }
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }
    }
}
