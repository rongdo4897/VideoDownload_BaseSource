//
//  DownloadViewController + TableDataSource.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 08/10/2021.
//

import Foundation
import UIKit
import AVKit

//MARK: - TableView
extension DownloadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = VideoCell.loadCell(tableView) as? VideoCell else {return UITableViewCell()}
        
        let video = listVideos[indexPath.row]
        cell.lblName.text = video.replacingOccurrences(of: ".mp4", with: "")
        let videoUrl = URL(fileURLWithPath: Literals.documentsDirectory.appendingPathComponent(video).path)
        // Lấy ảnh snapshot từ video đã tồn tại trong document
        if let image = self.firstFrame(url: videoUrl) {
            cell.imgThumb.image = image
        } else if cell.image != nil {
            cell.imgThumb.image = cell.image
        }
        
        if FileManager.default.fileExists(atPath: Literals.documentsDirectory.appendingPathComponent(video).path) {
            cell.downloadedState()
        } else {
            cell.downloadState()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = (tableView.cellForRow(at: indexPath) as? VideoCell) {
            return cell.progress.isHidden
        }
        return false
    }
    
    // Lấy ảnh Thumb video (dùng cho các video cũ - snapshot video)
    fileprivate func firstFrame(url: URL) -> UIImage? {
        let generator = AVAssetImageGenerator(asset: AVURLAsset(url: url))
        generator.appliesPreferredTrackTransform = true
        if let image = try? UIImage(cgImage: generator.copyCGImage(at: CMTime(seconds: 30, preferredTimescale: 1), actualTime: nil)) {
            return image
        }
        return nil
    }
}
