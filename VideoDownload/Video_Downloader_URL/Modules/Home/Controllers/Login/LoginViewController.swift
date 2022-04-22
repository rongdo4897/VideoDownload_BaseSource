//
//  LoginViewController.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 04/01/2022.
//

import UIKit
import WebKit

protocol LoginViewControllerDelegate: AnyObject {
    func reloadWebView(isReload: Bool)
}

//MARK: - Outlet, Override
class LoginViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    weak var delegate: LoginViewControllerDelegate?
    
    var type: CategoryType = .none
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
        addAnimation()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        removeAnimation {
            self.delegate?.reloadWebView(isReload: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

//MARK: - Các hàm khởi tạo
extension LoginViewController {
    private func initComponents() {
        initWebView()
    }
    
    private func initWebView() {
        switch type {
        case .facebook:
            webView.load(URLRequest(url: URL(string: "https://www.facebook.com/login/")!))
        default:
            break
        }
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress1", options: .new, context: nil)
    }
}

//MARK: - Customize
extension LoginViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension LoginViewController {
    
}

//MARK: - Các hàm chức năng - animation
extension LoginViewController {
    func addAnimation() {
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.height)
        UIView.animate(withDuration: 0.25) {
            self.view.transform = .identity
        }
    }

    func removeAnimation(completion: @escaping () -> Void) {
        self.dismiss(animated: true, completion: completion)
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        count += 1
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { html, error in
            guard let html = html else{
                return
            }
            
            print((html as! String).contains("https://www.facebook.com/login/"))
            print("-------")
            print(html as! String)
            
            if self.count > 3 {
                switch self.type {
                case .facebook:
                    if !(html as! String).contains("https://www.facebook.com/login/") {
                        AlertUtil.showAlert(from: self, with: "Đăng nhập thành công!", message: "Bạn đã đăng nhập thành công facebook, hãy trải nghiệm download vui vẻ.") { _ in
                            self.removeAnimation {
                                self.delegate?.reloadWebView(isReload: true)
                            }
                        }
                    }
                default:
                    break
                }
            }
            
        }
        decisionHandler(.allow)
    }
}
