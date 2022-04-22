//
//  PlanModels.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 14/04/2021.
//

import Foundation

struct DayTitle {
    var title: String
    var dateString: String
    var isHightlighted: Bool
}

struct ItineraryModel {
    var no: Int
    var from: String
    var to: String
    var imageUrl: String
    var tripName: String
    var budget: String
    var note: String?
}

struct PlanModel : Codable {
    var id: String?
    var title: String?
    var start: String?
    var end: String?
    var place: PlaceAttribute?
    var budget: Double?
    var status: String?
}

struct PlaceAttribute : Codable {
    var place_name: String?
    var longtitude: Double?
    var latitude: Double?
}
