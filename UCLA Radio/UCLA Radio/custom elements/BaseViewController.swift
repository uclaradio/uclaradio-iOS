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

        view.backgroundColor = Constants.Colors.lightPink
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = Constants.Colors.darkPink
        }
    }

}

class BaseTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.lightPink
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = Constants.Colors.darkPink
        }
    }
}
