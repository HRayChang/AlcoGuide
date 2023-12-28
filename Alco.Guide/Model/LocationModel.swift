//
//  LocationModel.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/25.
//

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
