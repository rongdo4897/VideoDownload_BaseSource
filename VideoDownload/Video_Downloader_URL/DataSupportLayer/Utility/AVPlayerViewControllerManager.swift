//
//  AVPlayerViewControllerManager.swift
//  Youtube_WatchAndDownload
//
//  Created by Hoang Lam on 27/09/2021.
//

import Foundation
import UIKit
import AVKit

//MARK: - AVPlayerViewControllerManager: Hiển thị trình phát video
class AVPlayerViewControllerManager: NSObject {
    public func blockAvPlayer() {
        UIApplication.shared.windows[0].makeKeyAndVisible()
        perform(#selector(searchForAndDismissFullScreen), with: nil, afterDelay: 0.6)
    }
    
    // Loại bỏ màn hình hiện tại khi phát video
    @objc private func searchForAndDismissFullScreen() {
        if UIApplication.shared.windows.count < 2 {return}
        
        for subView in UIApplication.shared.windows[1].subviews {
            subView.searchForAndTapFullScreen()
        }
    }
}

//MARK: - AVPlayerViewControllerManager: Button
extension AVPlayerViewControllerManager {
    public class func getBackButton(_ playerViewController: AVPlayerViewController) -> UIButton {
        if let button = playerViewController.view.getBackButton() {
            return button
        }
        return UIButton()
    }
    
    public class func getForwardButton(_ playerViewController: AVPlayerViewController) -> UIButton {
        if let button = playerViewController.view.getForwardButton() {
            return button
        }
        return UIButton()
    }
}

//MARK: - UIView extension
fileprivate extension UIView {
    func searchForAndTapFullScreen() {
        for subview in subviews {
            if String(describing: subview).contains("AVButton") {
                (subview as! UIButton).sendActions(for: .touchUpInside)
            }
            subview.searchForAndTapFullScreen()
        }
    }
    
    func getBackButton() -> UIButton? {
        for subview in subviews {
            if String(describing: subview).contains("AVForceButton") {
                return subview as? UIButton
            }
            if let button = subview.getBackButton() {
                return button
            }
        }
        return nil
    }
    
    func getForwardButton() -> UIButton? {
        for subview in subviews {
            if String(describing: subview).contains("AVForceButton") &&
                subview.x > UIScreen.main.bounds.width * 0.5 {
                return subview as? UIButton
            }
            if let button = subview.getForwardButton() {
                return button
            }
        }
        return nil
    }
}
