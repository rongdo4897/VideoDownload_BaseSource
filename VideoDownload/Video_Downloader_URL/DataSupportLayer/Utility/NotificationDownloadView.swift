//
//  YTBNotificationDownloadView.swift
//  Youtube_WatchAndDownload
//
//  Created by Hoang Lam on 27/09/2021.
//

import Foundation
import UIKit

/// 1 View hiển thị thông báo bắt đầu download
class NotificationDownloadView: UIView {
    private let label: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Avenir-Light", size: 18)
        return label
    }()
    
    convenience init(text: String, bgColor: UIColor = .darkGray, textColor: UIColor = .white) {
        self.init()
        self.frame = frame
        backgroundColor = bgColor
        alpha = 0
        let screenFrame = UIScreen.main.bounds
        layer.cornerRadius = 10
        // layout cho ra giữa màn hình
        frame.size = CGSize(width: screenFrame.width * 0.5, height: screenFrame.height * 0.2)
        frame.origin = CGPoint(x: screenFrame.width * 0.25, y: screenFrame.height * 0.4)
        
        label.text = text
        label.textColor = textColor
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(label)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // Hiện lên superview
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        } completion: { _ in
            self.perform(#selector(self.fadeOut), with: nil, afterDelay: 1)
        }
    }
    
    @objc private func fadeOut() {
        // xóa khỏi superview
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
            self.frame.origin.y = UIScreen.main.bounds.height
        } completion: { _ in
            self.removeFromSuperview()
        }

    }
}
