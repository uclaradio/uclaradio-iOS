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
    
    var slider: SlidingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider = SlidingViewController()
        view.addSubview(slider.view)
        addChildViewController(slider)
        view.addConstraints(slider.preferredConstraints())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
