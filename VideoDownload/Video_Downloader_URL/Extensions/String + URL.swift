//
//  StringExtension.swift
//  Video_Downloader_URL
//
//  Created by Hoang Lam on 08/10/2021.
//

import Foundation

extension String {
    var isValidURL: Bool {
        guard !contains("..") else { return false }
    
        let head     = "((http|https)://)?([(w|W)]{3}+\\.)?"
        let tail     = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlRegEx = head+"+(.)+"+tail
    
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)

        return urlTest.evaluate(with: trimmingCharacters(in: .whitespaces))
    }

    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    /// Chuyển đổi 1 chuỗi string sang dạng url encoding
    func convertStringToUrlEncoding() -> String {
        var url = self
        url = url.replacingOccurrences(of: ":", with: "%3A")
        url = url.replacingOccurrences(of: "/", with: "%2F")
        url = url.replacingOccurrences(of: "@", with: "%40")
        url = url.replacingOccurrences(of: "#", with: "%23")
        url = url.replacingOccurrences(of: "$", with: "%24")
        url = url.replacingOccurrences(of: "&", with: "%26")
        url = url.replacingOccurrences(of: "+", with: "%2B")
        url = url.replacingOccurrences(of: ",", with: "%2C")
        url = url.replacingOccurrences(of: ";", with: "%3B")
        url = url.replacingOccurrences(of: "=", with: "%3D")
        url = url.replacingOccurrences(of: "?", with: "%3F")
        
        return url
    }
    
    func removeRegionTiktokLink() -> String {
        guard let url = URL(string: self), let selfHostUrl = url.host, selfHostUrl.components(separatedBy: ".")[0].contains("-") else {return self}
        
        var hostUrlArr = selfHostUrl.components(separatedBy: ".")
        let valueFirstArr = hostUrlArr[0].components(separatedBy: "-")
        hostUrlArr[0] = valueFirstArr[0]
        
        var hostUrlString = ""
        for v in hostUrlArr {
            hostUrlString += (v + ".")
        }
        
        hostUrlString.removeLast()
        
        var urlStr = self
        urlStr = urlStr.replacingOccurrences(of: selfHostUrl, with: hostUrlString)
        
        return urlStr
    }
}
