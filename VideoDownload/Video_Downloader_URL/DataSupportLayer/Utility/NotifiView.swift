//
//  NotifiView.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 05/01/2022.
//

import Foundation
import UIKit

enum NotifiType {
    case success
    case warning
    case warningDark
    case note
}

/// 1 View hiển thị thông báo
class NotifiView: UIView {
    private let imgDescription: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let lblTitle: UILabel! = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let lblDescription: UILabel! = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    convenience init(type: NotifiType, title: String, description: String) {
        self.init()
        self.frame = frame
        alpha = 0
        
        setupSuperView(type: type)
        setupImageView(type: type)
        setupLabel(title: title, description: description)
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
        UIView.animate(withDuration: 2.2) {
            self.alpha = 0
            self.frame.origin.y = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

extension NotifiView {
    private func setupSuperView(type: NotifiType) {
        backgroundColor = .white
        layer.borderWidth = 3
        
        switch type {
        case .success:
            layer.borderColor = UIColor.colorFromHexString(hex: "#198877").cgColor
        case .warning:
            layer.borderColor = UIColor.colorFromHexString(hex: "#D2200C").cgColor
        case .warningDark:
            layer.borderColor = UIColor.black.cgColor
        case .note:
            layer.borderColor = UIColor.colorFromHexString(hex: "#C9A60C").cgColor
        }
        
        let screenFrame = UIScreen.main.bounds
        layer.cornerRadius = 10
        
        // Layout
        frame.size = CGSize(width: screenFrame.width - 20, height: 75)
        if UIDevice.current.hasNotch {
            frame.origin = CGPoint(x: 10 , y: 45 + 30)
        } else {
            frame.origin = CGPoint(x: 10 , y: 30)
        }
    }
    
    private func setupImageView(type: NotifiType) {
        switch type {
        case .success:
            imgDescription.image = UIImage(named: "ic_check")
        case .warning:
            imgDescription.image = UIImage(named: "ic_warning")
        case .warningDark:
            imgDescription.image = UIImage(named: "ic_warningDark")
        case .note:
            imgDescription.image = UIImage(named: "ic_note")
        }
        
        self.addSubview(imgDescription)
        imgDescription.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout
        NSLayoutConstraint.activate([
            imgDescription.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imgDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imgDescription.widthAnchor.constraint(equalToConstant: 35),
            imgDescription.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupLabel(title: String, description: String) {
        lblTitle.text = title
        lblDescription.text = description
        
        self.addSubview(lblTitle)
        self.addSubview(lblDescription)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            lblTitle.leadingAnchor.constraint(equalTo: imgDescription.trailingAnchor, constant: 10),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            lblDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            lblDescription.leadingAnchor.constraint(equalTo: imgDescription.trailingAnchor, constant: 10),
            lblDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}
