//
//  DataManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import Foundation
import MapKit
import FirebaseFirestore

class DataManager {
    
    static let shared = DataManager()
    
    private let database = Firestore.firestore()
    
    private let schedulesCollectionPath = "Schedules"
    
    private let locationsCollectionPath = "Locations"
    
    var runningSchedules: [ScheduleInfo] = []
    var finishedSchedules: [ScheduleInfo] = []
    
    func postScheduleAddedNotification(scheduleInfo: [String: Any]) {
        NotificationCenter.default.post(name: Notification.Name("CurrentSchedule"), object: nil, userInfo: scheduleInfo)
    }
    
    // MARK: - Add Schedule to Schedules Collection
    func addNewSchedule(scheduleName: String, completion: @escaping (String?) -> Void) {
        let data: [String: Any] = [
            "scheduleName": scheduleName,
            "isRunning": true,
            "users": [String](),
            "locations": [String](),
            "activities": [String: [Any]]()
        ]
        
        let scheduleReference = database.collection(schedulesCollectionPath).document()
        
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
    // MARK: Add Schedule to Schedules Collection -
    
    // MARK: - Add location to schedule and Location Collection
    func addLocationToSchedule(locationCoordinate: CLLocationCoordinate2D?, locationName: String?, locationPhoneNumber: String?, scheduleID: String, completion: @escaping (Error?) -> Void) {
        
        let schedulesReference = database.collection("Schedules").document(scheduleID)
        
        if let locationName = locationName {
            
            var scheduleLocationsData = [
                "locations": FieldValue.arrayUnion([locationName])
            ]
            
            schedulesReference.updateData(scheduleLocationsData) { error in
                completion(error)
            }
            
        }
        
        guard let locationName = locationName else { return }
        let activitiesField = "activities.\(locationName)"
                        let scheduleActivitiesData = [
                            activitiesField: FieldValue.arrayUnion([])
                        ]
                        
        schedulesReference.updateData(scheduleActivitiesData) { error in
            completion(error)
        }
        
        let locationsReference = database.collection(locationsCollectionPath).document(locationPhoneNumber ?? "N/A PhoneNumber")
        
        var locationData: [String: Any] = [:]
        
        if let coordinate = locationCoordinate {
            
            let geoPoint = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            locationData["locationCoordinate"] = geoPoint
        }
        
        locationData["locationName"] = locationName
        
        locationsReference.setData(locationData) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(nil)
            } else {
                print("New location added successfully")
            }
        }
    }
    // MARK: Add location to Schedule and Location Collection -
    
    // MARK: - Add activities to schedule's location
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
    // MARK: Add activities to schedule's location -
    
    // MARK: - Fetch Schedules info
    func fetchSchedules(completion: @escaping (Bool) -> Void) {
        
        let schedulesReference = database.collection(schedulesCollectionPath)
        
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
                    let locations = document.data()["locations"] as? [String] ?? []
                    let users = document.data()["users"] as? [String] ?? []
                    let activities = document.data()["activities"] as? [String : [String]] ?? [:]
                    
                    let scheduleInfo = ScheduleInfo(scheduleID: scheduleID, scheduleName: scheduleName, isRunning: isRunning, locations: locations, users: users, activities: activities)
                    
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
    // MARK: Fetch Schedules info -
    
    // MARK: - Delete Schedule from Schedules Collection
    func deleteSchedule(scheduleID: String) {
         
        let scheduleReference = database.collection(schedulesCollectionPath)
         
        scheduleReference.document(scheduleID).delete { error in
             if let error = error {
                 print("Error deleting schedule: \(error.localizedDescription)")
             } else {
                 print("Schedule deleted successfully")
             }
         }
     }
    // MARK: Delete Schedule from Schedules Collection -
    
    // MARK: - Set Schedule from Running to Finished
    func finishSchedule(for scheduleID: String, isRunning: Bool, completion: @escaping (Error?) -> Void) {
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)

        scheduleReference.updateData(["isRunning": isRunning]) { error in
            completion(error)
        }
    }
    // MARK: Set Schedule from Running to Finished -
}
