//
//  MenuCollectionViewCell.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(preferredConstraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleForMenuItem(item: MenuItem) {
        imageView.image = UIImage(named: item.image)
    }
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints:[NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[image]|", options: [], metrics: nil, views: ["image": imageView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[image]|", options: [], metrics: nil, views: ["image": imageView])
        return constraints
    }
    
}
