//
//  WalkThroughPageViewController.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/11/28.
//

import UIKit

protocol WalkThroughPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}
class WalkThroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    weak var walkThroughDelegate: WalkThroughPageViewControllerDelegate?
    
    var pageHeadings = ["Switch to different views", "Add to favorite",
                        "Delect from favorite", "Welcome!"]
    var pageImage = ["page1.jpg", "page2.jpg", "page3.jpg", "page4.jpg"]
    var pageSubheadings = ["Use the bottom tab menu to switch to different view",
                           "In Restaurant page, swipe left to add a restaurant to favorite list",
                           "In Favorite Restaurant page, swipe left to delete a restaurant from favorite list",
                           "Enjoy your safe, hygienic, delicious meal with ChicagoFood!"
    ]
    
    var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        // create first walkthrough screen
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkThroughContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkThroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> WalkThroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(identifier: "WalkThroughContentViewController") as? WalkThroughContentViewController {
            pageContentViewController.imageFile = pageImage[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subheading = pageSubheadings[index]
            
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        return nil
    }
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // mark: page view controller delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first  as? WalkThroughPageViewController {
                currentIndex = contentViewController.index as! Int
                walkThroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
}

