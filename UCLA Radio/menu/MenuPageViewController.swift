//
//  MenuPageViewController.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 11/7/18.
//  Copyright © 2018 UCLA Student Media. All rights reserved.
//
import Foundation
import UIKit

class MenuPageViewController: /* UICollectionViewController, UICollectionViewDelegateFlowLayout */ UIPageViewController, UIScrollViewDelegate {
    
    var navImage: UIImageView!
    let cellId = "cellId"
    
    private lazy var orderedViewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        viewControllers.append(getViewControllerFromID(ID: "nowPlaying"))
        viewControllers.append(getViewControllerFromID(ID: "scheduleViewController"))
        viewControllers.append(getViewControllerFromID(ID: "djListViewController"))
        viewControllers.append(getViewControllerFromID(ID: "eventsViewController"))
        viewControllers.append(getViewControllerFromID(ID: "aboutViewController"))

        return viewControllers
    }()
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuBar()
        setupBackground()
        setupCustomNavImage()

        
        dataSource = self
        
        for v in self.view.subviews{
            if v is UIScrollView {
                print("joseph clegg")
                (v as! UIScrollView).delegate = self
            }
        }

        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
    }
    
    // SCROLL VIEW DELEGATE METHOD
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 8
    }
    
    private func setupBackground() {
        //set background image
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
    }
    
    private func setupCustomNavImage() {
        
        let imageName = "uclaradio_banner"
        let image = UIImage(named: imageName)
        navImage = UIImageView(image: image!)
        navImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/10)
        self.view.addSubview(navImage)
    }
    
    func scrollToMenuIndex(index: Int) {
        print("hi")
        setViewControllers([orderedViewControllers[index]], direction: .forward, animated: true, completion: nil)
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb;
    }()
    
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        
        // TODO: Add constraints. This is for any awkward gaps
//        let grayView = UIView()
//        grayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7) // transparent black header color
//        view.addSubview(grayView)
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuBar]|", options: [], metrics: nil, views: ["menuBar": menuBar])
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-89-[menuBar(50)]|", options: [], metrics: nil, views: ["menuBar": menuBar])
        view.addConstraints(horizontalConstraint)
        view.addConstraints(verticalConstraint)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0)
    }
    
    private func getViewControllerFromID(ID: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ID)
    }
    
}



extension MenuPageViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }

}

//extension MenuPageViewController:  UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset.x
//        let bounds = scrollView.bounds.width
//        let page = CGFloat(self.currentPage)
//        let count = CGFloat(orderedViewControllers.count)
//        let percentage = (offset - bounds + page * bounds) / (count * bounds - bounds)
//
//        print(abs(percentage))
//    }
//}
