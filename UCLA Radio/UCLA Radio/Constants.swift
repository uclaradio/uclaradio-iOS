//
//  Constants.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/10/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Colors {
        static let darkBlue = UIColor(hex: 0x3284bf)
        static let lightBlue = UIColor(hex: 0x93d3eb)
        static let gold = UIColor(hex: 0xffd970)
        static let darkPink = UIColor(hex: 0xfa9fb5)
        static let lightPink = UIColor(hex: 0xfde0dd)
        static let reallyDarkPink = UIColor(hex: 0xc51b8a)
        static let lightBackground = UIColor.whiteColor().colorWithAlphaComponent(0.85)
        static let lightBackgroundHighlighted = UIColor.whiteColor()
        static let darkBackground = UIColor.blackColor().colorWithAlphaComponent(0.85)
    }
    
    struct Fonts {
        static let title = "Typo Round Regular Demo"
        static let titleBold = "Typo Round Bold Demo"
    }
    
    struct Floats {
        static let containerOffset: CGFloat = 8
        static let menuOffset: CGFloat = 15
    }
}
