//
//  WKTrafficManager.swift
//  Youtube_WatchAndDownload
//
//  Created by Hoang Lam on 27/09/2021.
//

import Foundation

final class WKTrafficManager: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        print(request.url!.absoluteString)
        if request.url!.absoluteString.contains("https://m.youtube.com/watch?") {
            NotificationCenter.default.post(name: NSNotification.Name("showDownloads"), object: nil)
        }
        
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {}
    
    override func stopLoading() {}
}
