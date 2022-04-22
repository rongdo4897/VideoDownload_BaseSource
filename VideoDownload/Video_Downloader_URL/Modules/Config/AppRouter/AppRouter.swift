//
//  AppRouter.swift
//  AddContact
//
//  Created by Huong Nguyen on 3/3/21.
//

import UIKit

enum RouterType {
    case tabbar
    case home
    case download
    case login
}

class AppRouter {
    class func routerTo(from vc: UIViewController, router: RouterType) {
        DispatchQueue.main.async {
            vc.navigationController?.pushViewController(router.getVc(), animated: true)
        }
    }
    
//    class func setRootView() {
//        if let window = UIApplication.shared.keyWindow {
//            window.rootViewController = nil
//            let navigationController = UINavigationController(rootViewController: RouterType.overview.getVc())
//            navigationController.isNavigationBarHidden = true
//            window.rootViewController = navigationController
//            let options: UIView.AnimationOptions = .transitionCrossDissolve
//            let duration: TimeInterval = 0.3
//            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: { _ in
//                                })
//            window.makeKeyAndVisible()
//        }
//    }
}

extension RouterType {
    func getVc() -> UIViewController {
        switch self {
        case .tabbar:
            let vc = UIStoryboard(name: Constants.tabbar, bundle: nil).instantiateViewController(ofType: TabbarViewController.self)
            return vc
        case .home:
            let vc = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(ofType: HomeViewController.self)
            return vc
        case .download:
            let vc = UIStoryboard(name: Constants.download, bundle: nil).instantiateViewController(ofType: DownloadViewController.self)
            return vc
        case .login:
            let vc = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(ofType: LoginViewController.self)
            return vc
        }
    }
}
