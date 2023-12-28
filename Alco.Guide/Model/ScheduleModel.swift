//
//  ScheduleModel.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/17.
//

struct Schedule: Codable {
    var scheduleID: String
    var scheduleName: String
    var isRunning: Bool
    var locations: [String]
    var users: [String]
    var activities: [String: [String]]
    var locationsId: [String]?
}
