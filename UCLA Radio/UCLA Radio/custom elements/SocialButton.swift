//
//  SocialButton.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 6/2/17.
//  Copyright © 2017 UCLA Student Media. All rights reserved.
//

enum Socials: String {
    case facebook   = "https://www.facebook.com/UCLARadio"
    case twitter    = "https://twitter.com/UCLAradio"
    case instagram  = "https://www.instagram.com/uclaradio/"
    case snapchat   = "https://www.snapchat.com/add/uclaradio"
}

class SocialButton: UIButton {

    let url: URL?
    let deepURL: URL?

    func setURL(s: Socials) {
        switch String {
        case .facebook:
        
        case .twitter:
            
        case .instagram:
            
        case .snapchat:
            
        default:
            <#code#>
        }
    }

    func link() {
        if (deepURL != nil) {
            return
        }

        if UIApplication.shared.canOpenURL(deepURL!) {
            UIApplication.shared.openURL(deepURL!)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }

}
