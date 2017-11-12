//
//  DJPopupViewController.swift
//  UCLA Radio
//
//  Created by Brian Sakhuja on 11/2/17.
//  Copyright © 2017 UCLA Student Media. All rights reserved.
//
import UIKit
import Presentr
import SDWebImage

// Constants
let djNameFontSize: CGFloat = 25
let djRealNameFontSize: CGFloat = 15
let djBioFontSize: CGFloat = 15
let imageWidth: CGFloat = 150

class DJPopupViewController: UIViewController, UITextViewDelegate {
    var djNameString: String = ""
    var djNameTextView = UITextView()
    var djRealNameString: String = ""
    var djRealNameTextView = UITextView()
    var djBioString: String = ""
    var djBioTextView = UITextView()
    var djImageView = UIImageView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = djImageView.image
        djImageView.image = resizeImage(image: (image?.circleMasked!)!, newWidth: imageWidth)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.lightPink
        
        // MARK: - Image creation
        djImageView.contentMode = .scaleAspectFit
        djImageView.clipsToBounds = true
        djImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(djImageView)
        
        // MARK: - Text creation
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
        let viewsDict = ["djImageView": djImageView,
                         "djNameTextView": djNameTextView,
                         "djRealNameTextView": djRealNameTextView,
                         "djBioTextView": djBioTextView] as [String : Any]
        var viewConstraints = [NSLayoutConstraint]()
        
        // Add both vertical and horizontal constraints for djNameTextView, djRealNameTextView, and djBioTextView
        // Vertical constraints for everything
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat:"V:|-20-[djImageView]-0-[djNameTextView]-0-[djRealNameTextView]-0-[djBioTextView]-20-|",
            options: [],
            metrics: nil,
            views: viewsDict)
        viewConstraints += verticalConstraints
        
        // Horizontal dj image constraints
        let djImageViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-20-[djImageView]-20-|",
            options: [],
            metrics: nil,
            views: viewsDict)
        viewConstraints += djImageViewHorizontalConstraints
        
        // Horizontal dj name constraints
        let djNameTextViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-20-[djNameTextView]-20-|",
            options: [],
            metrics: nil,
            views: viewsDict)
        viewConstraints += djNameTextViewHorizontalConstraints
        
        // Horizontal real dj name constraints
        let djRealNameTextViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-20-[djRealNameTextView]-20-|",
            options: [],
            metrics: nil,
            views: viewsDict)
        viewConstraints += djRealNameTextViewHorizontalConstraints
        
        // Horizontal bio constraints
        let djBioTextViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[djBioTextView]-20-|",
            options: [],
            metrics: nil,
            views: viewsDict)
        viewConstraints += djBioTextViewHorizontalConstraints
        
        NSLayoutConstraint.activate(viewConstraints)
        
    }
    
    // Start at top of scroll
    override func viewDidLayoutSubviews() {
        self.djBioTextView.setContentOffset(.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0)
        
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resizeToScreenSize(image: UIImage) -> UIImage {
        let screenSize = self.view.bounds.size
        return resizeImage(image: image, newWidth: screenSize.width)
    }
}

extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
