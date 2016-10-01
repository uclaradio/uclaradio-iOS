//
//  DJListViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit
import KRLCollectionViewGridLayout

private let reuseIdentifier = "DJCell"
private let sectionInset: CGFloat = 25
private let itemSpacing: CGFloat = 15

class DJListViewController: UIViewController, APIFetchDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static let storyboardID = "djListViewController"
    
    var djList: [DJ] = []
    
    var collectionView: UICollectionView!
    
    var layout: KRLCollectionViewGridLayout {
        return self.collectionView?.collectionViewLayout as! KRLCollectionViewGridLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: KRLCollectionViewGridLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(DJCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        
        layout.numberOfItemsPerLine = 2
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        layout.interitemSpacing = itemSpacing
        layout.lineSpacing = itemSpacing
        
        collectionView?.backgroundColor = UIColor.clearColor()
        
        view.addConstraints(preferredConstraints())
        
        view.backgroundColor = Constants.Colors.lightPink
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RadioAPI.fetchDJList(self)
    }
    
    func styleFromDJs(djs: [DJ]) {
        djList = djs
        collectionView.reloadData()
    }
    
    
    // MARK: - APIFetchDelegate
    
    func cachedDataAvailable(data: AnyObject) {
        if let djs = data as? [DJ] {
            styleFromDJs(djs)
        }
    }
    
    func didFetchData(data: AnyObject) {
        if let djs = data as? [DJ] {
            styleFromDJs(djs)
        }
    }
    
    func failedToFetchData(error: String) {
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return djList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let dj = djList[indexPath.row]
        if let djCell = cell as? DJCollectionViewCell {
            djCell.styleFromDJ(dj)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let dj = djList[indexPath.row]
        print("tapped dj: \(dj.username)")
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? DJCollectionViewCell {
            cell.animateSelect()
        }
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[list]|", options: [], metrics: nil, views: ["list": collectionView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[list]|", options: [], metrics: nil, views: ["list": collectionView])
        return constraints
    }
    
}
