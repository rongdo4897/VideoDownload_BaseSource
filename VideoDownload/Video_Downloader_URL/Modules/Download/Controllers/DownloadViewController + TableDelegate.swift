//
//  DownloadViewController + TableDelegate.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 08/10/2021.
//

import Foundation
import UIKit
import AVKit

extension DownloadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as! VideoCell).progress.isHidden {
            playingVideo(listVideos[indexPath.row])
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func playingVideo(_ name: String) {
        let videoPlayer = AVPlayerViewController()
        currentPlayer = AVPlayer(url: Literals.documentsDirectory.appendingPathComponent(name))
        videoPlayer.player = currentPlayer
        
        present(videoPlayer, animated: true) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer.player!.currentItem)
            videoPlayer.player!.play()
        }
    }
    
    @objc private func playerDidFinishPlaying(notification: NSNotification) {
        let url = ((notification.object as! AVPlayerItem).asset as! AVURLAsset).url.lastPathComponent
        replaceVideo(nextVideo(fromFilename: url))
    }
    
    fileprivate func replaceVideo(_ fileName: String) {
        currentPlayer.replaceCurrentItem(with: AVPlayerItem(url: Literals.documentsDirectory.appendingPathComponent(fileName)))
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: currentPlayer!.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: currentPlayer!.currentItem)
        currentPlayer.play()
    }
    
    fileprivate func nextVideo(fromFilename file: String) -> String {
        let filtered = listVideos.filter({ FileManager.default.fileExists(atPath: Literals.documentsDirectory.appendingPathComponent($0).path) })
        for i in 0..<filtered.count {
            if filtered[i] == file {
                return i + 1 >= filtered.count ? filtered[0] : filtered[i + 1]
            }
        }
        return ""
    }
    
    fileprivate func previousVideo(fromFilename file: String) -> String {
        let filtered = listVideos.filter({ FileManager.default.fileExists(atPath: Literals.documentsDirectory.appendingPathComponent($0).path) })
        for i in 0..<filtered.count {
            if filtered[i] == file {
                return i - 1 < 0  ? filtered[filtered.count - 1] : filtered[i - 1]
            }
        }
        return ""
    }
}
