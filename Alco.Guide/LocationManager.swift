//
//  LocationManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
        }
    }
    
    // Add more location-related functions as needed
    
    // Example function to get the current user address
    func getCurrentAddress(completion: @escaping (String?) -> Void) {
        guard let currentLocation = currentLocation else {
            completion(nil)
            return
        }
        
        // Implement reverse geocoding to get the address from the location
        
        // Example code (uncomment and modify as needed):
        /*
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemark, error) in
            if let placemark = placemark?.first {
                var address = ""
                // Build the address string
                // ...
                completion(address)
            } else {
                completion(nil)
            }
        }
        */
    }
}
