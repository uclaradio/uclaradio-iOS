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
    
    var lastContentOffset: CGPoint?
    let cellId = "cellId"
    var bannerBackgroundView: UIImageView!
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupCustomNav()
        menuBar.delegate = self
        dataSource = self

        for v in self.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                print("found scrollview in ", v)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension UIPageViewController: UIScrollViewDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        print(view.subviews)
        for subview in view.subviews {
            print("subview found ", subview)
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                print("scrollview found")
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset.x
        print(point)
        menuBar.horizontalBarLeftAnchorConstraint?.constant = point / 4
    }
}

extension MenuPageViewController: MenuBarDelegate {
    
    func scrollToMenuIndex(index: Int) {
        setViewControllers([orderedViewControllers[index]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
}

