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
            "locationsId": [String](),
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
        let locationRef = database.collection("Schedules").document(scheduleID)
        
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
                    
                        dispatchGroup.leave()
                    }
                    dispatchGroup.notify(queue: .main) {
                        
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
            
            locationsCollection.document(locationId).getDocument { (documentSnapshot, error) in
                defer {
                    group.leave()
                }
                
                guard let document = documentSnapshot, document.exists else {
          
                    return
                }
                
                if let locationName = document.data()?["locationName"] as? String {
                    updatedLocations.insert(locationName, at: 0)
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
    
    func updateLocationOrder(sourceIndexPath: Int, destinationIndexPath: Int, scheduleID: String) {
        
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)
        
        scheduleReference.getDocument { (document, error) in
            if let document = document, document.exists {
                // 取得目前的 locationId 陣列
                var currentLocationId = document.get("locationsId") as? [String] ?? []
            
                // 確保 sourceIndexPath 和 destinationIndexPath 在有效範圍內
                guard sourceIndexPath < currentLocationId.count, destinationIndexPath < currentLocationId.count else {
                    print("Invalid index paths.")
                    return
                }
                
                // 移動 sourceIndexPath 的值到 destinationIndexPath
                let removedValue = currentLocationId.remove(at: sourceIndexPath)
                currentLocationId.insert(removedValue, at: destinationIndexPath)
                
                // 更新 Firestore 文檔中的 locationId 字段
                scheduleReference.updateData(["locationsId": currentLocationId]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated")
                        
                        NotificationCenter.default.post(name: Notification.Name("UpdateLocationOrder"), object: nil, userInfo: nil)
                        
                    }
                }
                
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func deleteLocation(scheduleID: String, locationIndex: Int) {
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)
        
        scheduleReference.getDocument { (document, error) in
            if let document = document, document.exists {
                // 从文档中获取locationsId字段的值（假设是一个数组）
                var locationsId = document.data()?["locationsId"] as? [String] ?? []
                
                // 检查locationIndex是否有效
                if locationIndex >= 0 && locationIndex < locationsId.count {
                    // 记录要删除的值
                    let deletedValue = locationsId[locationIndex]
                    
                    // 删除数组中的指定索引位置的元素
                    locationsId.remove(at: locationIndex)
                    
                    // 更新文档数据
                    scheduleReference.updateData(["locationsId": locationsId]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            // 打印已删除的值
                            print("Deleted value: \(deletedValue)")
                            print("Document successfully updated")
                            
                            // 获取activities字段的值（假设是一个字典）
                            var activities = document.data()?["activities"] as? [String: Any] ?? [:]
                            
                            // 删除activities中特定键的条目
                            activities.removeValue(forKey: deletedValue)
                            
                            // 更新文档中的activities字段
                            scheduleReference.updateData(["activities": activities]) { error in
                                if let error = error {
                                    print("Error updating activities: \(error)")
                                } else {
                                    print("Activities successfully updated")
                                }
                            }
                        }
                    }
                } else {
                    print("Invalid locationIndex")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func deleteActivity(scheduleID: String) {
        
    }
}
