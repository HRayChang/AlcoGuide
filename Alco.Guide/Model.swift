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
    static var currentLocations: [String]?
    static var currentUsers: [String]?
    static var currentActivities: [String: [String]]?
}

struct ScheduleInfo: Codable {
    var scheduleID: String?
    var scheduleName: String?
    var isRunning: Bool?
    var locations: [String]?
    var users: [String]?
    var activities: [String: [String]]?

    
    init(scheduleID: String?, scheduleName: String?, isRunning: Bool?, locations: [String]?, users: [String]?, activities: [String: [String]]?) {
        self.scheduleID = scheduleID
        self.scheduleName = scheduleName
        self.isRunning = isRunning
        self.locations = locations
        self.users = users
        self.activities = activities
    }
}

struct Location: Codable {
    var locationName: String?
    var coordinate: GeoPoint?
}
