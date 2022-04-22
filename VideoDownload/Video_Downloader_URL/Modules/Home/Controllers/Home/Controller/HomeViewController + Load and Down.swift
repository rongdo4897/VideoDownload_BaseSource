//
//  HomeViewController + Load and Down.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 06/01/2022.
//

import Foundation
import UIKit
import Alamofire

//MARK: - Các hàm chức năng - Load
extension HomeViewController {
    func loadImageWithUrl(url: URL?) {
        if let url = url {
            imgThumb.kf.setImage(with: url) { result in
                switch result {
                case .success(let image):
                    self.imgThumb.image = image.image
                case .failure(_):
                    self.imgThumb.image = UIImage(named: "ic_noImage")
                }
            }
        } else {
            imgThumb.image = UIImage(named: "ic_noImage")
        }
    }
    
    func checkAndSetCategoryType(stringUrl: String) {
        if stringUrl.contains("you") && stringUrl.contains("tu") && stringUrl.contains("be") {
            type = .youtube
        }
    }
    
    func showFailView(with message: String) {
        let notificationView = NotificationDownloadView(text: "Đường dẫn video sai định dạng", bgColor: .red, textColor: .white)
        view.addSubview(notificationView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.btnSearch.isHidden = false
        }
    }
    
    func downloadOptions(html: String, url: String) {
        var videoUrl: URL?
        var imageUrl: URL?
        var title: String?
        
        switch self.type {
        case .youtube:
            videoUrl = YoutubeDataAnalysis.share.getVideoLink(fromPageSource: html)
            imageUrl = YoutubeDataAnalysis.share.getThumbnailImage(fromUrlString: url)
            title = YoutubeDataAnalysis.share.getVideoTitle(fromPageSource: html)
            
            showViewImage(imageUrl: imageUrl, videoUrl: videoUrl, title: title)
        default:
            break
        }
    }
    
    func downloaded(videoUrl: URL, image: UIImage, title: String?) {
        let videoName = (title ?? "videoplayback_\(arc4random_uniform(1000000))") + ".mp4"
        // Thêm đường dẫn vào thư mục document
        let documentPath = Literals.documentsDirectory.appendingPathComponent(videoName)
        
        // Truyền đi đường dẫn video và ảnh nhận đc (bắt đầu cho tiến trình download)
        delegate?.downloadDidBegin(name: documentPath.lastPathComponent, image: image)
        
        // Hiển thị view thông báo video bắt đầu được tải xuống
        let notificationView = NotificationDownloadView(text: "Video đã được thêm vào tiến trình tải xuống")
        view.addSubview(notificationView)
        
        // download
        backdroundManager.download(videoUrl, method: .get, encoding: URLEncoding.default) { (destroy_state, response) -> (destinationUrl: URL, options: DownloadRequest.DownloadOptions) in
            return (destinationUrl: documentPath, options: DownloadRequest.DownloadOptions.removePreviousFile)
        }.downloadProgress { progress in
            // truyền đi tiến trình download trong document
            self.delegate?.didReturnCurrentDownload(progress: progress.fractionCompleted, documentPath.lastPathComponent)
        }
    }
    
    func showViewImage(imageUrl: URL?, videoUrl: URL?, title: String?) {
        self.showResultView(isHidden: false)
        
        // Thông báo ở đây
        showNotifiViewWithCheckImageUrl(imageUrl: imageUrl, cateType: self.type)
        
        self.videoAbsoluteUrl = videoUrl
        self.videoTitle = title
        
        self.loadImageWithUrl(url: imageUrl)
    }
    
    func useSearchComponent(_ isUsed: Bool) {
        btnSearch.alpha = isUsed ? 1 : 0.6
        btnSearch.isUserInteractionEnabled = isUsed
        tfSearch.isUserInteractionEnabled = isUsed
    }
}
