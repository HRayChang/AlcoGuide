//
//  MapManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import MapKit

class MapManager: NSObject {
    
    static let shared = MapManager()
    
    func searchForPlaces(query: String, mapView: MKMapView, completion: @escaping (Result<[MKPointAnnotation], Error>) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            var annotations: [MKPointAnnotation] = []
            
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                annotations.append(annotation)
            }
            
            completion(.success(annotations))
        }
    }
}
