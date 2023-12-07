//
//  DataManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import Foundation
import MapKit
import FirebaseFirestore

enum ArrayType {
    case running
    case finished
}

class DataManager {
    
    static let shared = DataManager()
    
    private let database = Firestore.firestore()
    
    private let schedulesCollectionPath = "Schedules"
    
    private let locationsCollectionPath = "Locations"
    
    var runningSchedules: [ScheduleInfo] = []
    var finishedSchedules: [ScheduleInfo] = []
    
    struct CurrentSchedule {
        static var currentIndex: Int? {
            didSet {
                updateCurrentData()
            }
        }
        
        static var currentArrayType: ArrayType?
        static var currentScheduleID: String?
        static var currentScheduleName: String?
        static var currentIsRunnung: Bool?
        static var currentLocations: [String]?
        static var currentLocationsId: [String]?
        static var currentUsers: [String]?
        static var currentActivities: [String: [String]]?
        static var currentLocationCooredinate: [GeoPoint]?
        // Add other variables
        
        static func updateCurrentData() {
            if let index = currentIndex, let type = currentArrayType {
                switch type {
                case .running:
                    currentScheduleID = DataManager.shared.runningSchedules[index].scheduleID
                    currentScheduleName = DataManager.shared.runningSchedules[index].scheduleName
                    currentIsRunnung = DataManager.shared.runningSchedules[index].isRunning
                    currentLocations = DataManager.shared.runningSchedules[index].locations
                    currentLocationsId = DataManager.shared.runningSchedules[index].locationsId
                    currentUsers = DataManager.shared.runningSchedules[index].users
                    currentActivities = DataManager.shared.runningSchedules[index].activities
                case .finished:
                    currentScheduleID = DataManager.shared.finishedSchedules[index].scheduleID
                    currentScheduleName = DataManager.shared.finishedSchedules[index].scheduleName
                    currentIsRunnung = DataManager.shared.finishedSchedules[index].isRunning
                    currentLocations = DataManager.shared.finishedSchedules[index].locations
                    currentLocationsId = DataManager.shared.finishedSchedules[index].locationsId
                    currentUsers = DataManager.shared.finishedSchedules[index].users
                    currentActivities = DataManager.shared.finishedSchedules[index].activities
                    
                }
            }
        }
        
        // Example function to update current index and array type
        static func updateCurrentIndex(to index: Int, arrayType: ArrayType) {
            currentArrayType = arrayType
            currentIndex = index
        }
        
        private init() {
            CurrentSchedule.updateCurrentData()
        }
    }
    
    
    func postCurrentScheduleNotification(scheduleInfo: [String: Any]) {
        NotificationCenter.default.post(name: Notification.Name("CurrentSchedule"), object: nil, userInfo: scheduleInfo)
    }
    
    func firestoreObserver() {
        
        let docRef = Firestore.firestore().collection("Schedules").document(DataManager.CurrentSchedule.currentScheduleID!)
        
        docRef.addSnapshotListener { (document, error) in
            guard let document = document, document.exists else {
                print("文档不存在")
                return
            }
            
            if let locationsIdValue = document.get("locationsId") as? [String] {
                CurrentSchedule.currentLocationsId = locationsIdValue
                self.fetchLocationName(locationsId: locationsIdValue) { locationsName in
                    CurrentSchedule.currentLocations = locationsName
                }
            }

            if let activitiesValue = document.get("activities") as? [String: [String]] {
                CurrentSchedule.currentActivities = activitiesValue
            }

            if let usersValue = document.get("users") as? [String] {
                CurrentSchedule.currentUsers = usersValue
            }
            
            if let isRunningValue = document.get("isRunning") as? Bool {
                CurrentSchedule.currentIsRunnung = isRunningValue
            }

            if document.get("locationsId") == nil && document.get("activities") == nil && document.get("users") == nil {
                print("No fields exist")
            }
//            
//            self.fetchSchedules {_ in
            
            
//                CurrentSchedule.updateCurrentData()
                
//            }

            NotificationCenter.default.post(name: Notification.Name("Updatefirestore"), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name("FirestoreObserver"), object: nil, userInfo: nil)
        }
       
    }
    
    // MARK: - Add Schedule to Schedules Collection
    func addNewSchedule(scheduleName: String, completion: @escaping (String?) -> Void) {
        var scheduleId = ""

        guard let userEmail = LoginViewController().userInfo?.email else { return }
        
        let data: [String: Any] = [
            "scheduleName": scheduleName,
            "isRunning": true,
            "users": [userEmail],
            "locationsId": [String](),
            "activities": [String: [Any]]()
        ]

        let scheduleReference = database.collection(schedulesCollectionPath).document()

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()

        scheduleReference.setData(data) { [self] error in
            defer {
                dispatchGroup.leave()
            }
            
            if let error = error {
                print("Error adding document: \(error)")
                completion(nil)
            } else {
                print("New schedule added successfully")

                scheduleId = scheduleReference.documentID

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

        dispatchGroup.notify(queue: .main) {
            
            guard let userUID = LoginViewController().userInfo?.userUID else { return }
            
            let userRef = self.database.collection("Users").document(userUID)

            let schedulesUpdate = [ "schedules": FieldValue.arrayUnion([self.database.collection("Schedules").document(scheduleId)]) ]

            userRef.setData(schedulesUpdate, merge: true) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }

    // MARK: Add Schedule to Schedules Collection -
    
    func addScheduleToUser() {
        
    }
    
    // MARK: - Add location to schedule and Location Collection
    func addLocationToSchedule(locationName: String, locationId: String, locationCoordinate: LocationGeometry, scheduleID: String, completion: @escaping (Error?) -> Void) {

        let schedulesReference = database.collection("Schedules").document(scheduleID)

        database.runTransaction({ [self] (transaction, errorPointer) -> Any? in
            do {
                // Get the latest snapshot of the schedule document
                let scheduleDocument = try transaction.getDocument(schedulesReference)
                
                // Update the locationsId array
                var scheduleLocationsData = scheduleDocument.data() ?? [:]
                if var locationsIdArray = scheduleLocationsData["locationsId"] as? [String] {
                    locationsIdArray.append(locationId)
                    scheduleLocationsData["locationsId"] = locationsIdArray
                    transaction.updateData(scheduleLocationsData, forDocument: schedulesReference)
                }

                // Update the activities field
                let activitiesField = "activities.\(locationName)"
                var scheduleActivitiesData = scheduleDocument.data() ?? [:]
                if var activitiesArray = scheduleActivitiesData[activitiesField] as? [Any] {
                    activitiesArray.append(contentsOf: []) // Add your desired data to the array
                    scheduleActivitiesData[activitiesField] = activitiesArray
                    transaction.updateData(scheduleActivitiesData, forDocument: schedulesReference)
                }
                
                // Create or update the location document
                let locationsReference = database.collection(locationsCollectionPath).document(locationId)
                var locationData: [String: Any] = [:]
                let geoPoint = GeoPoint(latitude: locationCoordinate.lat, longitude: locationCoordinate.lng)
                locationData["locationCoordinate"] = geoPoint
                locationData["locationName"] = locationName
                transaction.setData(locationData, forDocument: locationsReference)
                
                return nil
            } catch let fetchError as NSError {
                // Handle any errors during the transaction by returning an error
                errorPointer?.pointee = fetchError
                return nil
            }
        }) { (_, error) in
            // Completion block
            if let error = error {
                print("Transaction failed: \(error)")
                completion(error)
            } else {
                print("Transaction succeeded!")
                CurrentSchedule.currentLocations?.append(locationName)
                CurrentSchedule.currentLocationsId?.append(locationId)
                    NotificationCenter.default.post(name: Notification.Name("UpdateLocation"), object: nil, userInfo: nil)
                completion(nil)
            }
        }
    }
    // MARK: Add location to Schedule and Location Collection -
    
    // MARK: - Add activities to schedule's location
    func addActivities(scheduleID: String, locationName: String, text: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let locationRef = database.collection("Schedules").document(scheduleID)

        // Start a Firestore transaction
        database.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let document = try transaction.getDocument(locationRef)
                
                guard document.exists else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])
                    throw error
                }
                
                var data = document.data()
                var activities = data?["activities"] as? [String: [String]] ?? [:]

                var activity = activities[locationName, default: []]

                activity.append(text)

                activities[locationName] = activity

                transaction.updateData(["activities": activities], forDocument: locationRef)

                // Return any value to signal success of the transaction
                return "Transaction success"
            } catch let fetchError as NSError {
                // Handle any errors that occurred during the fetch
                errorPointer?.pointee = fetchError
                return nil
            }
        }) { (result, error) in
            if let error = error {
                print("Transaction failed: \(error)")
                completion(.failure(error))
            } else {
                print("Transaction successfully committed!")
                NotificationCenter.default.post(name: Notification.Name("UpdateActivityOrder"), object: nil, userInfo: nil)
                completion(.success(()))
            }
        }
    }
    // MARK: Add activities to schedule's location -
    
    func checkScheduleExit(scheduleId: String) {
        let schedulesReference = database.collection(schedulesCollectionPath).document(scheduleId)
        
        schedulesReference.getDocument { (document, error) in
            if let document = document, document.exists {
                self.assignSchedulesToUser(documentId: scheduleId)
            } else {
                // 文档不存在或出现错误
                if let error = error {
                    print("Error getting document: \(error)")
                }
            }
        }
    }
    
    func assignSchedulesToUser(documentId: String) {
        let myReference = database.collection("Schedules").document(documentId)

        guard let userUID = LoginViewController().userInfo?.userUID else { return }
        
        let documentReference = database.collection("Users").document(userUID)

        documentReference.getDocument { (document, error) in
            if let document = document, document.exists {

                let data = document.data()

                if var currentArray = data?["schedules"] as? [DocumentReference] {

                    // Check if newData already exists in currentArray
                    if !currentArray.contains(myReference) {
                        currentArray.append(myReference)

                        // Update the array in the document
                        documentReference.setData(["schedules": currentArray], merge: true) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    } else {
                        print("Schedule already exists in the array")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }

    
    // MARK: - Fetch Schedules info
    func fetchSchedules(completion: @escaping (Bool) -> Void) {
        
        guard let userUID = LoginViewController().userInfo?.userUID else { return }
        
        let schedulesReference = database.collection("Users").document(userUID)
        
        schedulesReference.getDocument { (document, error) in
            
            if let document = document, document.exists {
                
                let data = document.data()
                
                if let fieldValue = data?["schedules"] as? [DocumentReference] {
                    
                    for reference in fieldValue {
                        
                        reference.getDocument { (refDocument, refError) in
                            
                            if let refDocument = refDocument, refDocument.exists {
                                
                                let scheduleID = refDocument.documentID
                                let scheduleName = refDocument.data()?["scheduleName"] as? String ?? "Unknown"
                                let isRunning = refDocument.data()?["isRunning"] as? Bool ?? false
                                let locationsId = refDocument.data()?["locationsId"] as? [String] ?? []
                                let users = refDocument.data()?["users"] as? [String] ?? []
                                let activities = refDocument.data()?["activities"] as? [String: [String]] ?? [:]
                                
                                self.runningSchedules.removeAll()
                                self.finishedSchedules.removeAll()
                                
                                self.fetchLocationName(locationsId: locationsId) { updatedLocations in
                                    
                                    let scheduleInfo = ScheduleInfo(scheduleID: scheduleID,
                                                                    scheduleName: scheduleName,
                                                                    isRunning: isRunning,
                                                                    locations: updatedLocations,
                                                                    users: users,
                                                                    activities: activities,
                                                                    locationsId: locationsId)
                                    
                                    // Check if the scheduleID already exists
                                    if let index = self.runningSchedules.firstIndex(where: { $0.scheduleID == scheduleID }) {
                                        // If it exists, update the information
                                        self.runningSchedules[index] = scheduleInfo
                                        print("Running schedules: \(self.runningSchedules)")
                                    } else if let index = self.finishedSchedules.firstIndex(where: { $0.scheduleID == scheduleID }) {
                                        // If it exists, update the information
                                        self.finishedSchedules[index] = scheduleInfo
                                        print("Finished schedules: \(self.finishedSchedules)")
                                    } else {
                                        // If it doesn't exist, add it to the appropriate list
                                        if isRunning {
                                            self.runningSchedules.append(scheduleInfo)
                                            print("Running schedules: \(self.runningSchedules)")
                                        } else {
                                            self.finishedSchedules.append(scheduleInfo)
                                            print("Finished schedules: \(self.finishedSchedules)")
                                        }
                                    }
                                    
                                    completion(true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchLocationName(locationsId: [String], completion: @escaping ([String]) -> Void) {
        
        let locationsCollection = database.collection("Locations")
        
        var updatedLocations: [String] = Array(repeating: "", count: locationsId.count) // Initialize with empty strings
        
        let group = DispatchGroup()
        
        for (index, locationId) in locationsId.enumerated() {
            
            group.enter()
            
            locationsCollection.document(locationId).getDocument { (documentSnapshot, error) in
                defer {
                    group.leave()
                }
                
                guard let document = documentSnapshot, document.exists else {
                    return
                }
                
                if let locationName = document.data()?["locationName"] as? String {
                    updatedLocations[index] = locationName
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(updatedLocations)
        }
    }
    


    func fetchLocationCoordinate(locationsId: [String], completion: @escaping ([LocationAnnotationInfo]) -> Void) {
        let locationsCollection = database.collection("Locations")
        var locationInfoArray = [LocationAnnotationInfo]()
        
        let dispatchGroup = DispatchGroup()

        for locationId in locationsId {
            dispatchGroup.enter()

            locationsCollection.document(locationId).getDocument { (documentSnapshot, error) in
                defer {
                    dispatchGroup.leave()
                }

                guard let document = documentSnapshot, document.exists else { return }

                if let locationCoordinate = document.data()?["locationCoordinate"] as? GeoPoint,
                   let locationName = document.data()?["locationName"] as? String {
                    
                    let locationInfo = LocationAnnotationInfo(locationId: locationId, locationName: locationName, locationCoordinate: locationCoordinate)
                    locationInfoArray.insert(locationInfo, at: 0)
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(locationInfoArray)
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
    
    func updateLocationOrder(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath, scheduleID: String) {
            
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)
        
        database.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let document = try transaction.getDocument(scheduleReference)
                
                if document.exists {
                    // 取得目前的 locationId 陣列
                    var currentLocationId = document.get("locationsId") as? [String] ?? []
                    
                    // 確保 sourceIndexPath 和 destinationIndexPath 在有效範圍內
                    guard sourceIndexPath.section < currentLocationId.count, destinationIndexPath.section < currentLocationId.count else {
                        print("Invalid index paths.")
                        return nil
                    }
                    
                    // 移動 sourceIndexPath 的值到 destinationIndexPath
                    let removedValue = currentLocationId.remove(at: sourceIndexPath.section)
                    currentLocationId.insert(removedValue, at: destinationIndexPath.section)
                    
                    // 更新 Firestore 文檔中的 locationId 字段
                    transaction.updateData(["locationsId": currentLocationId], forDocument: scheduleReference)
                    
                    NotificationCenter.default.post(name: Notification.Name("UpdateLocation"), object: nil, userInfo: nil)
                    
                    return currentLocationId
                } else {
                    print("Document does not exist")
                    return nil
                }
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        }) { (result, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else if let currentLocationId = result as? [String] {
                print("Transaction successful. Updated locationsId: \(currentLocationId)")
                
//                NotificationCenter.default.post(name: Notification.Name("UpdateLocationOrder"), object: nil, userInfo: nil)
            }
        }
    }
    
    func updateActivityOrder(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath, scheduleID: String, currentLocations: [String]) {
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)

        let sourceCurrentLocation = currentLocations[sourceIndexPath.section]
        let destinationCurrentLocation = currentLocations[destinationIndexPath.section]
        
        database.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let document = try transaction.getDocument(scheduleReference)
                
                guard var activities = document.data()?["activities"] as? [String: [String]] else {
                    throw NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Activities not found in document"])
                }
                
                
                
                var sourceActivity = activities[sourceCurrentLocation] ?? []
                var destinationActivity = activities[destinationCurrentLocation] ?? []
                
                if sourceActivity == destinationActivity {
                    let sourceValue = sourceActivity.remove(at: sourceIndexPath.row - 1)
                    sourceActivity.insert(sourceValue, at: destinationIndexPath.row - 1)
                    activities[sourceCurrentLocation] = sourceActivity
                } else {
                    let sourceValue = sourceActivity.remove(at: sourceIndexPath.row - 1)
                    destinationActivity.insert(sourceValue, at: destinationIndexPath.row - 1)
                    activities[destinationCurrentLocation] = destinationActivity
                    activities[sourceCurrentLocation] = sourceActivity
                }
                
                transaction.updateData(["activities": activities], forDocument: scheduleReference)
                
                return activities
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        }) { (activities, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                if let destinationArray = activities as? [String: [String]],
                   let destinationActivity = destinationArray[destinationCurrentLocation],
                   destinationIndexPath.row - 1 < destinationActivity.count {
                    let destinationValue = destinationActivity[destinationIndexPath.row - 1]
                    print("Destination Value at IndexPath.row \(destinationIndexPath.row): \(destinationValue)")
                }
                
                print("Transaction successfully committed!")
                NotificationCenter.default.post(name: Notification.Name("UpdateActivityOrder"), object: nil, userInfo: nil)
            }
        }
    }

    
    func deleteLocation(scheduleID: String, locationIndex: Int, deletedValue: String) {
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)

        database.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let document = try transaction.getDocument(scheduleReference)

                guard var locationsId = document.data()?["locationsId"] as? [String] else {
                    errorPointer?.pointee = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "Failed to get locationsId from document"
                    ])
                    return nil
                }

                // Check if locationIndex is valid
                guard locationIndex >= 0, locationIndex < locationsId.count else {
                    errorPointer?.pointee = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "Invalid locationIndex"
                    ])
                    return nil
                }

                // Record the value to be deleted
                // let deletedValue = locationsId[locationIndex]

                // Remove the element at the specified index in the array
                locationsId.remove(at: locationIndex)

                // Update the document data
                transaction.updateData(["locationsId": locationsId], forDocument: scheduleReference)

                // Get the "activities" field value (assuming it's a dictionary)
                var activities = document.data()?["activities"] as? [String: Any] ?? [:]

                // Remove the entry with the specified key from the "activities" dictionary
                activities.removeValue(forKey: deletedValue)

                // Update the "activities" field in the document
                transaction.updateData(["activities": activities], forDocument: scheduleReference)
                
                NotificationCenter.default.post(name: Notification.Name("UpdateLocation"), object: nil, userInfo: nil)

                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction succeeded!")
            }
        }
    }

    
    func deleteActivity(scheduleID: String, currentLocations: [String], indexPath: IndexPath) {
        let scheduleReference = database.collection(schedulesCollectionPath).document(scheduleID)

        database.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let scheduleDocument = try transaction.getDocument(scheduleReference)

                guard let activities = scheduleDocument.data()?["activities"] as? [String: [String]] else {
                    return nil
                }

                let currentLocation = currentLocations[indexPath.section]

                var updatedActivities = activities
                if var activity = updatedActivities[currentLocation] {
                    activity.remove(at: indexPath.row - 1)
                    updatedActivities[currentLocation] = activity
                }

                transaction.updateData(["activities": updatedActivities], forDocument: scheduleReference)

                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction succeeded!")

                NotificationCenter.default.post(name: Notification.Name("UpdateActivityOrder"), object: nil, userInfo: nil)
            }
        }
    }

    
    func updateActivity(scheduleID: String, locationName: String, text: String, indexPath: IndexPath, completion: @escaping (Result<Void, Error>) -> Void) {
        let locationRef = database.collection("Schedules").document(scheduleID)

        database.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let document = try transaction.getDocument(locationRef)
                
                guard let data = document.data() else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])
                    throw error
                }
                
                var activities = data["activities"] as? [String: [String]] ?? [:]

                var activity = activities[locationName]

                activity?[indexPath.row - 1] = text

                activities[locationName] = activity

                transaction.updateData(["activities": activities], forDocument: locationRef)

                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        }) { (result, error) in
            if let error = error {
                print("Error updating document: \(error)")
                completion(.failure(error))
            } else {
                print("Document successfully updated")
                NotificationCenter.default.post(name: Notification.Name("UpdateActivityOrder"), object: nil, userInfo: nil)
                completion(.success(()))
            }
        }
    }

}
