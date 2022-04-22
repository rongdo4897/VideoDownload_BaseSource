//
//  ApiRouter.swift
//  IVM
//
//  Created by an.trantuan on 6/29/20.
//  Copyright © 2020 an.trantuan. All rights reserved.
//

import UIKit
import Foundation

enum RouterApi {
    case getPlan(id: String)
    case getItinerary(id: String)
    case getListPlan
}

extension RouterApi {
    func request() -> URLRequest {
        var method : HTTPMethod {
            switch self {
            case .getPlan:
                return .get
            case .getItinerary:
                return .get
            case .getListPlan:
                return .get
            }
        }

        let params: ([String: Any]?) = {
            var param = [String: Any]()
            switch self {
            case .getPlan:
                param = [:]
            case .getItinerary:
                param = [:]
            case .getListPlan:
                param = [:]
            }
            return param
        }()

        let url: String = {
            var relativePath: String = ""
            switch self {
            case .getPlan(let id):
                relativePath = String(format: ApiClient.getPlan, arguments: [id.description])
            case .getItinerary(let id):
                relativePath = String(format: ApiClient.getItinerary, arguments: [id.description])
            case .getListPlan:
                relativePath = ApiClient.getListPlan
            }
            return relativePath
        }()
        
        var urlRequest = URLRequest(url: URL(string: "\(Environment.rootURL)\(url)")!)
        var header : [String : String] = [:]
        header["X-CmdId"] = Defined.devideId
        header["X-Timezone-Offset"] = TimeZone.current.timeZoneOffsetInMinutes().description
        header["Content-Type"] = "application/json"
        switch method {
        case .get:
            if let param = params?.stringFromHttpParameters() {
                urlRequest = URLRequest(url: URL(string: "\(Environment.rootURL)\(url)\(param)")!)
            } else {
                urlRequest = URLRequest(url: URL(string: "\(Environment.rootURL)\(url)")!)
            }
            urlRequest.httpMethod = HTTPMethod.get.rawValue
        case .post, .put, .delete:
            urlRequest = URLRequest(url: URL(string: "\(Environment.rootURL)\(url)")!)
            if let param = params {
                do {
                    let bodyData = try JSONSerialization.data(withJSONObject: param, options:[])
                    urlRequest.httpBody = bodyData
                } catch {
                    debugPrint("Api Manage -- JSONSerialization Exception")
                }
            }
            urlRequest.httpMethod = method.rawValue
        default:
            break
        }
        urlRequest.allHTTPHeaderFields = header
        urlRequest.timeoutInterval = Constants.timeOut
        return urlRequest
    }
}
