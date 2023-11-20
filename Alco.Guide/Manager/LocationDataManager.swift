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
            "isRunning": true,
            "users": [String]()
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

        var locationData: [String: Any] = [:]
        
        if let coordinate = locationCoordinate {
            // 將經緯度資訊轉換成 GeoPoint
            let geoPoint = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            locationData["locationCoordinate"] = geoPoint
        }
        
        locationData["activities"] = []
        
        // 在locations collection中添加新的document
        let locationsCollection = database.collection("Schedules").document(scheduleID).collection("locations").document(locationName ?? "Unknow Location Name")
        
        locationsCollection.setData(locationData) { error in
            // 處理完成後的動作
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
                    
                    // Fetch locations data
                    let locationsCollection = document.reference.collection("locations")
                    locationsCollection.getDocuments { (locationsSnapshot, locationsError) in
                        var locations: [Location] = []
                        for locationDocument in locationsSnapshot?.documents ?? [] {
                            let locationName = locationDocument.documentID
                            let coordinate = locationDocument.data()["locationCoordinate"] as? GeoPoint
                            let activities = locationDocument.data()["activities"] as? [String] ?? []
                            
                            let location = Location(locationName: locationName, coordinate: coordinate, activities: activities)
                            locations.append(location)
                        }
                        
                        let scheduleInfo = ScheduleInfo(scheduleID: scheduleID, scheduleName: scheduleName, isRunning: isRunning, locations: locations, users: [])
                        
                        if isRunning {
                            self.runningSchedules.append(scheduleInfo)
                            print("Running schedules: \(self.runningSchedules)")
                        } else {
                            self.finishedSchedules.append(scheduleInfo)
                            print("Finished schedules: \(self.finishedSchedules)")
                        }
                        
                        completion(true)
                    }
                }
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
    
    func addActivities(scheduleID: String, locationName: String, text: String, completion: @escaping (Error?) -> Void) {
            let locationRef = database.collection("Schedules").document(scheduleID).collection("locations").document(locationName)

            locationRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    var data = document.data()
                    var activities = data?["activities"] as? [String] ?? []
                    activities.append(text)
                    data?["activities"] = activities

                    locationRef.setData(data ?? [:], merge: true) { error in
                        completion(error)
                    }
                } else {
                    completion(error)
                }
            }
        }
}
