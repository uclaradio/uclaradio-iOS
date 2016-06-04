//
//  DJListViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class DJListViewController: UIViewController, APIFetchDelegate {
    
    var djList: [DJ] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blueColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RadioAPI.fetchDJList(self)
    }
    
    func styleFromDJs(djs: [DJ]) {
        print("got djs:")
        for dj in djs {
            print("* \(dj.username)")
        }
        djList = djs
    }
    
    
    // MARK: - APIFetchDelegate
    
    func cachedDataAvailable(data: AnyObject) {
        if let djs = data as? [DJ] {
            styleFromDJs(djs)
        }
    }
    
    func didFetchData(data: AnyObject) {
        if let djs = data as? [DJ] {
            styleFromDJs(djs)
        }
    }
    
    func failedToFetchData(error: String) {
        
    }
    
}
