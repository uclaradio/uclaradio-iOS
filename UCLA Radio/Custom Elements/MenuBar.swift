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
        cv.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7) // transparent black header color for menubar
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let buttonTitles = ["STREAM", "SHOWS", "DJs", "ABOUT"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.restorationIdentifier = "menubar"
        print("rest id is ", collectionView.restorationIdentifier)
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
        
        // CHANGED
//        let frameWidth = collectionView.frame.width
//        let totalCellWidth = 4 * (collectionView.frame.width / 4)
//        leftInset = (frameWidth - totalCellWidth) / CGFloat(2)
//        print("leftinset is ", leftInset)
        
        addSubview(horizontalBarView)  // can do here because this entire MenuBar class is a UIView itself
        
        print("sup baby")
//        print("frame.width in setuphorizontal bar is \(frameWidth)")
        
        //need x,y,width,andheight constraints

        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        // CHANGED
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        horizontalBarLeftAnchorConstraint =  horizontalBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
    }
    
    
    // CLICKED A TAB CATEGORY 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        // CHANGED
        let x = CGFloat(indexPath.item) * frame.width / 4
        
        horizontalBarLeftAnchorConstraint?.constant = x
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {self.layoutIfNeeded()}, completion: nil)
        
        menuPageViewController?.scrollToMenuIndex(index: indexPath.item)
    }
    
    // Specifying total number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    // Cell configuration from parent
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.backgroundColor = UIColor.clear
        cell.textView.text = buttonTitles[indexPath.item]
        return cell
    }
    
    // Size of a "button"/cell
    // CHANGED
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
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
        tv.textColor = UIColor(red: 220, green: 213, blue: 210) // inactive text color
        tv.textAlignment = .center
        tv.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)
        return tv
    }()
    
    func setupViews() {
        addSubview(textView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tv]|", options: .alignAllCenterX, metrics: nil, views: ["tv":textView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tv]|", options: .alignAllCenterY, metrics: nil, views: ["tv":textView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
