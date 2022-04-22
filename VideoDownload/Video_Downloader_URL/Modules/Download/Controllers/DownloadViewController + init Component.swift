//
//  DownloadViewController + init Component.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 12/01/2022.
//

import Foundation
import UIKit

//MARK: - Các hàm khởi tạo, Setup
extension DownloadViewController {
    func initComponents() {
        initTableView()
    }
    
    private func initTableView() {
        VideoCell.registerCellByNib(tblDownload)
        tblDownload.dataSource = self
        tblDownload.delegate = self
        tblDownload.separatorInset.left = 0
        tblDownload.showsVerticalScrollIndicator = true
        tblDownload.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblDownload.width, height: 0))
        
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(gestureRecognizer:)))
        longPressGesture.minimumPressDuration = 1
        tblDownload.addGestureRecognizer(longPressGesture)
    }
    
    func initFakeComponentView(rect: CGRect, image: UIImage) {
        // View screen
        initViewScreen()
        // View fake
        initViewFake(rect: rect, image: image)
        // View Action Perform
        initActionPerformView(rect: rect)
        // View Action
        initActionView()
    }
    
    private func initViewScreen() {
        viewScreen = UIView(frame: view.bounds)
        viewScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapViewScreen)))
        viewScreen.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        view.addSubview(viewScreen)
    }
    
    private func initViewFake(rect: CGRect, image: UIImage) {
        viewFake = UIView(frame: rect)
        viewFake.backgroundColor = .white
        viewScreen.addSubview(viewFake)
        
        let imageView = UIImageView()
        imageView.image = image
        viewFake.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: viewFake.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: viewFake.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: viewFake.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: viewFake.heightAnchor)
        ])
        
        self.viewScreen.layoutIfNeeded()
        
        self.frameFakeView = viewScreen.getConvertedFrame(fromSubview: viewFake)
    }
    
    private func initActionPerformView(rect: CGRect) {
        // View Main Action perform
        viewMainActionPerform = UIView()
        viewMainActionPerform.backgroundColor = .clear
        viewScreen.addSubview(viewMainActionPerform)
        
        viewMainActionPerform.translatesAutoresizingMaskIntoConstraints = false
        
        // get safe area height
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
                
        if (rect.origin.y + rect.height) > (UIScreen.main.bounds.height / 2) {
            checkViewActionPerformToBottomScreen = false
            
            NSLayoutConstraint.activate([
                viewMainActionPerform.topAnchor.constraint(equalTo: viewScreen.topAnchor, constant: 5 + topPadding),
                viewMainActionPerform.leadingAnchor.constraint(equalTo: viewScreen.leadingAnchor, constant: 0),
                viewMainActionPerform.widthAnchor.constraint(equalTo: viewScreen.widthAnchor, multiplier: 1),
                viewMainActionPerform.heightAnchor.constraint(equalToConstant: 100)
            ])
        } else {
            checkViewActionPerformToBottomScreen = true
            
            NSLayoutConstraint.activate([
                viewMainActionPerform.bottomAnchor.constraint(equalTo: viewScreen.bottomAnchor, constant: -5 - bottomPadding),
                viewMainActionPerform.leadingAnchor.constraint(equalTo: viewScreen.leadingAnchor, constant: 0),
                viewMainActionPerform.widthAnchor.constraint(equalTo: viewScreen.widthAnchor, multiplier: 1),
                viewMainActionPerform.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        /*
         Thực hiện layout view Action perform và label
            - Nếu view Main action đang xuất hiện trên cùng thì phần view action sẽ trên label
            - Nếu view Main action đang xuất hiện dưới cùng thì phần view action sẽ dưới label
         */
        
        // View Action perform
        viewActionPerform = PanDynamicView()
        viewMainActionPerform.addSubview(viewActionPerform)
        viewActionPerform.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewActionPerform.widthAnchor.constraint(equalToConstant: 80),
            viewActionPerform.heightAnchor.constraint(equalToConstant: 80),
            viewActionPerform.centerXAnchor.constraint(equalTo: viewMainActionPerform.centerXAnchor),
            checkViewActionPerformToBottomScreen ? viewActionPerform.topAnchor.constraint(equalTo: viewMainActionPerform.topAnchor) :
                viewActionPerform.bottomAnchor.constraint(equalTo: viewMainActionPerform.bottomAnchor)
        ])
        
        
        
        viewActionPerform.layer.cornerRadius = 30
        viewActionPerform.layer.borderWidth = 3
        viewActionPerform.layer.borderColor = UIColor.white.cgColor
                
        // Label
        let label = UILabel()
        label.text = "Kéo vào đây để thực hiện"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        
        viewMainActionPerform.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewMainActionPerform.centerXAnchor),
            checkViewActionPerformToBottomScreen ? label.bottomAnchor.constraint(equalTo: viewMainActionPerform.bottomAnchor) :
                label.topAnchor.constraint(equalTo: viewMainActionPerform.topAnchor)
        ])
        
        self.viewScreen.layoutIfNeeded()
        
        // Gán lại frame cho Action perform
        self.frameActionPerform = viewScreen.getConvertedFrame(fromSubview: viewActionPerform)
        
        // Chưa làm được chức năng kéo để xóa nên ẩn tạm View Action Perform
        viewMainActionPerform.isHidden = true
    }
    
    private func initActionView() {
        let heightMainActionView = getHeightMainActionView().height
        let isReverse = getHeightMainActionView().isReverse
        let heightActionView = heightMainActionView / 4
                
        // View Main Action
        viewMainAction = UIView()
        viewScreen.addSubview(viewMainAction)
        viewMainAction.translatesAutoresizingMaskIntoConstraints = false
        
        if checkViewActionPerformToBottomScreen {
            NSLayoutConstraint.activate([
                viewMainAction.widthAnchor.constraint(equalToConstant: viewScreen.width * 3 / 4),
                viewMainAction.heightAnchor.constraint(equalToConstant: heightMainActionView),
                viewMainAction.centerXAnchor.constraint(equalTo: viewScreen.centerXAnchor),
                !isReverse ? viewMainAction.topAnchor.constraint(equalTo: viewFake.bottomAnchor, constant: 20) :
                    viewMainAction.bottomAnchor.constraint(equalTo: viewFake.topAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                viewMainAction.widthAnchor.constraint(equalToConstant: viewScreen.width * 3 / 4),
                viewMainAction.heightAnchor.constraint(equalToConstant: heightMainActionView),
                viewMainAction.centerXAnchor.constraint(equalTo: viewScreen.centerXAnchor),
                isReverse ? viewMainAction.topAnchor.constraint(equalTo: viewFake.bottomAnchor, constant: 20) :
                    viewMainAction.bottomAnchor.constraint(equalTo: viewFake.topAnchor, constant: -20)
            ])
        }
        
        // View Share
        viewShare = PanDynamicView()
        viewMainAction.addSubview(viewShare)
        viewShare.translatesAutoresizingMaskIntoConstraints = false
        viewShare.signleDragable(view: viewScreen, type: .share)
        viewShare.layer.cornerRadius = heightActionView / 2
        viewShare.layer.borderWidth = 2
        viewShare.layer.borderColor = UIColor.white.cgColor
        initButtonIntoActionView(view: viewShare, imageName: "ic_share", viewHeight: heightActionView, padding: 3)
        
        NSLayoutConstraint.activate([
            viewShare.centerYAnchor.constraint(equalTo: viewMainAction.centerYAnchor),
            viewShare.trailingAnchor.constraint(equalTo: viewMainAction.trailingAnchor),
            viewShare.widthAnchor.constraint(equalToConstant: heightActionView),
            viewShare.heightAnchor.constraint(equalToConstant: heightActionView)
        ])
        
        // View Delete
        viewDelete = PanDynamicView()
        viewMainAction.addSubview(viewDelete)
        viewDelete.translatesAutoresizingMaskIntoConstraints = false
        viewDelete.layer.cornerRadius = heightActionView / 2
        viewDelete.layer.borderWidth = 2
        viewDelete.layer.borderColor = UIColor.white.cgColor
        viewDelete.signleDragable(view: viewScreen, type: .delete)
        initButtonIntoActionView(view: viewDelete, imageName: "ic_trash", viewHeight: heightActionView, padding: 3)
        
        NSLayoutConstraint.activate([
            viewDelete.centerYAnchor.constraint(equalTo: viewMainAction.centerYAnchor),
            viewDelete.leadingAnchor.constraint(equalTo: viewMainAction.leadingAnchor),
            viewDelete.widthAnchor.constraint(equalToConstant: heightActionView),
            viewDelete.heightAnchor.constraint(equalToConstant: heightActionView)
        ])
        
        // View Save
        viewSave = PanDynamicView()
        viewMainAction.addSubview(viewSave)
        viewSave.translatesAutoresizingMaskIntoConstraints = false
        viewSave.layer.cornerRadius = heightActionView / 2
        viewSave.layer.borderWidth = 2
        viewSave.layer.borderColor = UIColor.white.cgColor
        viewSave.signleDragable(view: viewScreen, type: .save)
        initButtonIntoActionView(view: viewSave, imageName: "ic_save", viewHeight: heightActionView, padding: 3)
        
        if checkViewActionPerformToBottomScreen {
            NSLayoutConstraint.activate([
                viewSave.widthAnchor.constraint(equalToConstant: heightActionView),
                viewSave.heightAnchor.constraint(equalToConstant: heightActionView),
                viewSave.centerXAnchor.constraint(equalTo: viewMainAction.centerXAnchor),
                isReverse ? viewSave.topAnchor.constraint(equalTo: viewMainAction.topAnchor) :
                    viewSave.bottomAnchor.constraint(equalTo: viewMainAction.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                viewSave.widthAnchor.constraint(equalToConstant: heightActionView),
                viewSave.heightAnchor.constraint(equalToConstant: heightActionView),
                viewSave.centerXAnchor.constraint(equalTo: viewMainAction.centerXAnchor),
                !isReverse ? viewSave.topAnchor.constraint(equalTo: viewMainAction.topAnchor) :
                    viewSave.bottomAnchor.constraint(equalTo: viewMainAction.bottomAnchor)
            ])
        }
        
        // View Play
        viewPlay = PanDynamicView()
        viewMainAction.addSubview(viewPlay)
        viewPlay.translatesAutoresizingMaskIntoConstraints = false
        viewPlay.layer.cornerRadius = heightActionView / 2
        viewPlay.layer.borderWidth = 2
        viewPlay.layer.borderColor = UIColor.white.cgColor
        viewPlay.signleDragable(view: viewScreen, type: .play)
        initButtonIntoActionView(view: viewPlay, imageName: "ic_play_1", viewHeight: heightActionView, padding: 3)
        
        if checkViewActionPerformToBottomScreen {
            NSLayoutConstraint.activate([
                viewPlay.widthAnchor.constraint(equalToConstant: heightActionView),
                viewPlay.heightAnchor.constraint(equalToConstant: heightActionView),
                viewPlay.centerXAnchor.constraint(equalTo: viewMainAction.centerXAnchor),
                !isReverse ? viewPlay.topAnchor.constraint(equalTo: viewMainAction.topAnchor) :
                    viewPlay.bottomAnchor.constraint(equalTo: viewMainAction.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                viewPlay.widthAnchor.constraint(equalToConstant: heightActionView),
                viewPlay.heightAnchor.constraint(equalToConstant: heightActionView),
                viewPlay.centerXAnchor.constraint(equalTo: viewMainAction.centerXAnchor),
                isReverse ? viewPlay.topAnchor.constraint(equalTo: viewMainAction.topAnchor) :
                    viewPlay.bottomAnchor.constraint(equalTo: viewMainAction.bottomAnchor)
            ])
        }
        
        // Lấy giá trị frame của từng view action
        viewScreen.layoutIfNeeded()
        
        self.frameShare = viewScreen.getConvertedFrame(fromSubview: viewShare)
        self.frameDelete = viewScreen.getConvertedFrame(fromSubview: viewDelete)
        self.frameSave = viewScreen.getConvertedFrame(fromSubview: viewSave)
        self.framePlay = viewScreen.getConvertedFrame(fromSubview: viewPlay)
    }
    
    private func initButtonIntoActionView(view: PanDynamicView, imageName: String, viewHeight: CGFloat, padding: CGFloat) {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.backgroundColor = .white
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: viewHeight - padding * 2),
            button.heightAnchor.constraint(equalToConstant: viewHeight - padding * 2)
        ])
        
        button.layer.cornerRadius = (viewHeight - padding * 2) / 2
        button.layer.masksToBounds = true
        
        switch view {
        case viewShare:
            button.addTarget(self, action: #selector(tapViewShareAction), for: .touchUpInside)
        case viewDelete:
            button.addTarget(self, action: #selector(tapViewDeleteAction), for: .touchUpInside)
        case viewSave:
            button.addTarget(self, action: #selector(tapViewSaveAction), for: .touchUpInside)
        case viewPlay:
            button.addTarget(self, action: #selector(tapViewPlayAction), for: .touchUpInside)
        default:
            break
        }
    }
}
