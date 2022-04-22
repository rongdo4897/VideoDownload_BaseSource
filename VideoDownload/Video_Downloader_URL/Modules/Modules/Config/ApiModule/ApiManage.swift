//
//  ApiManage.swift
//  FFAdmin
//
//  Created by an.trantuan on 10/7/19.
//  Copyright © 2019 an.trantuan. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Reachability

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}
class ApiManage: NSObject {
    static let shared: ApiManage = ApiManage()
}

extension ApiManage {
    func request<T : Codable>(router: RouterApi, showLoading: Bool = true, autoHide: Bool = true, completion: ((_ data : ResponseServerEntity<T>) -> Void)?) {
        var returnEntity: ResponseServerEntity<T> = ResponseServerEntity()
        self.displayLoading(showLoading)
        if !Reachability.isConnectedToNetwork() {
            returnEntity.statusCode = ResponseErrorCode.NETWORK_ERROR.rawValue
            returnEntity.message = ResponseErrorCode.NETWORK_ERROR.message()
            returnEntity.data = nil
            self.hideLoading(true)
            if let block = completion {
                block(returnEntity)
            }
            return
        }
        let request = router.request()
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let data = data, error == nil else {
                    if let block = completion {
                        if let errors = error as? URLError {
                            returnEntity.data = nil
                            switch errors.code {
                            case .timedOut:
                                returnEntity.message = ResponseErrorCode.TIMEOUT.message()
                            case .notConnectedToInternet:
                                returnEntity.message = ResponseErrorCode.NETWORK_ERROR.message()
                            default:
                                returnEntity.message = ResponseErrorCode.HTTP_ERROR.message()
                            }
                        }
                        self.hideLoading(true)
                        block(returnEntity)
                    }
                    return
                }
                self.hideLoading(autoHide)

                if let httpStatus = response as? HTTPURLResponse {
                    if let block = completion {

                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if HTTPCode.success.contains(httpStatus.statusCode) {
                                if let model : ResponseServerEntity<T> = Parser.parser(data : data) {
                                    returnEntity = model
                                    returnEntity.statusCode = json["statusCode"] as? String
                                    returnEntity.message = json["message"] as? String
                                } else {
                                    returnEntity.statusCode = json["statusCode"] as? String
                                    returnEntity.message = json["message"] as? String
                                    returnEntity.data = nil
                                }
                            } else {
                                switch httpStatus.statusCode {
                                case HTTPCode.unauthorized:
                                    returnEntity.data = nil
                                default:
                                    returnEntity.statusCode = json["statusCode"] as? String
                                    returnEntity.message = json["message"] as? String
                                    returnEntity.data = nil
                                }
                            }
                        } else {
                            returnEntity.statusCode = ResponseErrorCode.JSON_ERROR.rawValue
                            returnEntity.data = nil
                            returnEntity.message = ResponseErrorCode.JSON_ERROR.message()
                        }
                        block(returnEntity)
                    }
                }
            } catch let error as NSError {
                returnEntity.message = error.description
                returnEntity.statusCode = ResponseErrorCode.UNKNOWN_ERROR.rawValue
                completion?(returnEntity)
            }
        }

        task.resume()
    }
    private func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch let myJSONError {
            debugPrint("convert to json error: \(myJSONError)")
        }
        return nil
    }

    func displayLoading(_ allow: Bool) {
        if allow {
            DispatchQueue.main.async {
                if let view = UIApplication.shared.keyWindow {
                    MBProgressHUD.showAdded(to: view, animated: true)
                }
            }
        }
    }

    func hideLoading(_ allow: Bool) {
        if allow {
            DispatchQueue.main.async {
                if let view = UIApplication.shared.keyWindow {
                    MBProgressHUD.hide(for: view, animated: true)
                }
            }
        }
    }
}

extension ApiManage {
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
