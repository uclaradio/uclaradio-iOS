//
//  DJListViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//
// Displays all the DJs on a 2 x n grid (where 2 is the number of columns and n is the number of rows
// Uses KRLCollectionViewGridLayout for the grid.
// If you tap on a cell, the DJs info is displayed.
//

import Foundation
import UIKit
import KRLCollectionViewGridLayout
import Presentr

private let reuseIdentifier = "DJCell"
private let sectionInset: CGFloat = 8
private let itemSpacing: CGFloat = 8

class DJListViewController: BaseViewController, APIFetchDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    static let storyboardID = "djListViewController"
    var djList: [DJ] = []
    var collectionView: UICollectionView!
    var layout: KRLCollectionViewGridLayout {
        return self.collectionView?.collectionViewLayout as! KRLCollectionViewGridLayout
    }
    
    // This (presenter) is the popup display that display's the DJ information
    let presenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.fluid(percentage: 1.0)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: .popup)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .bottom
        return customPresenter
    }()
    
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
        AnalyticsManager.sharedInstance.trackPageWithValue("DJs")
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
    
    // MARK: - UICollectionView Functions
    // Only 1 section in the UICollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // numberOfItemsInSection.  Returns the number of DJs.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return djList.count
    }
    
    // Return the cell for the given indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
    
    // If you tap on a DJ cell, display info
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDJ = djList[(indexPath as NSIndexPath).row]
        let controller = DJPopupViewController()
        
        // Set the picture
        controller.djImageView.image = #imageLiteral(resourceName: "bearpink")
        controller.djImageView.sd_cancelCurrentImageLoad()
        if let picture = selectedDJ.picture {
            controller.djImageView.sd_setImage(with: RadioAPI.absoluteURL(picture), placeholderImage: #imageLiteral(resourceName: "bearpink"))
        }
        
        // Set the names and bio
        controller.djNameString = selectedDJ.djName!
        controller.djRealNameString = "Also known as " + selectedDJ.fullName!
        controller.djBioString = selectedDJ.biography ?? "No bio found."
        
        // Display popup
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
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
