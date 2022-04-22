//
//  HomeViewController + Webview Delegate.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 06/01/2022.
//

import Foundation
import WebKit
import UIKit

//MARK: - WKNavigationDelegate
extension HomeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch webView {
        case webViewData:
            self.setUpUIWhenWebviewDidFinish()
            
            webViewData.evaluateJavaScript("document.documentElement.outerHTML.toString()") { html, error in
                guard let html = html else{
                    self.showResultView(isHidden: false)
                    return
                }
                
                var isLogin = false
                
                switch self.type {
                case .facebook:
                    isLogin = (html as! String).contains("https://www.facebook.com/login/")
                default:
                    isLogin = false
                    break
                }
                
                if isLogin {
                    AlertUtil.showAlertConfirm(from: self, with: "Cảnh báo!", message: "\(self.type.rawValue) yêu cầu phải đăng nhập trước khi tải theo chính sách bảo mật. Bạn có muốn đăng nhập?") { _ in
                        guard let vc = RouterType.login.getVc() as? LoginViewController else {return}
                        vc.type = self.type
                        vc.delegate = self
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                } else {
                    self.downloadOptions(html: html as! String, url: self.webViewData.url!.absoluteString)
                }
            }
        default:
            break
        }
    }
}
