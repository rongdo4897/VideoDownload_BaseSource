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
        super.viewDidLoad()
    }
    
    func createTabbar() {
        let home = RouterType.home.getVc()
        let plan = RouterType.plan.getVc()
        let profile = RouterType.profile.getVc()

        let homeItem = UITabBarItem(title: Constants.homeTab, image: #imageLiteral(resourceName: "ic_home"), tag: 0)
        let planItem = UITabBarItem(title: Constants.planTab, image: #imageLiteral(resourceName: "ic_plan"), tag: 1)
        let profileItem = UITabBarItem(title: Constants.profileTab, image: #imageLiteral(resourceName: "ic_profile"), tag: 2)

        home.tabBarItem = homeItem
        plan.tabBarItem = planItem
        profile.tabBarItem = profileItem

        self.viewControllers = [home, plan, profile]
    }
}
