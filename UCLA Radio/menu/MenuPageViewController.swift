//
//  MenuPageViewController.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 11/7/18.
//  Copyright © 2018 UCLA Student Media. All rights reserved.
//
import Foundation
import UIKit

var menuBar: MenuBar = {
    let mb: MenuBar = MenuBar()
    mb.translatesAutoresizingMaskIntoConstraints = false
    return mb;
}()

class MenuPageViewController: UIPageViewController {
    
/* SCROLLVIEWDELEGARTE IMPLEMENTATION
    var lastContentOffset: CGPoint?
*/
    let cellId = "cellId"
    var bannerBackgroundView: UIImageView!
    var currentIndex = 0

    private func getViewControllerFromID(ID: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ID)
    }
    
    private lazy var orderedViewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        viewControllers.append(getViewControllerFromID(ID: "nowPlaying"))
        viewControllers.append(getViewControllerFromID(ID: "scheduleViewController"))
        viewControllers.append(getViewControllerFromID(ID: "djListViewController"))
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
        
        setupBackground()
        setupCustomNav()
        menuBar.delegate = self
        delegate = self
        dataSource = self

/* WHEN I WAS CONFORMING TO UISCROLLVIEWDELEGATE
//        for v in self.view.subviews.reversed() {
//            if v.isKind(of: UIScrollView.self) {
//                print("found scrollview in ", v)
//                (v as! UIScrollView).delegate = self
//            }
//        }
*/
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
    
    private func setupCustomNav() {
        bannerBackgroundView = UIImageView()
        view.addSubview(bannerBackgroundView)
        bannerBackgroundView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        bannerBackgroundView.frame =  CGRect(x: 0, y: 0, width: view.frame.width, height: 89)

        setupMenuBar()
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuBar]|", options: [], metrics: nil, views: ["menuBar": menuBar])
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(89)-[menuBar(30)]", options: [], metrics: nil, views: ["menuBar": menuBar])
        view.addConstraints(horizontalConstraint)
        view.addConstraints(verticalConstraint)
    }
    

    
    private func setupBackground() {
        //set background image
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
    }
    
}

extension MenuPageViewController: UIPageViewControllerDataSource {
    
    // SPITS BACK VC BEFORE THE CURRENT VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            print("Invalid index for view controllers array")
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

    // SPITS BACK VC AFTER THE CURRENT VC
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

/*
 will look ok where you swipe, but bar only moves after release of the swipe
 instead of conforming to any scroll view delegate stuff, just remove that
 Instead just conform to UIPageViewControllerDelegate
 
 might need to create a new var to manually keep track of current index,
 or check on google if there's a way to get current index of a VC in a PageViewController
 */

extension MenuPageViewController: UIPageViewControllerDelegate {
    
    // CALLED *BEFORE* A GESTURE-DRIVEN TRANSITION BEGINS
    // If the user aborts the navigation gesture, the transition doesn’t complete and the view controllers stay the same.
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextViewController = pendingViewControllers[0] as? UIViewController else { return }
        
        self.currentIndex = orderedViewControllers.index(of: nextViewController)!
        // get a reference to the index that we will transition to
    }
    
    // CALLED *BEFORE* A GESTURE-DRIVEN TRANSITION BEGINS
    // will tell you when to update current_page variable
    // last arg, transitionCompleted, can tell you wehther a usser completed a page turn transition
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
                let index = orderedViewControllers.index(of: currentViewController) {
                currentIndex = index
                menuBar.horizontalBarLeftAnchorConstraint?.constant = (menuBar.frame.width / 4) * CGFloat(currentIndex)
            }
        }
        //  set correct index
    }
}

// Allows direct clicking on Menu items to slide the horizontal bar accordingly
extension MenuPageViewController: MenuBarDelegate {
    
    func scrollToMenuIndex(index: Int) {
        setViewControllers([orderedViewControllers[index]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
}


// PUT THIS AWAY FOR NOW
//extension UIPageViewController: UIScrollViewDelegate {
////    open override func viewDidLoad() {
////        super.viewDidLoad()
////        print(view.subviews)
////        for subview in view.subviews {
////            print("subview found ", subview)
////            if let scrollView = subview as? UIScrollView {
////                scrollView.delegate = self
////                print("scrollview found")
////            }
////        }
////    }
//
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let point = scrollView.contentOffset.x
////        print(point)
//        menuBar.horizontalBarLeftAnchorConstraint?.constant = point / 4
//    }
//}


