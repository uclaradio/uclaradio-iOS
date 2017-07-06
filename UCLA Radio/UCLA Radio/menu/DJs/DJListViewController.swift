//
//  DJListViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit
import KRLCollectionViewGridLayout

private let reuseIdentifier = "DJCell"
private let sectionInset: CGFloat = 8
private let itemSpacing: CGFloat = 8

class DJListViewController: BaseViewController, APIFetchDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static let storyboardID = "djListViewController"
    
    var djList: [DJ] = []
    
    var collectionView: UICollectionView!
    
    var layout: KRLCollectionViewGridLayout {
        return self.collectionView?.collectionViewLayout as! KRLCollectionViewGridLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: KRLCollectionViewGridLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(DJCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        
        layout.numberOfItemsPerLine = 2
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        layout.interitemSpacing = itemSpacing
        layout.lineSpacing = itemSpacing
        
        collectionView?.backgroundColor = UIColor.clear
        
        view.addConstraints(preferredConstraints())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RadioAPI.fetchDJList(self)
        //AnalyticsManager.sharedInstance.trackPageWithValue("DJs")
    }
    
    func styleFromDJs(_ djs: [DJ]) {
        djList = djs
        collectionView.reloadData()
    }
    
    
    // MARK: - APIFetchDelegate
    
    func cachedDataAvailable(_ data: Any) {
        if let djs = data as? [DJ] {
            styleFromDJs(djs)
        }
    }
    
    func didFetchData(_ data: Any) {
        if let djs = data as? [DJ] {
            styleFromDJs(djs)
        }
    }
    
    func failedToFetchData(_ error: String) {
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return djList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dj = djList[(indexPath as NSIndexPath).row]
        if let djCell = cell as? DJCollectionViewCell {
            djCell.styleFromDJ(dj)
        }
    }
    
    // MARK: - Layout
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[list]|", options: [], metrics: nil, views: ["list": collectionView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[list]|", options: [], metrics: nil, views: ["list": collectionView])
        return constraints
    }
    
}
