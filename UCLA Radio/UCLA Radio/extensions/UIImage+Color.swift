//
//  UIImage+Color.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/9/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

/**
 Usage:
 let originalImage = UIImage(named: "cat")
 let tintedImage = originalImage.imageWithColor(UIColor(red: 0.9, green: 0.7, blue: 0.4, alpha: 1.0))
 */
extension UIImage {
    
    func imageWithColor(_ color:UIColor)->UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        // flip the image
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context?.setBlendMode(CGBlendMode.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.fill(rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    
}
