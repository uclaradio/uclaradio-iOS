//
//  EventsHeaderView.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 10/2/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import UIKit

class EventsHeaderView: UITableViewHeaderFooterView {

    let label = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(preferredContraints())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style(month: String) {
        label.text = month.capitalized
    }
    
    // MARK: - Layout
    
    static func preferredHeight() -> CGFloat {
        return 50.0
    }
    
    private func preferredContraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[label]|", options: [], metrics: nil, views: ["label": label])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label": label])
        
        return constraints
    }

}
