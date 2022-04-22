///Users/lam.hoangtung/Desktop/Project/Youtube_WatchAndDownload/Youtube_WatchAndDownload/DataSupportLayer/Utility/YoutubeDataAnalysis.swift
//  YoutubeScraper.swift
//  Youtube_WatchAndDownload
//
//  Created by Hoang Lam on 28/09/2021.
//

import Foundation
import HTMLKit

/// Phân tích dữ liệu trả về để lấy dữ liệu mục tiêu
class YoutubeDataAnalysis {
    static let share = YoutubeDataAnalysis()
    private init() {}
}

extension YoutubeDataAnalysis {
    /// Lấy đường dẫn video
    /// - Parameter source: Chuỗi HTML
    func getVideoLink(fromPageSource source: String) -> URL? {
        // Lấy dữ liệu từ thẻ `src`
        if let string = getVideoAttribute(for: "src", source: source) {
            if let url = URL(string: string) {
                return url
            }
        }
        return nil
    }
    
    /// Lấy tiêu đề video
    /// - Parameter source: Chuỗi HTML
    func getVideoTitle(fromPageSource source: String) -> String? {
        // Lấ dữ liệu từ thẻ `title`
        guard let string = getVideoAttribute(for: "title", source: source) else {return nil}
        return string
    }
    
    /// Lấy ảnh đại diện video
    /// - Parameter string: đường dẫn video trên webview
    func getThumbnailImage(fromUrlString string: String) -> URL {
        return imgUrl(getId(string))
    }
}

//MARK: - Private function
extension YoutubeDataAnalysis {
    private func imgUrl(_ idString: String) -> URL {
        // Đường dẫn tới thư mục hình ảnh youtube
        let stringImageUrl = "https://img.youtube.com/vi/\(idString)/0.jpg"
        
        guard let url = URL(string: stringImageUrl) else {
            let failStringUrl = "https://learn.getgrav.org/user/pages/11.troubleshooting/01.page-not-found/error-404.png"
            return URL(string: failStringUrl)!
        }
        
        return url
    }
    
    private func getId(_ string: String) -> String {
        guard string.range(of: "watch?v=") != nil else {
            return "Không lấy được id"
        }
        
        var r: Range<String.Index>!
        
        // Cắt chuỗi dựa theo giới hạn trên và dưới của 1 contain
        let u = string.range(of: "watch?v=")!.upperBound // Giới hạn trên của phạm vi cần lấy
        
        if string.range(of: "&feature") != nil {
            let h = string.range(of: "&feature")!.lowerBound
            r = u ..< h // lấy từ giới hạn trên đến cuối chuỗi
        } else {
            let h = string.endIndex
            r = u ..< h // lấy từ giới hạn trên đến cuối chuỗi
        }
        
        return String(string[r])
    }
    
    // Lấy đường dẫn video
    private func getVideoAttribute(for key: String, source: String) -> String? {
        let document = HTMLDocument(string: source)
        let videos: [String] = document.querySelectorAll("video").compactMap { element in
            guard let src = element.attributes[key] as? String else {
                return nil
            }
            return src
        }
        return videos.first
    }
}
