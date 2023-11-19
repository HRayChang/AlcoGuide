//
//  DataManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import Foundation
import MapKit
import FirebaseFirestore

class LocationDataManager {
    
    static let shared = LocationDataManager()
    
    private let database = Firestore.firestore()
    
    private let collectionPath = "Schedules"
    
    var runningSchedules: [ScheduleInfo] = []
    var finishedSchedules: [ScheduleInfo] = []
    
    func postScheduleAddedNotification(scheduleInfo: [String: Any]) {
        NotificationCenter.default.post(name: Notification.Name("ScheduleAdd"), object: nil, userInfo: scheduleInfo)
    }
    
    func addNewSchedule(scheduleName: String, completion: @escaping (String?) -> Void) {
        let data: [String: Any] = [
            "scheduleName": scheduleName,
            "isRunning": true
        ]
        
        let scheduleReference = database.collection(collectionPath).document()
        
        scheduleReference.setData(data) { [self] error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(nil)
            } else {
                print("New schedule added successfully")
                
                let scheduleInfo = ScheduleInfo(scheduleID: scheduleReference.documentID, scheduleName: scheduleName, isRunning: true)
                
                completion(scheduleReference.documentID)
                
                postScheduleAddedNotification(scheduleInfo: ["scheduleID": scheduleInfo.scheduleID!, "scheduleName": scheduleInfo.scheduleName!])
            }
        }
    }
    
    func addLocationToSchedule(locationCoordinate: CLLocationCoordinate2D?, scheduleID: String, completion: @escaping (Error?) -> Void) {
        
        guard let locationCoordinate = locationCoordinate else {
            let error = NSError(domain: "Invalid location coordinate", code: 0, userInfo: nil)
            completion(error)
            return
        }
        
        let geoPoint = GeoPoint(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        let data: [String: Any] = [
            "locationCoordinate": FieldValue.arrayUnion([geoPoint])
        ]
        
        database.collection(collectionPath).document(scheduleID).updateData(data) { error in
            completion(error)
        }
    }
    
    func fetchSchedules(completion: @escaping (Bool) -> Void) {
        
        let schedulesReference = database.collection(collectionPath)
        
        schedulesReference.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                runningSchedules.removeAll()
                finishedSchedules.removeAll()
                
                for document in querySnapshot!.documents {
                    let scheduleID = document.documentID
                    let scheduleName = document.data()["scheduleName"] as? String ?? "Unknown"
                    let isRunning = document.data()["isRunning"] as? Bool ?? false
                    
                    let scheduleInfo = ScheduleInfo(scheduleID: scheduleID, scheduleName: scheduleName, isRunning: isRunning)
                    
                    if isRunning {
                        runningSchedules.append(scheduleInfo)
                        print("Running schedules: \(runningSchedules)")
                    } else {
                        finishedSchedules.append(scheduleInfo)
                        print("Finished schedules: \(finishedSchedules)")
                    }
                }
                
                completion(true)
            }
        }
    }
    
    func deleteSchedule(scheduleID: String) {
         
        let scheduleReference = database.collection(collectionPath)
         
        scheduleReference.document(scheduleID).delete { error in
             if let error = error {
                 print("Error deleting schedule: \(error.localizedDescription)")
             } else {
                 print("Schedule deleted successfully")
             }
         }
     }
    
    func finishSchedule(for scheduleID: String, isRunning: Bool, completion: @escaping (Error?) -> Void) {
        let scheduleReference = database.collection(collectionPath).document(scheduleID)

        scheduleReference.updateData(["isRunning": isRunning]) { error in
            completion(error)
        }
    }
}
