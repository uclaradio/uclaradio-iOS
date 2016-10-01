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

let textFontSize: CGFloat = 16
let labelHeight = 18
let placeholder = UIImage(named: "bear")

class DJCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    let ImageChangeContext:UnsafeMutablePointer<()> = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = Constants.Colors.lightBackground
        
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
    }
    
    deinit {
        imageView.layer.removeObserver(self, forKeyPath: "bounds", context: ImageChangeContext)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
    }
    
    func styleFromDJ(dj: DJ) {
        nameLabel.text = ""
        imageView.image = placeholder
        imageView.sd_cancelCurrentImageLoad()
        if let name = dj.djName {
            nameLabel.text = name
        }
        
        if let picture = dj.picture {
            imageView.sd_setImageWithURL(RadioAPI.absoluteURL(picture), placeholderImage: placeholder)
        }
    }
    
    func animateSelect() {
        self.contentView.alpha = 0.5
        UIView.animateWithDuration(0.5, animations: {
            self.contentView.alpha = 1.0
        })
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
            imageView.layer.cornerRadius = imageView.frame.size.height/2.0
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
}
