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
        NotificationCenter.default.post(name: Notification.Name("CurrentSchedule"), object: nil, userInfo: scheduleInfo)
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
                
                CurrentSchedule.currentScheduleID = scheduleReference.documentID
                CurrentSchedule.currentScheduleName = scheduleName
                
                completion(scheduleReference.documentID)
                
                postScheduleAddedNotification(scheduleInfo: ["scheduleID": CurrentSchedule.currentScheduleID!, "scheduleName": CurrentSchedule.currentScheduleName!])
            }
        }
    }
    
    func addLocationToSchedule(locationCoordinate: CLLocationCoordinate2D?, locationName: String?, scheduleID: String, completion: @escaping (Error?) -> Void) {
        
        guard let locationCoordinate = locationCoordinate, let locationName = locationName else {
            let error = NSError(domain: "Invalid location coordinate or name", code: 0, userInfo: nil)
            completion(error)
            return
        }
        
        let geoPoint = GeoPoint(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        let newLocationData: [String: Any] = [locationName: geoPoint ]
        
        let field = "locations"
        
        let locationDocumentRef = database.collection(collectionPath).document(scheduleID)

        locationDocumentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, update the existing data
                locationDocumentRef.updateData([
                    "\(field).\(locationName)": geoPoint
                ]) { error in
                    completion(error)
                }
            } else {
                // Document does not exist, create a new one
                locationDocumentRef.setData([
                    field: newLocationData
                ]) { error in
                    completion(error)
                }
            }
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
                    let locations = document.data()["locations"] as? [String: GeoPoint] ?? nil
                    
                    let scheduleInfo = ScheduleInfo(scheduleID: scheduleID, scheduleName: scheduleName, isRunning: isRunning, locations: locations)
                    
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
