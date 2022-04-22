//
//  Constants.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/12/21.
//

import UIKit

class Constants {
    static let formatter = NumberFormatter()
    // Storyboard
    static let authentication = "Authentication"
    static let tabbar = "Tabbar"
    static let home = "Home"
    static let plan = "Plan"
    static let profile = "Profile"
    static let intro = "Intro"

    // Id Viewcontroller
    static let homeController = "HomeViewController"
    static let recommendController = "RecommendDetailsViewController"
    static let detailsBottomSheet = "DetailsBottomSheetViewController"

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
    
    static let delete = "Delete"
    static let edit = "Edit"
    static let accessToken = "accessToken"
    static let timeOut = TimeInterval(10)
    static let message = "Message"
    static let confirm = "Confirm"
    static let wrong = "Something wrong"
    static let authorization = "Authorization"
    static let xAuth = "x-auth-token"

    // tabbar
    static let homeTab = "Home".localized()
    static let planTab = "Plan".localized()
    static let profileTab = "Profile".localized()

}

class Defined {
    static let devideId = UIDevice.current.identifierForVendor!.uuidString
    static let defaults = UserDefaults.standard
    // Tabbar
    static let bottomSpacing: CGFloat = 20
    static let tabBarHeight: CGFloat = 55
    static let horizontleSpacing: CGFloat = 30
    static let tabBarWidth: CGFloat = 280
    static let numberOfItem: Int = 3

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

class HomeConstant {
    // Home
    static let bannerHeight: CGFloat = 195
    static let planHeight: CGFloat = 315
    static let forYouHeight: CGFloat = 225
    static let hotPlacesHeight: CGFloat = 275
    static let discoverNewHeight: CGFloat = 400
    static let forYouCellHeight: CGFloat = 160
    static let forYouCellWidth: CGFloat = 135
    static let lineSpacing: CGFloat = 15
    static let hotPlacesCellHeight: CGFloat = 210
    static let hotPlacesCellWidth: CGFloat = 150
    static let discoverNewCellHeight: CGFloat = 355
    static let discoverNewCellWidth: CGFloat = 200
    static let bannerCellHeight: CGFloat = 180
    static let lineSpacingCell: CGFloat = 0
    static let recommendCellHeight: CGFloat = 260
    static let lineSpacingRecommend: CGFloat = 5

    // List recommend
    static let forYou = "For You".localized()
    static let hotPlaces = "Hot Places".localized()
    static let discoverNew = "Discover New".localized()
    static let seeAll = "See All >".localized()
    static let ongoingMessage = "You are on a trip to".localized()
    static let doneMessage = "You have just completed a trip to".localized()
    static let onDay = "On day".localized()
    static let startingToday = "Starting today".localized()
    static let enDay = "Ending day".localized()
    static let day = "day".localized()
    static let days = "days".localized()
    static let dayLeft = "day left".localized()
    static let daysLeft = "days left".localized()
    static let viewDetails = "View Details".localized()
    static let shareNow = "Share Now".localized()
    static let budget = "Budget".localized()
    static let recommend = "Recommend".localized()
    static let search = "Search location...".localized()
}

class PlanConstant {
    // Plan
    static let ongoingCellHeight: CGFloat = 340
    static let plannedCellHeight: CGFloat = 275
    static let pastCellHeight: CGFloat = 560
    static let pastCollectionHeight: CGFloat = 220
    static let headerCellHeight: CGFloat = 220
    static let plannedCollectionHeight: CGFloat = 200
    static let plannedCollectionWidth: CGFloat = 155
    static let scheduleWithNoteCell: CGFloat = 185
    static let sheduleNoNoteCell: CGFloat = 145
    static let lineSpacingCell: CGFloat = 20

    // font
    static func fontWithSize(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont()
    }

    // List trips
    static let headerListCell: CGFloat = 55
    static let listCellHeight: CGFloat = 120

    static let seeAll = "See All >".localized()
    static let onDay = "On day".localized()
    static let startingToday = "Starting today".localized()
    static let enDay = "Ending day".localized()
    static let day = "day".localized()
    static let days = "days".localized()
    static let dayLeft = "day left".localized()
    static let daysLeft = "days left".localized()
    static let search = "Search location...".localized()
    static let listTrips = "List Trips".localized()
    static let afewDay = "a few days ago".localized()
    static let weekAgo = "week ago".localized()
    static let weeksAgo = "weeks ago".localized()
    static let monthAgo = "month ago".localized()
    static let monthsAgo = "months ago".localized()
    static let yearAgo = "year ago".localized()
    static let yearsAgo = "years ago".localized()
    static let ongoing = "On-Trip".localized()
    static let future = "Planning".localized()
    static let past = "Past".localized()
    static let startTrip = "Create Trip".localized()
    static let createTripMess = "Let create your trip now.".localized()
    static let noTripMessage = "You haven’t any trip".localized()
    static let myTrip = "My Trip".localized()
}

class ProfileConstant {
    // Profile
    static let profileCell: CGFloat = 110
    static let actionCell: CGFloat = 70
    static let detailsCell: CGFloat = 65
    static let numberOfDetailsCell: CGFloat = 5
    static let bottomSpacing: CGFloat = 20
    
    static let profile = "Profile".localized()
    static let memberDate = "Member from date:".localized()
    static let account = "Account".localized()
    static let accountMess = "View, edit details".localized()
    static let help = "Help & Support".localized()
    static let helpMess = "Help, FAQ".localized()
    static let setting = "Settings".localized()
    static let settingMess = "Block, allow receive push notification".localized()
    static let about = "About".localized()
    static let aboutMess = "Know about app".localized()
    static let logout = "Logout".localized()
    static let logoutMess = "Logout from app".localized()
    static let name = "Name".localized()
    static let phone = "Phone number".localized()
    static let email = "Email".localized()
    static let date = "Date of birth".localized()
    static let gender = "Gender".localized()
    static let male = "Male".localized()
    static let female = "Female".localized()
    static let other = "Other".localized()
    static let save = "Save".localized()
    static let accountDetails = "Account Details".localized()
    static let signIn = "Sign In".localized()
    static let welcome = "Welcome to Traveldy".localized()


}

class IntroConstant {
    static let plan = "Planning"
    static let travel = "Traveling"
    static let share = "Sharing"
    static let planMess = "The process of making plans for something."
    static let travelMess = "Traveling is the movement of people between distant geographycial locations"
    static let shareMess = "Sharing plan"
    static let skipButton = "Skip"
    static let nextButton = "Next"
    static let doneButton = "Done"

    static let numberOfItem: Int = 3
}

class AuthenticationConstant {
    static let fb = "Connect with Facebook"
    static let gg = "Connect with Google"
    static let apple = "Sign in with Apple"
    static let sologan = "Let's do some Traveldy"
    static let createMess = "create an account to get started"

    static let imgTopConstraint: CGFloat = 40
    static let imgTopConstraint2: CGFloat = 20
    static let topConstraint: CGFloat = 100
    static let topConstraint2: CGFloat = 50
}
