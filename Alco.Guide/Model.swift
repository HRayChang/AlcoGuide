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
    static var currentLocations: [Location]?
    static var currentUsers: [String]?
}

struct ScheduleInfo: Codable {
    var scheduleID: String?
    var scheduleName: String?
    var isRunning: Bool?
    var locations: [Location]?
    var users: [String]?

    
    init(scheduleID: String?, scheduleName: String?, isRunning: Bool?, locations: [Location]?, users: [String]?) {
        self.scheduleID = scheduleID
        self.scheduleName = scheduleName
        self.isRunning = isRunning
        self.locations = locations
        self.users = users
    }
}

struct Location: Codable {
    var locationName: String?
    var coordinate: GeoPoint?
    var activities: [String]?
}
