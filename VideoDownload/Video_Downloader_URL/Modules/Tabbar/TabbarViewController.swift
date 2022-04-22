//
//  TabbarViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/12/21.
//

import UIKit

class TabbarViewController: MainTabViewController {

    override func viewDidLoad() {
        createTabbar()
        setUpChildViewControllers()
        super.viewDidLoad()
    }
    
    func createTabbar() {
        let home = RouterType.home.getVc()
        let download = RouterType.download.getVc()
        
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.isNavigationBarHidden = true
        let downloadNav = UINavigationController(rootViewController: download)
        downloadNav.isNavigationBarHidden = true

        let homeItem = UITabBarItem(title: Constants.home, image: #imageLiteral(resourceName: "ic_home"), tag: 0)
        let downloadItem = UITabBarItem(title: Constants.download, image: #imageLiteral(resourceName: "ic_download"), tag: 1)

        homeNav.tabBarItem = homeItem
        downloadNav.tabBarItem = downloadItem
        
        self.viewControllers = [homeNav, downloadNav]
    }
    
    private func setUpChildViewControllers() {
        if viewControllers != nil && viewControllers!.count > 1 {
            let homeVc = (viewControllers![0] as! UINavigationController).viewControllers.first
            let downVc = (viewControllers![1] as! UINavigationController).viewControllers.first
            if homeVc is HomeViewController && downVc is DownloadViewController {
                (homeVc as! HomeViewController).delegate = downVc as! DownloadViewController
            }
        }
    }
}
