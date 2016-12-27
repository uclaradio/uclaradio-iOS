//
//  ScheduleShowCellDelegate.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/27/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

protocol ScheduleShowCellDelegate {
    var addBottomPadding: Bool { get set }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?)
    func styleFromShow(_ show: Show)
    
    // MARK: - Layout
    func setHighlighted(_ highlighted: Bool, animated: Bool)
    static func preferredHeight(_ addBottomPadding: Bool) -> CGFloat
    func containerConstraints() -> [NSLayoutConstraint]
}
