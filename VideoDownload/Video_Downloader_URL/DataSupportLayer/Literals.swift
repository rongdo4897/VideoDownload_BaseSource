//
//  Literals.swift
//  Youtube_WatchAndDownload
//
//  Created by Hoang Lam on 27/09/2021.
//

import Foundation
import UIKit

/// Truy cập vào thư mục `Document` trên thiết bị
public struct Literals {
    // Lấy đường dẫn vào thư mục document
    static let documentsDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
}
