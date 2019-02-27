//
//  MenuBar.swift
//  UCLA Radio
//
//  Created by Haejin Jo on 1/21/19.
//  Copyright © 2019 UCLA Student Media. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var menuPageViewController: MenuPageViewController?
    
    // DEFINE collectionView OBJECT
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7) // transparent black header color for menubar (not including cells)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let buttonTitles = ["STREAM", "SHOWS", "DJs", "ABOUT"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: [], metrics: nil, views: ["v0":collectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: nil, views: ["v0":collectionView]))
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .init(rawValue: 0))
//        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        setupHorizontalBar()
    }
    
    var leftInset = 0 as CGFloat
    
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    // SETUP LITTLE BAR THAT SLIDES DEPENDING ON VIEWCONTROLLER
    func setupHorizontalBar() {
        
        let horizontalBarView = UIView()
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let frameWidth = collectionView.frame.width
        let totalCellWidth = CGFloat(4) * (collectionView.frame.width / CGFloat(8))
        leftInset = (frameWidth - totalCellWidth) / CGFloat(2)
        print(leftInset)
        
        addSubview(horizontalBarView)  // can do here because this entire MenuBar class is a UIView itself
        
        print("sup baby")
        print("frame.width in setuphorizontal bar is \(frameWidth)")
        
        //need x,y,width,andheight constraints

        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/8).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        horizontalBarLeftAnchorConstraint =  horizontalBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leftInset)
        horizontalBarLeftAnchorConstraint?.isActive = true
    }
    
    
    // CLICKED A TAB CATEGORY 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        let x = CGFloat(indexPath.item) * frame.width / 8 + leftInset
        
        horizontalBarLeftAnchorConstraint?.constant = x
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {self.layoutIfNeeded()}, completion: nil)
        
        menuPageViewController?.scrollToMenuIndex(index: indexPath.item)
    }
    
    // Specifying total number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    // Positioning the entire cell group from parent
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 4 * (frame.width / 8) // get width of 4 cells
        let leftInset = (frame.width - totalCellWidth) / 2 // remove length of 4 cells, divide in half to fill the leading/trailing spaces --> center the cells
        let rightInset = leftInset
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
    
    // Cell configuration from parent
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7) // transparent black header color
        cell.textView.text = buttonTitles[indexPath.item]
        return cell
    }
    
    // Size of a "button"/cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 8, height: frame.height)
    }
    
    // Spacing between each cell reduced to absolute zero, to avoid scrolling collection view in menubar
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            textView.textColor = isHighlighted ? UIColor.white : UIColor(red: 220, green: 213, blue: 210)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            textView.textColor = isSelected ? UIColor.white : UIColor(red: 220, green: 213, blue: 210)
        }
    }
    
    let textView: UILabel = {
        let tv = UILabel()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.adjustsFontSizeToFitWidth = true
//        tv.minimumScaleFactor = 0.2
        tv.textColor = UIColor(red: 220, green: 213, blue: 210) // inactive text color
//        tv.layer.borderWidth = 1
        tv.numberOfLines = 0
        tv.baselineAdjustment = .alignCenters
        tv.textAlignment = .center
        tv.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)
//        tv.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7) // transparent black header color
        return tv
    }()
    
    func setupViews() {
        
        addSubview(textView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .alignAllCenterX, metrics: nil, views: ["v0":textView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .alignAllCenterY, metrics: nil, views: ["v0":textView]))
        
//        addConstraint(NSLayoutConstraint(item: textView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
//        addConstraint(NSLayoutConstraint(item: textView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
