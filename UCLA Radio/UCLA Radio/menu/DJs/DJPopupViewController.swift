//
//  DJPopupViewController.swift
//  UCLA Radio
//
//  Created by Brian Sakhuja on 11/2/17.
//  Copyright © 2017 UCLA Student Media. All rights reserved.
//

import UIKit
import Presentr

// Font size constants
let djNameFontSize: CGFloat = 25
let djRealNameFontSize: CGFloat = 15
let djBioFontSize: CGFloat = 15

class DJPopupViewController: UIViewController, UITextViewDelegate {
    var djNameString: String = ""
    var djNameTextView = UITextView()
    var djRealNameString: String = ""
    var djRealNameTextView = UITextView()
    var djBioString: String = ""
    var djBioTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.lightPink
        
        // MARK: Text creation
        // DJ Name
        djNameTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        djNameTextView.backgroundColor = UIColor.clear
        djNameTextView.font = UIFont(name: Constants.Fonts.titleBold, size: djNameFontSize)
        djNameTextView.text = djNameString
        djNameTextView.isSelectable = false
        djNameTextView.isEditable = false
        djNameTextView.isScrollEnabled = false
        djNameTextView.sizeToFit()
        self.view.addSubview(djNameTextView)
        djNameTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // DJ Real Name
        djRealNameTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        djRealNameTextView.backgroundColor = UIColor.clear
        djRealNameTextView.font = UIFont(name: Constants.Fonts.titleLight, size: djRealNameFontSize)
        djRealNameTextView.text = djRealNameString
        djRealNameTextView.isSelectable = false
        djRealNameTextView.isEditable = false
        djRealNameTextView.isScrollEnabled = false
        djRealNameTextView.sizeToFit()
        self.view.addSubview(djRealNameTextView)
        djRealNameTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // DJ Biography
        djBioTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        djBioTextView.backgroundColor = UIColor.clear
        djBioTextView.font = UIFont(name: Constants.Fonts.titleLight, size: djBioFontSize)
        djBioTextView.text = djBioString
        djBioTextView.isSelectable = false
        djBioTextView.isEditable = false
        djBioTextView.sizeToFit()
        self.view.addSubview(djBioTextView)
        djBioTextView.translatesAutoresizingMaskIntoConstraints = false

        
        // MARK: - Constraints
        // Define the views dictionary.  Stuff in here is what we add constraints for down below
        let viewsDict = ["djNameTextView": djNameTextView,
                         "djRealNameTextView": djRealNameTextView,
                         "djBioTextView": djBioTextView]
        var viewConstraints = [NSLayoutConstraint]()
        
        // Add both vertical and horizontal constraints for djNameTextView, djRealNameTextView, and djBioTextView
        // vertical constraints for everything
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat:"V:|-20-[djNameTextView]-0-[djRealNameTextView]-0-[djBioTextView]-20-|",
            options: [],
            metrics: nil,
            views: viewsDict)
        viewConstraints += verticalConstraints
        
        // horizontal dj name constraints
        let djNameTextViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-20-[djNameTextView]-20-|",
            options: [],
            metrics: nil,
            views: viewsDict)
        viewConstraints += djNameTextViewHorizontalConstraints
        
        // horizontal real dj name constraints
        let djRealNameTextViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-20-[djRealNameTextView]-20-|",
            options: [],
            metrics: nil,
            views: viewsDict)
        viewConstraints += djRealNameTextViewHorizontalConstraints
        
        // horizontal bio constraints
        let djBioTextViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[djBioTextView]-20-|",
            options: [],
            metrics: nil,
            views: viewsDict)
        viewConstraints += djBioTextViewHorizontalConstraints
    
        NSLayoutConstraint.activate(viewConstraints)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    

}
