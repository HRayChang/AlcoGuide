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
                CurrentSchedule.currentLocations = []
                CurrentSchedule.currentUsers = []
                CurrentSchedule.currentActivities = [:]
                CurrentSchedule.currentLocationsId = []
                
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
        
        let activitiesField = "activities.\(locationName)"
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
                
                CurrentSchedule.currentLocations?.append(locationName)
                CurrentSchedule.currentLocationsId?.append(locationId)
                self.postLocationAddedNotification(locationInfo: ["scheduleName": CurrentSchedule.currentScheduleName!])
                
            }
        }
    }
    // MARK: Add location to Schedule and Location Collection -
    
    // MARK: - Add activities to schedule's location
    func addActivities(scheduleID: String, locationName: String, text: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let locationRef = database.collection("Schedules").document(scheduleID)
        
        locationRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var data = document.data()
                var activities = data?["activities"] as? [String: [String]] ?? [:]
                
                var activity = activities[locationName]
                
                activity?.append(text)
                
                activities[locationName] = activity
                
                locationRef.updateData(["activities": activities]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                        completion(.failure(error))
                    } else {
                        print("Document successfully updated")
                        NotificationCenter.default.post(name: Notification.Name("UpdateActivityOrder"), object: nil, userInfo: nil)
                        completion(.success(()))
                    }
                }
            } else if let error = error {
                print("Error getting document: \(error)")
                completion(.failure(error))
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
                    var locationsName = document.data()["locationsId"] as? [String] ?? []
                    let locationsId = document.data()["locationsId"] as? [String] ?? []
                    let users = document.data()["users"] as? [String] ?? []
                    let activities = document.data()["activities"] as? [String: [String]] ?? [:]
                    
                    let dispatchGroup = DispatchGroup()
                    
                    dispatchGroup.enter()
                    
                    fetchLocationName(locationsId: locationsName) { updatedLocations in
                        
                        locationsName = updatedLocations
                        
                        dispatchGroup.leave()
                    }
                    dispatchGroup.notify(queue: .main) {
                        
                        let scheduleInfo = ScheduleInfo(scheduleID: scheduleID,
                                                        scheduleName: scheduleName,
                                                        isRunning: isRunning,
                                                        locations: locationsName,
                                                        users: users,
                                                        activities: activities,
                                                        locationsId: locationsId)
                        
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
    
    func updateActivityOrder(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath, scheduleID: String, currentLocations: [String]) {
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)
        
        scheduleReference.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                var activities = document.data()?["activities"] as? [String: [String]] ?? [:]
                
                let sourceCurrentLocation = currentLocations[sourceIndexPath.section]
                let destinationCurrentLocation = currentLocations[destinationIndexPath.section]
                
                var sourceActivity = activities[sourceCurrentLocation]
                var destinationActivity = activities[destinationCurrentLocation]
                
                if sourceActivity == destinationActivity {
                    
                    let sourceValue = sourceActivity?.remove(at: sourceIndexPath.row - 1)
                    
                    sourceActivity?.insert(sourceValue!, at: destinationIndexPath.row - 1)
                    
                    activities[sourceCurrentLocation] = sourceActivity
                } else {
                    
                    let sourceValue = sourceActivity?.remove(at: sourceIndexPath.row - 1)
                    
                    destinationActivity?.insert(sourceValue!, at: destinationIndexPath.row - 1)
                    
                    activities[destinationCurrentLocation] = destinationActivity
                    activities[sourceCurrentLocation] = sourceActivity
                }
                
                scheduleReference.updateData(["activities": activities]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        
                        if let destinationArray = destinationActivity {
                            
                            let destinationValue = destinationArray[destinationIndexPath.row - 1]
                            
                            print("Destination Value at IndexPath.row \(destinationIndexPath.row): \(destinationValue)")
                        }
                        
                        print("Document successfully updated")
                        
                        NotificationCenter.default.post(name: Notification.Name("UpdateActivityOrder"), object: nil, userInfo: nil)
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func deleteLocation(scheduleID: String, locationIndex: Int, deletedValue: String) {
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)
        
        scheduleReference.getDocument { (document, error) in
            if let document = document, document.exists {
                // 从文档中获取locationsId字段的值（假设是一个数组）
                var locationsId = document.data()?["locationsId"] as? [String] ?? []
                
                // 检查locationIndex是否有效
                if locationIndex >= 0 && locationIndex < locationsId.count {
                    // 记录要删除的值
//                    let deletedValue = locationsId[locationIndex]
                    
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
    
    func deleteActivity(scheduleID: String, currentLocations: [String], indexPath: IndexPath) {
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)
        
        scheduleReference.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                var activities = document.data()?["activities"] as? [String: [String]] ?? [:]
                
                let currentLocation = currentLocations[indexPath.section]
                
                var activity = activities[currentLocation]
                
                
                activity?.remove(at: indexPath.row - 1)
                
                activities[currentLocation] = activity
                
                scheduleReference.updateData(["activities": activities]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        
                        print("Document successfully updated")
                        
                        NotificationCenter.default.post(name: Notification.Name("UpdateActivityOrder"), object: nil, userInfo: nil)
                        
                    }
                }
            }
        }
    }
    
    func updateActivity(scheduleID: String, locationName: String, text: String, indexPath: IndexPath, completion: @escaping (Result<Void, Error>) -> Void) {
        let locationRef = database.collection("Schedules").document(scheduleID)
        
        locationRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var activities = data?["activities"] as? [String: [String]] ?? [:]
                
                var activity = activities[locationName]
                
                activity?[indexPath.row - 1] = text
                
                activities[locationName] = activity
                
                locationRef.updateData(["activities": activities]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                        completion(.failure(error))
                    } else {
                        print("Document successfully updated")
                        NotificationCenter.default.post(name: Notification.Name("UpdateActivityOrder"), object: nil, userInfo: nil)
                        completion(.success(()))
                    }
                }
            } else if let error = error {
                print("Error getting document: \(error)")
                completion(.failure(error))
            }
        }
    }
}
