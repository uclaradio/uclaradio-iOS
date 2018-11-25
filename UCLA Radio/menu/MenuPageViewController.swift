//
//  MenuPageViewController.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 11/7/18.
//  Copyright © 2018 UCLA Student Media. All rights reserved.
//
import Foundation
import UIKit

class MenuPageViewController: UIPageViewController {
    
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
        
        dataSource = self
        
        //set background image
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController as! UIViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
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

