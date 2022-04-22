//
//  DownloadViewController.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 06/10/2021.
//

import UIKit
import AVKit
import AssetsLibrary
import Photos

//MARK: - Outlet, Override
class DownloadViewController: UIViewController {
    @IBOutlet weak var tblDownload: UITableView!
    
    var listVideos: [String] = []
    
    var currentPlayer : AVPlayer!
    
    // index path cell tableview
    var indexPath: IndexPath!
    
    // View Screen và view fake
    var viewScreen: UIView!
    var viewFake: UIView!
    
    // View Action
    var viewMainAction: UIView!
    var viewShare: PanDynamicView!
    var viewDelete: PanDynamicView!
    var viewSave: PanDynamicView!
    var viewPlay: PanDynamicView!
    
    // View thực hiện action
    var viewMainActionPerform: UIView!
    var viewActionPerform: PanDynamicView!
    
    // Kiểm tra xem view Action perform lên đặt ở vị trí nào (top, bottom) , Default: Bottom (true)
    var checkViewActionPerformToBottomScreen = true
    
    // Khung tọa độ của các view action
    var frameActionPerform: CGRect!
    var frameShare: CGRect!
    var frameDelete: CGRect!
    var frameSave: CGRect!
    var framePlay: CGRect!
    var frameFakeView: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDatas()
    }
}



//MARK: - Customize
extension DownloadViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension DownloadViewController {
    @objc func longPressCell(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tblDownload)
            if let indexPath = tblDownload.indexPathForRow(at: touchPoint) {
                if (tblDownload.cellForRow(at: indexPath) as! VideoCell).progress.isHidden {
                    guard let cell = tblDownload.cellForRow(at: indexPath) as? VideoCell else {return}
                    self.indexPath = indexPath
                    tblDownload.scrollToRow(at: indexPath, at: .none, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.tblDownload.isUserInteractionEnabled = false
                        self.tabBarController?.view.subviews.forEach({ view in
                            if view is MainTabbar {
                                view.isHidden = true
                            }
                        })
                        
                        let rect = self.tblDownload.rectForRow(at: indexPath)
                        let rectInScreen = self.tblDownload.convert(rect, to: self.view)
                        let image = cell.contentView.takeScreenshot()
                        
                        cell.contentView.isHidden = true
                        
                        self.initFakeComponentView(rect: rectInScreen, image: image)
                    }
                }
            }
        }
    }
    
    @objc func fadeOut(cell: VideoCell) {
        UIView.animate(withDuration: 0.4, animations: {
            cell.lblProgress.alpha = 0
        }) { (_) in
            cell.downloadedState()
        }
    }
    
    @objc func tapViewScreen() {
        hiddenViewScreenWhenTapped()
    }
    
    @objc func tapViewShareAction() {
        AlertUtil.showAlert(from: self, with: "Chức năng đang phát triển", message: "")
    }
    
    @objc func tapViewDeleteAction() {
        AlertUtil.showAlertConfirm(from: self, with: "Bạn có muốn xóa?", message: "") { _ in
            self.deleteVideo(self.indexPath, isAlert: true)
        }
    }
    
    @objc func tapViewSaveAction() {
        AlertUtil.showAlertConfirm(from: self, with: "Bạn có muốn lưu video?", message: "") { _ in
            let path = Literals.documentsDirectory.appendingPathComponent(self.listVideos[self.indexPath.row]).path
            if !UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: path))
            }, completionHandler: { succeeded, error in
                if error == nil {
                    AlertUtil.showAlert(from: self, with: "Lưu video thành công", message: "") { _ in
                        self.deleteVideo(self.indexPath, isAlert: false)
                    }
                }
            })
        }
    }
    
    @objc func tapViewPlayAction() {
        AlertUtil.showAlertConfirm(from: self, with: "Bạn có muốn phát video?", message: "") { _ in
            self.playingVideo(self.listVideos[self.indexPath.row])
        }
    }
}

//MARK: - Các hàm chức năng - get height Main action view and
extension DownloadViewController {
    /// Trả về chiều cao của Main Action View và giá trị kiểm tra có nên đảo nghịch hay không
    func getHeightMainActionView() -> (height: CGFloat, isReverse: Bool) {
        let heightMaxMainActionView: CGFloat = 200 // chiều cao tối đa có thể xem xét chấp nhận
        let heightMinMainActionView: CGFloat = 100 // chiều cao tối thiểu có thể xem xét chấp nhận
        
        let heightSpaceFakeView: CGFloat = 20 // Khoảng trắng layout giữa view Main Action và View Fake
        
        let heightMainActionPerformView: CGFloat = 100 // Chiều cao của View Main action perform được set bên trên
        // get safe area height
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        // Chiều cao khoảng trống trên cùng giữa view Fake và view Main action perform (Nếu checkViewActionPerformToBottomScreen = true)
        let heightSpaceTopToViewMainActionPerform: CGFloat = frameFakeView.origin.y - topPadding - 5 - heightMainActionPerformView
        // Chiều cao khoảng trống dưới cùng giữa view Fake và view Main action perform (Nếu checkViewActionPerformToBottomScreen = true)
        let heightSpaceBottomToViewMainActionPerform: CGFloat = viewScreen.height - frameFakeView.origin.y - frameFakeView.size.height - bottomPadding - 5 - heightMainActionPerformView
        // Chiều cao khoảng trống nói chung
        let heightSpaceToViewMainActionPerform: CGFloat = !checkViewActionPerformToBottomScreen ? heightSpaceTopToViewMainActionPerform : heightSpaceBottomToViewMainActionPerform
        
        // Chiều cao khoảng trống trên cùng giữa view Fake và view Screen
        let heightSpaceTopToViewScreen: CGFloat = frameFakeView.origin.y - topPadding - 5
        // Chiều cao khoảng trống dưới cùng giữa view Fake và view Screen
        let heightSpaceBottomToViewScreen: CGFloat = viewScreen.height - frameFakeView.origin.y - frameFakeView.size.height - bottomPadding - 5
        
        // Set lại chiều cao Main Action View (Ưu tiên theo chiều đối lập với Main Action Perform)
        if checkViewActionPerformToBottomScreen {
            if heightSpaceTopToViewScreen >= (heightMaxMainActionView + heightSpaceFakeView) {
                return (heightMaxMainActionView, true)
            } else if heightSpaceToViewMainActionPerform >= (heightMaxMainActionView + heightSpaceFakeView) {
                return (heightMaxMainActionView, false)
            } else if heightSpaceTopToViewScreen < (heightMaxMainActionView + heightSpaceFakeView) && heightSpaceTopToViewScreen >= (heightMinMainActionView + heightSpaceFakeView) {
                return (heightSpaceTopToViewScreen, true)
            } else if heightSpaceToViewMainActionPerform < (heightMaxMainActionView + heightSpaceFakeView) && heightSpaceToViewMainActionPerform >= (heightMinMainActionView + heightSpaceFakeView) {
                return (heightSpaceToViewMainActionPerform, false)
            } else if heightSpaceTopToViewScreen < (heightMinMainActionView + heightSpaceFakeView) && heightSpaceTopToViewScreen >= heightMinMainActionView {
                return (heightMinMainActionView, true)
            } else if heightSpaceToViewMainActionPerform < (heightMinMainActionView + heightSpaceFakeView) && heightSpaceToViewMainActionPerform >= heightMinMainActionView {
                return (heightMinMainActionView, false)
            } else if heightSpaceTopToViewScreen < heightMinMainActionView {
                return (heightSpaceTopToViewScreen - 20, true)
            } else {
                return (heightSpaceToViewMainActionPerform - 20, false)
            }
        } else {
            if heightSpaceBottomToViewScreen >= (heightMaxMainActionView + heightSpaceFakeView) {
                return (heightMaxMainActionView, true)
            } else if heightSpaceToViewMainActionPerform >= (heightMaxMainActionView + heightSpaceFakeView) {
                return (heightMaxMainActionView, false)
            } else if heightSpaceBottomToViewScreen < (heightMaxMainActionView + heightSpaceFakeView) && heightSpaceBottomToViewScreen >= (heightMinMainActionView + heightSpaceFakeView) {
                return (heightSpaceBottomToViewScreen, true)
            } else if heightSpaceToViewMainActionPerform < (heightMaxMainActionView + heightSpaceFakeView) && heightSpaceToViewMainActionPerform >= (heightMinMainActionView + heightSpaceFakeView) {
                return (heightSpaceToViewMainActionPerform, false)
            } else if heightSpaceBottomToViewScreen < (heightMinMainActionView + heightSpaceFakeView) && heightSpaceBottomToViewScreen >= heightMinMainActionView {
                return (heightMinMainActionView, true)
            } else if heightSpaceToViewMainActionPerform < (heightMinMainActionView + heightSpaceFakeView) && heightSpaceToViewMainActionPerform >= heightMinMainActionView {
                return (heightMinMainActionView, false)
            } else if heightSpaceBottomToViewScreen < heightMinMainActionView {
                return (heightSpaceBottomToViewScreen - 20, true)
            } else {
                return (heightSpaceToViewMainActionPerform - 20, false)
            }
        }
    }
}

//MARK: - Các hàm chức năng - hidden
extension DownloadViewController {
    func hiddenViewScreenWhenTapped() {
        viewScreen.removeFromSuperview()
        guard let cell = tblDownload.cellForRow(at: self.indexPath) as? VideoCell else {return}
        cell.contentView.isHidden = false
        
        self.tabBarController?.view.subviews.forEach({ view in
            if view is MainTabbar {
                view.isHidden = false
            }
        })
        
        tblDownload.isUserInteractionEnabled = true
    }
}

//MARK: - Các hàm chức năng - Used Document
extension DownloadViewController {
    private func setupDatas() {
        // Lấy toàn bộ đường dẫn video trong document
        let videos = try! FileManager.default.contentsOfDirectory(atPath: Literals.documentsDirectory.path)
        appendWithoutAddingDuplicates(videos: videos)
        tblDownload.reloadData()
    }
    
    // Thêm video vào list (kiểm tra để video ko bị lặp lại)
    private func appendWithoutAddingDuplicates(videos: [String]) {
        for video in videos {
            if !checkContains(video: video) {
                self.listVideos.append(video)
            }
        }
    }
    
    // Kiểm tra video bị trùng chưa
    private func checkContains(video: String) -> Bool {
        for v in listVideos {
            if video == v {
                return true
            }
        }
        return video == ".DS_Store"
    }
    
    // Lấy vị trí của video (Nếu bị trùng)
    private func index(forVideoName name: String) -> Int? {
        for i in 0..<listVideos.count {
            if listVideos[i] == name {
                return i
            }
        }
        
        return nil
    }
    
    // Lưu video vào thư viện
    private func presentAlert(indexPath: IndexPath) {
        AlertUtil.showImagePicker(from: self, with: "", message: "") { _ in
            let path = Literals.documentsDirectory.appendingPathComponent(self.listVideos[indexPath.row]).path
            if !UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: path))
            }, completionHandler: { succeeded, error in
                if error == nil {
                    AlertUtil.showAlert(from: self, with: "Lưu video thành công", message: "")
                }
            })
              
        } completionPicture: { _ in
            self.deleteVideo(indexPath, isAlert: true)
        }
    }
    
    func deleteVideo(_ indexPath: IndexPath, isAlert: Bool) {
        do {
            try FileManager.default.removeItem(at: Literals.documentsDirectory.appendingPathComponent(listVideos[indexPath.row]))
            
            if isAlert {
                AlertUtil.showAlert(from: self, with: "Xóa thành công", message: "")
            }
            
            self.hiddenViewScreenWhenTapped()
            
            listVideos.remove(at: indexPath.row)
            tblDownload.deleteRows(at: [indexPath], with: .left)
        }catch {
            AlertUtil.showAlert(from: self, with: "Có lỗi xảy ra khi xóa file", message: "")
        }
    }
}

//MARK: - Các hàm chức năng - disable
extension DownloadViewController {
    func disableActionView(with type: Actiontype) {
        let shareType: Actiontype = .share
        let deleteType: Actiontype = .delete
        let saveType: Actiontype = .save
        let playType: Actiontype = .play
        
        if type != .none {
            viewShare.isUserInteractionEnabled = type == shareType
            viewDelete.isUserInteractionEnabled = type == deleteType
            viewSave.isUserInteractionEnabled = type == saveType
            viewPlay.isUserInteractionEnabled = type == playType
        } else {
            viewShare.isUserInteractionEnabled = true
            viewDelete.isUserInteractionEnabled = true
            viewSave.isUserInteractionEnabled = true
            viewPlay.isUserInteractionEnabled = true
        }
    }
}

//MARK: - HomeViewControllerDelegate
extension DownloadViewController: HomeViewControllerDelegate {
    func downloadDidBegin(name: String, image: UIImage) {
        // Nếu tên video không tồn tại trong danh sách
        if index(forVideoName: name) == nil {
            appendWithoutAddingDuplicates(videos: [name])
            
            if tblDownload == nil {
                setUp()
            }
            
            tblDownload.reloadData()
            
            if let cell = tblDownload.cellForRow(at: IndexPath(row: listVideos.count - 1, section: 0)) as? VideoCell {
                cell.image = image
                cell.downloadState()
            }
        }
    }
    
    func didReturnCurrentDownload(progress: Double, _ name: String) {
        if let index = index(forVideoName: name) {
            if let cell = tblDownload.cellForRow(at: IndexPath(row: index, section: 0)) as? VideoCell {
                cell.progress.progress = Float(progress)
                cell.lblProgress.text = "\(Int(Double(round(100 * progress) / 100) * 100))%"
                if progress == 1.0 {
                    cell.lblProgress.text = "Done"
                    perform(#selector(fadeOut(cell:)), with: cell, afterDelay: 0.5)
                    cell.progress.isHidden = true
//                    tblDownload.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }
}
