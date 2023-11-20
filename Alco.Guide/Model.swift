//
//  ScheduleID.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/17.
//

import Foundation
import FirebaseFirestore

struct CurrentSchedule {
    static var currentScheduleID: String?
    static var currentScheduleName: String?
    static var currentIsRunnung: Bool?
    static var currentLocations: [String: GeoPoint]?
}

struct ScheduleInfo: Codable {
    var scheduleID: String?
    var scheduleName: String?
    var isRunning: Bool?
    var locations: [String: GeoPoint]?

    
    init(scheduleID: String?, scheduleName: String?, isRunning: Bool?, locations: [String: GeoPoint]?) {
        self.scheduleID = scheduleID
        self.scheduleName = scheduleName
        self.isRunning = isRunning
        self.locations = locations
    }
}

struct Location: Codable {
    var locationCoordinate: GeoPoint?
}
