//
//  DJCollectionViewCell.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

private let textFontSize: CGFloat = 16
private let labelHeight = 18

class DJCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    let ImageChangeContext:UnsafeMutablePointer<()> = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = Constants.Colors.gold.colorWithAlphaComponent(0.8)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.addObserver(self, forKeyPath: "bounds", options: .New, context: ImageChangeContext)
        
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFontOfSize(textFontSize)
        nameLabel.textAlignment = .Center
        
        contentView.addConstraints(preferredConstraints())
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
    
    deinit {
        imageView.layer.removeObserver(self, forKeyPath: "bounds", context: ImageChangeContext)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromDJ(dj: DJ) {
        if let name = dj.djName {
            nameLabel.text = name
        }
        else {
            nameLabel.text = ""
        }
        
        let placeholder = UIImage(named: "bear")
        if let picture = dj.picture {
            imageView.sd_setImageWithURL(RadioAPI.absoluteURL(picture), placeholderImage: placeholder)
        }
        else {
            imageView.image = placeholder
        }
    }
    
    func animateSelect() {
//        UIView.animateWithDuration(0.5, animations: { 
            self.contentView.alpha = 0.5
//            }) { (complete) in
//                if (complete) {
                    UIView.animateWithDuration(0.5, animations: {
                        self.contentView.alpha = 1.0
                    })
//                }
//        }
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(15)-[image]-[name(label)]-|", options: [], metrics: ["label": labelHeight], views: ["image": imageView, "name": nameLabel])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[name]-|", options: [], metrics: nil, views: ["image": imageView, "name": nameLabel])
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: imageView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        return constraints
    }
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (context == ImageChangeContext) {
//            print("image changed: \(imageView.frame)")
            imageView.layer.cornerRadius = imageView.frame.size.height/2.0
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
}
