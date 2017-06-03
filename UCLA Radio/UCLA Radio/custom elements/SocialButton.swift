//
//  SocialButton.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 6/2/17.
//  Copyright © 2017 UCLA Student Media. All rights reserved.
//

enum Socials: String {
    case fb = "https://www.facebook.com/UCLARadio"
    case ig =

}

class SocialButton: UIButton {

    let url: URL?
    let deepURL: URL?

    func setURL(s: Socials) {
        switch String {
        case .fb:
            <#code#>
        case .ig:
            
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
