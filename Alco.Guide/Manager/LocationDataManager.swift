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

    func addNewSchedule(scheduleName: String, completion: @escaping (String?) -> Void) {
        let data: [String: Any] = [
            "scheduleName": scheduleName
        ]

        let scheduleReference = database.collection("Schedules").document()

        scheduleReference.setData(data) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(nil)
            } else {
                print("New schedule added successfully")

                completion(scheduleReference.documentID)

                ScheduleID.scheduleID = scheduleReference.documentID
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

        database.collection("Schedules").document(scheduleID).updateData(data) { error in
            completion(error)
        }
    }
}
