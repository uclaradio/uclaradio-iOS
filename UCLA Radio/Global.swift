//
//  Global.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/8/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
