//
//  HomeViewController + Hidden.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 06/01/2022.
//

import Foundation

//MARK: - Các hàm chức năng - Hidden
extension HomeViewController {
    func hiddenComponentsVideo(isHidden: Bool) {
        viewThumb.isHidden = isHidden
        btnDownload.isHidden = isHidden
    }
    
    func hiddenComponentsFail(isHidden: Bool) {
        imgFail.isHidden = isHidden
        lblFail.isHidden = isHidden
    }
    
    func hiddenComponentsProgress(isHidden: Bool) {
        progressView.isHidden = isHidden
        btnCancel.isHidden = isHidden
        lblProgress.isHidden = isHidden
    }
    
    func setUpUIWhenWebviewDidFinish() {
        activity.stopAnimating()
        activity.isHidden = true
        btnSearch.isHidden = false
        tfSearch.isUserInteractionEnabled = true
        progressView.progress = 0
        tfSearch.resignFirstResponder()
        hiddenComponentsProgress(isHidden: true)
    }
    
    func showResultView(isHidden: Bool) {
        hiddenComponentsVideo(isHidden: isHidden)
        hiddenComponentsFail(isHidden: !isHidden)
        type = .none
    }
}
