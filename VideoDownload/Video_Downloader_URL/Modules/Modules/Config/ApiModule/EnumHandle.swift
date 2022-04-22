//
//  EnumHandle.swift
//  IVM
//
//  Created by an.trantuan on 6/26/20.
//  Copyright © 2020 an.trantuan. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ResponseErrorCode : String {
    case UNKNOWN_ERROR = "unknown_error"
    case NETWORK_ERROR = "network_error"
    case TIMEOUT = "timeout"
    case HTTP_ERROR = "http_error"
    case JSON_ERROR = "json_error"
    case TOKEN_INVALID_ERROR = "token_invalid_error"
    case BUSINESS_ERROR = "business_error"
    case NO_ERROR = "no_error"
    case HTTP_4XX_ERROR = "http_4xx_error"
    case HTTP_5XX_ERROR = "http_5xx_error"
    case SERVER_MENTENANCE_ERROR = "server_mentenance_error"
    case ACCESS_TOKEN_UPDATE_ERROR = "access_token_update_error"
    case OK = "ES200"
    case FAILED = "ES201"
    case UNEXPECTED = "ES600"
    case REQUEST_INVALID = "ES601"
    case ACCOUNT_BLOCKED = "EB001"
    case ACCOUNT_DISABLED = "EB002"
    case WRONG_PASSWORD = "EB003"
    case ACCOUNT_IN_REVIEW = "EB004"
    case EMPTY_MERCHANT = "EB005"
    case ACCOUNT_NOT_ACTIVATED = "EB006"
    case EMAIL_REGISTERED = "EB105"
    case REQUEST_NOT_FOUND = "EB106"
    case TRANSACTION_INVALID = "EB201"
    case INFORMATION_INVALID = "EB100"
    case INVALID_EMAIL_OTP = "ES100"
}

extension ResponseErrorCode {
    func message() -> String {
        switch self {
        case .FAILED:
            return "Đã có lỗi xảy ra, xin thử lại!"
        case .EMAIL_REGISTERED:
            return "Email đã được sử dụng, hãy thử một địa chỉ khác!"
        case .WRONG_PASSWORD:
            return "Thông tin người dùng không đúng!"
        case .ACCOUNT_BLOCKED:
            return "Tài khoản đã bị khoá!"
        case .ACCOUNT_DISABLED:
            return "Tài khoản đã bị vô hiệu hoá!"
        case .INFORMATION_INVALID:
            return "Không thể xử lý thông tin hiện tại, vui lòng thử lại!"
        case .INVALID_EMAIL_OTP:
            return "Không tồn tại email này!"
        default:
            return "Đã có lỗi xảy ra, xin thử lại!"
        }
    }
}
struct HTTPCode {
    static let success = (200...299)
    static let created = 201
    static let unauthorized = 401
    static let forbidden = 403
    static let notFound = 404
    static let internalServer = 500
}

struct StatusCode {
    static let OK = "ES200"
    static let FAILED = "ES201"
    static let UNEXPECTED = "ES600"
    static let REQUEST_INVALID = "ES601"
    static let ACCOUNT_BLOCKED = "EB001"
    static let ACCOUNT_DISABLED = "EB002"
    static let WRONG_PASSWORD = "EB003"
    static let ACCOUNT_IN_REVIEW = "EB004"
    static let EMPTY_MERCHANT = "EB005"
    static let ACCOUNT_NOT_ACTIVATED = "EB006"
    static let EMAIL_REGISTERED = "EB105"
    static let REQUEST_NOT_FOUND = "EB106"
    static let TRANSACTION_INVALID = "EB201"
}

enum ContentType : String {
    case JSON = "application/json"

    func value() -> String? {
        switch self {
        case .JSON:
            return rawValue
        }
    }
}

//handle completion
typealias Completetion = (_ success: Bool , _ data: JSON?, _ message : String?) -> Void
