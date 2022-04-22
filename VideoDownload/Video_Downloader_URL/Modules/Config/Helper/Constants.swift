//
//  Constants.swift
//  AddContact
//
//  Created by Huong Nguyen on 3/3/21.
//

import UIKit

class Constants {
    // storyboard
    static let tabbar: String = "Tabbar"
    static let home: String = "Home"
    static let download: String = "Download"
    
    // font
    static let ralewayBlack = "Raleway-Black"
    static let ralewayBlackItalic = "Raleway-BlackItalic"
    static let ralewayBold = "Raleway-Bold"
    static let ralewayBoldItalic = "Raleway-BoldItalic"
    static let ralewayExtraBold = "Raleway-ExtraBold"
    static let ralewayExtraBoldItalic = "Raleway-ExtraBoldItalic"
    static let ralewayExtraLight = "Raleway-ExtraLight"
    static let ralewayExtraLightItalic = "Raleway-ExtraLightItalic"
    static let ralewayItalic = "Raleway-Italic"
    static let ralewayLight = "Raleway-Light"
    static let ralewayLightItalic = "Raleway-LightItalic"
    static let ralewayMedium = "Raleway-Medium"
    static let ralewayMediumItalic = "Raleway-MediumItalic"
    static let ralewayRegular = "Raleway-Regular"
    static let ralewaySemiBold = "Raleway-SemiBold"
    static let ralewaySemiBoldItalic = "Raleway-SemiBoldItalic"
    static let ralewayThin = "Raleway-Thin"
    static let ralewayThinItalic = "Raleway-ThinItalic"
}

class Define {
    static let devideId = UIDevice.current.identifierForVendor!.uuidString
    static let defaults = UserDefaults.standard
    // Tabbar
    static let bottomSpacing: CGFloat = 10
    static let tabBarHeight: CGFloat = 55
    static let horizontleSpacing: CGFloat = 30
    static let tabBarWidth: CGFloat = 280
    static let numberOfItem: Int = 2

    // font
    static func fontWithSize(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont()
    }

    //colors
    static let darkBlue = UIColor.colorFromHexString(hex: "203E36")
    static let midBlue = UIColor.colorFromHexString(hex: "698C77")
    static let belowLightGray = UIColor.colorFromHexString(hex: "DFDFDF")
    static let quiteRedColor = UIColor.colorFromHexString(hex: "DC5C5C")
    static let reuColor = UIColor.colorFromHexString(hex: "203E36")
    static let lineColor = UIColor.colorFromHexString(hex: "DFDFDF")
    static let arrowColor = UIColor.colorFromHexString(hex: "0BB793")
    static let lightGreen = UIColor.colorFromHexString(hex: "EFF2E9")
    static let blue = UIColor.colorFromHexString(hex: "389DAB")
    static let orangeColor = UIColor.colorFromHexString(hex: "E57C40")
    static let boldPinkColor = UIColor.colorFromHexString(hex: "B86170") // C5818D
    static let lightPinkColor = UIColor.colorFromHexString(hex: "C99AA2")
    static let otherBlackColor = UIColor.colorFromHexString(hex: "3B3F42")
    static let lightBlueColor = UIColor.colorFromHexString(hex: "5F8CCA")
    static let minGreenColor = UIColor.colorFromHexString(hex: "8EAFA4")
}
