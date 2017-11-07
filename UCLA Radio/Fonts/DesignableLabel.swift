//
//  DesignableLabel.swift
//  UCLA Radio
//
//  Created by Chris on 2/15/17.
//  Copyright © 2017 UCLA Student Media. All rights reserved.
//

import UIKit

/*
 Fixes storyboard bug where custom fonts with attributed strings
 don't work correctly with UILabel

 http://stackoverflow.com/questions/25925914/attributed-string-with-custom-fonts-in-storyboard-does-not-load-correctly
 
 This class can be removed when the bold substrings problem is resolved in interface builder
 */
@IBDesignable class DesignableLabel: UILabel {

    @IBInspectable var fontSize: CGFloat = 17.0

    @IBInspectable var fontFamily: String = Constants.Fonts.title
    @IBInspectable var boldFontFamily: String = Constants.Fonts.titleBold

    // comma-separated list of substrings to add bold font to
    @IBInspectable var boldSubstrings: String = ""

    override func awakeFromNib() {
        if let attributedText = self.attributedText {
            let attrString = NSMutableAttributedString(attributedString: attributedText)
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))
            for substring in boldSubstrings.components(separatedBy: ",") {
                let boldRange = NSString(string: attrString.string).range(of: substring)
                attrString.addAttribute(NSFontAttributeName, value: UIFont(name: self.boldFontFamily, size: self.fontSize)!, range: boldRange)
            }
            self.attributedText = attrString
        }
    }
}
