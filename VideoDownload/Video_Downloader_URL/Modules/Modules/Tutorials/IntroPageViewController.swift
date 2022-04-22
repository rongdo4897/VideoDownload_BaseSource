//
//  IntroPageViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 22/04/2021.
//

import UIKit

protocol IntroPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class IntroPageViewController: UIPageViewController {

    weak var introDelegate: IntroPageViewControllerDelegate?

    var headings = [IntroConstant.plan, IntroConstant.travel, IntroConstant.share]
    var subTitles = [IntroConstant.planMess, IntroConstant.travelMess, IntroConstant.shareMess]
    var images = ["img_plan", "img_travel", "img_share"]

    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let startingVc = contentViewController(at: 0) {
            setViewControllers([startingVc], direction: .forward, animated: true, completion: nil)
        }
    }

    func contentViewController(at index: Int) -> IntroContentViewController? {
        if index < 0 || index >= headings.count {
            return nil
        }
        if let vc = RouterType.introContent.getVc() as? IntroContentViewController {
            vc.heading = headings[index]
            vc.subTitle = subTitles[index]
            vc.image = images[index]
            vc.index = index
            vc.numberOfPage = headings.count
            return vc
        }
        return nil
    }

    func forwardPage() {
        currentIndex += 1
        if let nextVc = contentViewController(at: currentIndex) {
            setViewControllers([nextVc], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension IntroPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = ((viewController as? IntroContentViewController)?.index) ?? 0
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = ((viewController as? IntroContentViewController)?.index) ?? 0
        index += 1
        
        return contentViewController(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewcontroller = pageViewController.viewControllers?.first as? IntroContentViewController {
                currentIndex = contentViewcontroller.index
                introDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
}
