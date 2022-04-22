//
//  AppDelegate.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 06/10/2021.
//

import UIKit
import IQKeyboardManagerSwift
import AVKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initRootRouter()
        initIQKeyboard()
        initAVAudioSession()
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        HomeViewController.share.backgroundCompletionHandler = completionHandler
    }
    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        if let avVc = application.avPlayerViewController() {
//            avVc.toggleVideoOnAllTracks(false)
//        }
//    }

//    func applicationWillEnterForeground(_ application: UIApplication) {
//        if let avVc = application.avPlayerViewController() {
//            avVc.toggleVideoOnAllTracks(true)
//        }
//    }
//
//    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
//        return true
//    }
//
//    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
//        return true
//    }
//    
//    func applicationWillResignActive(_ application: UIApplication) {
//        if let avVc = application.avPlayerViewController() {
//            avVc.toggleVideoOnAllTracks(false)
//        }
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        if let avVc = application.avPlayerViewController() {
//            avVc.toggleVideoOnAllTracks(true)
//        }
//    }
}

extension AppDelegate {
    private func initRootRouter() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tabbar = RouterType.tabbar.getVc()
        let nav = UINavigationController(rootViewController: tabbar)
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
    }
    
    private func initIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }
    
    private func initAVAudioSession() {
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        try! AVAudioSession.sharedInstance().setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
}

fileprivate extension UIApplication {
    func hasAVPlayerViewControllerPresented() -> Bool {
        return keyWindow != nil
            && keyWindow!.rootViewController != nil
            && keyWindow!.rootViewController is UINavigationController
            && (keyWindow!.rootViewController as! UINavigationController).viewControllers.first is UITabBarController
            && ((keyWindow!.rootViewController as! UINavigationController).viewControllers.first as! UITabBarController).presentedViewController != nil
            && ((keyWindow!.rootViewController as! UINavigationController).viewControllers.first as! UITabBarController).presentedViewController is AVPlayerViewController
    }
    
    func avPlayerViewController() -> AVPlayerViewController? {
        if !hasAVPlayerViewControllerPresented() { return nil }
        return ((keyWindow!.rootViewController as! UINavigationController).viewControllers.first as! UITabBarController).presentedViewController as! AVPlayerViewController
    }
}

fileprivate extension AVPlayerViewController {
    func toggleVideoOnAllTracks(_ enabled: Bool) {
        if UIApplication.shared.avPlayerViewController()!.player == nil
            || UIApplication.shared.avPlayerViewController()!.player!.currentItem == nil { return }
        
        let tracks = UIApplication.shared.avPlayerViewController()!.player!.currentItem!.tracks
        for track in tracks {
            if ((track.assetTrack?.hasMediaCharacteristic(AVMediaCharacteristic.visual)) != nil) {
                track.isEnabled = enabled
            }
        }
    }
}
