//
//  HomeModel.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import Foundation

enum Recommened: String {
    case forYou = "FORYOU"
    case hotPlaces = "HOTPLACES"
    case discoverNew = "DISCOVERNEW"
}

enum PlanTrip: String {
    case ongoing = "ONGOING"
    case done = "DONE"
    case past = "PAST"
    case planned = "FUTURE"
}

struct HomeModel: Codable {
    var banner: [Banner]?
    var plan: Plan?
}

struct RecommendedTrip: Codable {
    var id: Int?
    var image: String?
    var name: String?
    var location: String?
    var travelers: Int?
    var content: String?
    var status: String?
    var gallery: [Banner]?
}

struct Plan: Codable {
    var id: String?
    var budget: Double?
    var start: String?
    var end: String?
    var title: String?
    var place: Place?
    var status: String?
    var imgUrl: String?
}

struct Banner: Codable {
    var id: Int?
    var image: String?
    var link: String?
}

struct Place: Codable {
    var placeName: String?
    var longitude: Double?
    var latitude: Double?
}
