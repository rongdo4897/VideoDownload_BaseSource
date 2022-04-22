//
//  VideoCell.swift
//  Youtube_WatchAndDownload
//
//  Created by Hoang Lam on 04/10/2021.
//

import UIKit

class VideoCell: BaseTBCell {
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var lblProgress: UILabel!
    
    public var image : UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        initComponents()
        customizeComponents()
    }
}

//MARK: - Các hàm khởi tạo, Setup
extension VideoCell {
    private func initComponents() {
        initLabel()
    }
    
    private func initLabel() {
        lblName.adjustsFontSizeToFitWidth = true
    }
}

//MARK: - Customize
extension VideoCell {
    private func customizeComponents() {
        
    }
}

//MARK: - Các hàm chức năng
extension VideoCell {
    /// Ở trạng thái tải xuống
    public func downloadState() {
        lblName.alpha = 0.4
        lblProgress.isHidden = false
        progress.isHidden = false
    }
    
    /// Trạng thái tải xuống hoàn thành
    public func downloadedState() {
        lblName.alpha = 1
        lblProgress.isHidden = true
        progress.isHidden = true
    }
}

//MARK: - Action - Obj
extension VideoCell {
    
}
