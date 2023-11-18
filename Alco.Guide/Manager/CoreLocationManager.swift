//
//  LocationManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import CoreLocation

class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = CoreLocationManager()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    private override init() {
        super.init()
        setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            locationManager.stopUpdatingLocation()
//            currentLocation = location
//        }
//    }
}
