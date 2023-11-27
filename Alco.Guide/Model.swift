//
//  ScheduleID.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/17.
//

import Foundation
import FirebaseFirestore
import MapKit

struct ScheduleInfo: Codable {
    var scheduleID: String
    var scheduleName: String
    var isRunning: Bool
    var locations: [String]
    var users: [String]
    var activities: [String: [String]]
    var locationsId: [String]?
}

struct Location: Codable {
    var places: [LocationItems]
}

struct LocationItems: Codable {
    let id: String
    let displayName: DisplayName
    let location: LocationCoordinate
}

struct LocationCoordinate: Codable {
    let latitude, longitude: Double
}

struct DisplayName: Codable {
    let text: String
}

struct SelectedLocation: Codable {
    let result: LocationInfo
}

struct LocationInfo: Codable {
    
    let formattedAddress: String
    let internationalPhoneNumber, name: String
    let openingHours: OpeningHours
    let photos: [Photo]
    let rating: Double
    let reviews: [Review]
    let placeID: String
    let geometry: Geometry
    
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case internationalPhoneNumber = "international_phone_number"
        case name
        case openingHours = "opening_hours"
        case photos
        case rating, reviews
        case placeID = "place_id"
        case geometry
    }
}

struct Geometry: Codable {
    let location: LocationGeometry
}

struct LocationGeometry: Codable {
    let lat, lng: Double
}

struct OpeningHours: Codable {
    let weekdayText: [String]
    
    enum CodingKeys: String, CodingKey {
        case weekdayText = "weekday_text"
    }
}

struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}


struct Review: Codable {
    let authorName: String
    let authorURL: String
    let language, originalLanguage: String
    let profilePhotoURL: String
    let rating: Int
    let relativeTimeDescription, text: String
    let time: Int
    let translated: Bool
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case authorURL = "author_url"
        case language
        case originalLanguage = "original_language"
        case profilePhotoURL = "profile_photo_url"
        case rating
        case relativeTimeDescription = "relative_time_description"
        case text, time, translated
    }
}
