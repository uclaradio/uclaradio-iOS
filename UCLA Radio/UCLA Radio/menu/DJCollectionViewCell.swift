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

private let textFontSize: CGFloat = 14
private let labelHeight = 16

class DJCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFontOfSize(textFontSize)
        nameLabel.textAlignment = .Center
        
        contentView.addConstraints(preferredConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    1
    func styleFromDJ(dj: DJ) {
        if let name = dj.djName {
            nameLabel.text = name
        }
        else {
            nameLabel.text = ""
        }
        
        if let picture = dj.picture {
            imageView.sd_setImageWithURL(NSURL(string: RadioAPI.host+picture))
        }
        else {
            imageView.image = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.height/2.0
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[image]-[name(label)]-|", options: [], metrics: ["label": labelHeight], views: ["image": imageView, "name": nameLabel])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[name]-|", options: [], metrics: nil, views: ["image": imageView, "name": nameLabel])
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: imageView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        return constraints
    }
    
}
