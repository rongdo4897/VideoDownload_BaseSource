//
//  HomeViewController + Show View.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 06/01/2022.
//

import Foundation
import UIKit

//MARK: - Các hàm chức năng - Show notifi view
extension HomeViewController {
    func showNotifiViewWithCheckImageUrl(imageUrl: URL? , cateType: CategoryType) {
        var notiType: NotifiType = .success
        var title: String = ""
        var description: String = ""
        
        if imageUrl != nil {
            title = "Lấy dữ liệu thành công"
            description = "Bạn nên xem video trước khi tiến hành download"
            notiType = .success
        } else {
            title = "Lấy dữ liệu ảnh thất bại"
            description = "Bạn nên xem video trước khi tiến hành download"
            notiType = .warning
        }
        
        let notificationView = NotifiView(type: notiType, title: title, description: description)
        view.addSubview(notificationView)
    }
    
    func showNotifiView(notiType: NotifiType, title: String, description: String) {
        let notificationView = NotifiView(type: notiType, title: title, description: description)
        view.addSubview(notificationView)
    }
}
