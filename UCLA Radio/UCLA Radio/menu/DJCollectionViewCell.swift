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
    
    let ImageChangeContext:UnsafeMutableRawPointer? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.addObserver(self, forKeyPath: "bounds", options: .new, context: ImageChangeContext)
        
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: textFontSize)
        nameLabel.textAlignment = .center
        
        contentView.addConstraints(preferredConstraints())
    }
    
    deinit {
        imageView.layer.removeObserver(self, forKeyPath: "bounds", context: ImageChangeContext)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleFromDJ(_ dj: DJ) {
        imageView.image = placeholder
        imageView.sd_cancelCurrentImageLoad()

        nameLabel.text = dj.djName ?? dj.fullName ?? dj.username
        
        if let picture = dj.picture {
            imageView.sd_setImage(with: RadioAPI.absoluteURL(picture), placeholderImage: placeholder)
        }
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(15)-[image]-[name(label)]-|", options: [], metrics: ["label": labelHeight], views: ["image": imageView, "name": nameLabel])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]-|", options: [], metrics: nil, views: ["image": imageView, "name": nameLabel])
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        return constraints
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == ImageChangeContext) {
            imageView.layer.cornerRadius = imageView.frame.size.height/2.0
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}
