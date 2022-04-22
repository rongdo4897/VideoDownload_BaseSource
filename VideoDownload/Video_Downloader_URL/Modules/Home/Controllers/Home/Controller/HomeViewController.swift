//
//  HomeViewController.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 06/10/2021.
//

import UIKit
import WebKit
import Kingfisher
import AVKit
import Alamofire
import HTMLKit

protocol HomeViewControllerDelegate: AnyObject {
    /// Bắt đầu tải xuống
    ///  - Parameter name: Tên thư mục lưu trong document
    ///  - Parameter url: Đường dẫn ảnh
    func downloadDidBegin(name: String, image: UIImage)
    
    /// Trả về tiến trình download hiện tại
    ///  - Parameter progress: Giá trị tiến trình
    ///  - Parameter name: Tên thư mục lưu trong document
    func didReturnCurrentDownload(progress: Double, _ name: String)
}

//MARK: - Outlet, Override
class HomeViewController: UIViewController {
    @IBOutlet weak var webViewData: WKWebView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var viewThumb: UIView!
    @IBOutlet weak var imgFail: UIImageView!
    @IBOutlet weak var lblFail: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblProgress: UILabel!
    
    static let share = HomeViewController()
    weak var delegate: HomeViewControllerDelegate?
    
    lazy var backdroundManager: Alamofire.SessionManager = {
        /*
         - URLSessionConfiguration.background: Tạo đối tượng cấu hình phiên cho phép tải lên hoặc tải xuống HTTP và HTTPS được thực hiện trong nền.
         
         - Alamofire.SessionManager: Chịu trách nhiệm tạo và quản lý các đối tượng request, cũng như NSURLSession cơ bản của chúng.
         */
        let bundleIdentifier = "foobar.background"
        
        let configuration = URLSessionConfiguration.background(withIdentifier: bundleIdentifier)
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    /// Biến này được tạo ra để dữ liệu cập nhập khi chạy dưới quyền
    public var backgroundCompletionHandler: (() -> Void)? {
        get {
            return backdroundManager.backgroundCompletionHandler
        }
        set {
            backdroundManager.backgroundCompletionHandler = newValue
        }
    }
    
    var type: CategoryType = .none
    var videoAbsoluteUrl: URL!
    var videoTitle: String?
    
    var absoluteUrlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
        hiddenComponentsVideo(isHidden: true)
        hiddenComponentsFail(isHidden: true)
        hiddenComponentsProgress(isHidden: true)
    }
    
    @IBAction func btnSearchTapped(_ sender: Any) {
        if !Reachability.isConnectedToNetwork() {
            AlertUtil.showAlertConfirm(from: self, with: "Mạng không khả dụng", message: "Thử lại?") { _ in
                self.btnSearchTapped(self)
            }
        } else {
            btnSearch.isHidden = true
            progressView.progress = 0
                    
            guard let text = tfSearch.text, text != "" else {
                self.showFailView(with: "Đường dẫn video bị trống")
                return
            }
            
            self.absoluteUrlString = text
                    
            // setup ui
            activity.isHidden = false
            activity.startAnimating()
            tfSearch.isUserInteractionEnabled = false
            hiddenComponentsVideo(isHidden: true)
            hiddenComponentsFail(isHidden: true)
            hiddenComponentsProgress(isHidden: false)
            
            // set category type
            checkAndSetCategoryType(stringUrl: text)
            
            // load url
            guard let url = URL(string: text) else {
                let notificationView = NotificationDownloadView(text: "Đường dẫn video sai định dạng", bgColor: .red, textColor: .white)
                view.addSubview(notificationView)
                return
            }
            webViewData.load(URLRequest(url: url))
        }
    }
    
    @IBAction func btnDownloadTapped(_ sender: Any) {
        var image: UIImage!
        if imgThumb.image != nil {
            image = imgThumb.image!
        } else {
            image = UIImage(named: "ic_noImage")
        }
        
        webViewData.stopLoading()
        hiddenComponentsProgress(isHidden: true)
        hiddenComponentsVideo(isHidden: true)
        hiddenComponentsFail(isHidden: true)
        btnSearch.isHidden = false
        progressView.progress = 0
        activity.stopAnimating()
        activity.isHidden = true
        tfSearch.isUserInteractionEnabled = true
        
        downloaded(videoUrl: videoAbsoluteUrl, image: image, title: videoTitle)
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        webViewData.stopLoading()
        hiddenComponentsProgress(isHidden: true)
        hiddenComponentsVideo(isHidden: true)
        hiddenComponentsFail(isHidden: true)
        btnSearch.isHidden = false
        progressView.progress = 0
        activity.stopAnimating()
        activity.isHidden = true
        tfSearch.isUserInteractionEnabled = true
    }
}

//MARK: - Các hàm khởi tạo, Setup
extension HomeViewController {
    private func initComponents() {
        initWebView()
        initProgressView()
        initActivityIndicator()
        initTextFields()
        initViews()
    }
    
    private func initWebView() {
        webViewData.configuration.mediaTypesRequiringUserActionForPlayback = .all
        webViewData.configuration.allowsInlineMediaPlayback = false
        
        webViewData.navigationDelegate = self
        
        webViewData.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
    }
    
    private func initProgressView() {
        progressView.progress = 0
    }
    
    private func initActivityIndicator() {
        activity.isHidden = true
        activity.stopAnimating()
    }
    
    private func initTextFields() {
        tfSearch.placeholder = "Nhập liên kết của bạn ở đây"
    }
    
    private func initViews() {
        viewThumb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapViewVideo)))
    }
}

//MARK: - Customize
extension HomeViewController {
    private func customizeComponents() {
        customizeProgressView()
        customizeTextFields()
        customizeButtons()
        customizeActivityIndicator()
        customizeViews()
        customizeImages()
    }
    
    private func customizeProgressView() {
        progressView.layer.cornerRadius = progressView.height / 2
        progressView.layer.masksToBounds = true
    }
    
    private func customizeTextFields() {
        // padding
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        let imageView = UIImageView(image: UIImage(named: "ic_search"))
        imageView.frame = CGRect(x: 15, y: 0, width: 25, height: 25)
        imageView.contentMode = .scaleAspectFit
        leftView.addSubview(imageView)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        
        self.tfSearch.leftView = leftView
        self.tfSearch.leftViewMode = .always
        self.tfSearch.rightView = rightView
        self.tfSearch.rightViewMode = .always
        tfSearch.layer.cornerRadius = tfSearch.height / 2
        
        // shadow
        let innerShadow = CALayer()
        innerShadow.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: tfSearch.height)
        
        let radius = tfSearch.height / 2
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: -5, dy: -5), cornerRadius:radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()
        
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        // Shadow properties
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 3)
        innerShadow.shadowOpacity = 0.15
        innerShadow.shadowRadius = 3
        innerShadow.cornerRadius = tfSearch.height/2
        tfSearch.layer.addSublayer(innerShadow)
    }
    
    private func customizeButtons() {
        btnSearch.layer.cornerRadius = 10
        btnDownload.layer.cornerRadius = 10
        btnCancel.layer.cornerRadius = 5
    }
    
    private func customizeActivityIndicator() {
        activity.color = UIColor.red
    }
    
    private func customizeViews() {
        viewThumb.layer.cornerRadius = 10
        viewThumb.layer.borderWidth = 2
        viewThumb.layer.borderColor = UIColor.red.cgColor
    }
    
    private func customizeImages() {
        imgThumb.layer.cornerRadius = 10
    }
}

//MARK: - Action - Obj
extension HomeViewController {
    @objc private func tapViewVideo() {
        let videoPlayer = AVPlayerViewController()
        let currentPlayer = AVPlayer(url: self.videoAbsoluteUrl)
        videoPlayer.player = currentPlayer
        
        present(videoPlayer, animated: true) {
//            NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer.player!.currentItem)
            videoPlayer.player!.play()
        }
    }
    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(self.webViewData.estimatedProgress)
            self.lblProgress.text = String(Int(Float(self.webViewData.estimatedProgress) * 100)) + " %"
        }
    }
}

//MARK: - LoginViewControllerDelegate
extension HomeViewController: LoginViewControllerDelegate {
    func reloadWebView(isReload: Bool) {
        DispatchQueue.main.async {
            if isReload {
                self.btnSearchTapped(self)
            }
        }
    }
}
