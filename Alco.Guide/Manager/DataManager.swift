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
    
    func postCurrentScheduleNotification(scheduleInfo: [String: Any]) {
            NotificationCenter.default.post(name: Notification.Name("CurrentSchedule"), object: nil, userInfo: scheduleInfo)
    }
    
    func postLocationAddedNotification(locationInfo: [String: Any]) {
        NotificationCenter.default.post(name: Notification.Name("AddedLocation"), object: nil, userInfo: locationInfo)
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
                
                postCurrentScheduleNotification(scheduleInfo: ["scheduleID": CurrentSchedule.currentScheduleID!, "scheduleName": CurrentSchedule.currentScheduleName!])
            }
        }
    }
    // MARK: Add Schedule to Schedules Collection -
    
    // MARK: - Add location to schedule and Location Collection
    func addLocationToSchedule(locationName: String, locationId: String, locationCoordinate: LocationGeometry, scheduleID: String, completion: @escaping (Error?) -> Void) {
        
        let schedulesReference = database.collection("Schedules").document(scheduleID)
            
            var scheduleLocationsData = [
                "locationsId": FieldValue.arrayUnion([locationId])
            ]
            
            schedulesReference.updateData(scheduleLocationsData) { error in
                completion(error)
        }
        
        let activitiesField = "activities.\(locationId)"
                        let scheduleActivitiesData = [
                            activitiesField: FieldValue.arrayUnion([])
                        ]
                        
        schedulesReference.updateData(scheduleActivitiesData) { error in
            completion(error)
        }
        
        let locationsReference = database.collection(locationsCollectionPath).document(locationId)
        
        var locationData: [String: Any] = [:]
            
            let geoPoint = GeoPoint(latitude: locationCoordinate.lat, longitude: locationCoordinate.lng)
            
            locationData["locationCoordinate"] = geoPoint
        
        locationData["locationName"] = locationName
        
        locationsReference.setData(locationData) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(nil)
            } else {
                print("New location added successfully")
                self.postLocationAddedNotification(locationInfo: ["scheduleName": CurrentSchedule.currentScheduleName!])
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
                    var locationsId = document.data()["locationsId"] as? [String] ?? []
                    let users = document.data()["users"] as? [String] ?? []
                    let activities = document.data()["activities"] as? [String: [String]] ?? [:]
                    
                    let dispatchGroup = DispatchGroup()
                    
                    dispatchGroup.enter()
                    
                    fetchLocationName(locationsId: locationsId) { updatedLocations in
                        
                        locationsId = updatedLocations
                        
                        print("++++\(updatedLocations)")
                        
                        print("!!!!!!!\(locationsId)")
                        dispatchGroup.leave()
                    }
                    dispatchGroup.notify(queue: .main) {
                        print("@@@@@@@@\(locationsId)")
                        
                        let scheduleInfo = ScheduleInfo(scheduleID: scheduleID, scheduleName: scheduleName, isRunning: isRunning, locations: locationsId, users: users, activities: activities)
                        
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
    
    func fetchLocationName(locationsId: [String], completion: @escaping ([String]) -> Void) {
        
        let locationsCollection = database.collection("Locations")
        
        var updatedLocations: [String] = []
        
        let group = DispatchGroup()
        
        for locationId in locationsId {
            group.enter()
            // 使用 locationId 查詢 Firestore 中的 document
            locationsCollection.document(locationId).getDocument { (documentSnapshot, error) in
                defer {
                    group.leave()
                }
                
                guard let document = documentSnapshot, document.exists else {
                    // 處理 document 不存在的情況
                    return
                }
                
                if let locationName = document.data()?["locationName"] as? String {
                    updatedLocations.append(locationName)
                    print("!!!!!@@@@@\(updatedLocations)")
                }
            }
        }
        group.notify(queue: .main) {
            completion(updatedLocations)
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
    
    func deleteLocation(scheduleID: String ) {
        
    }
    
    func deleteActivity(scheduleID: String) {
        
    }
}
