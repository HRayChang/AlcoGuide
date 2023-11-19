//
//  ScheduleID.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/17.
//

import Foundation

struct ScheduleInfo {
    var scheduleID: String?
    var scheduleName: String?
    var isRunnung: Bool?
    
    init(scheduleID: String?, scheduleName: String?, isRunning: Bool?) {
        self.scheduleID = scheduleID
        self.scheduleName = scheduleName
        self.isRunnung = isRunning
    }
}

struct Situation {
    static var runningSchedules: [ScheduleInfo] = []
    static var finishedSchedules: [ScheduleInfo] = []
}