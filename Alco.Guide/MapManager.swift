//
//  MapManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import MapKit

class MapManager: NSObject, MKMapViewDelegate {
    
    static let shared = MapManager()
    
    func searchForPlaces(query: String, region: MKCoordinateRegion, completion: @escaping (Result<[MKPointAnnotation], Error>) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        
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
    
    func getMapItem(for annotation: MKAnnotation, completion: @escaping (MKMapItem?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = annotation.title ?? ""
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let mapItem = response?.mapItems.first, error == nil else {
                if let error = error {
                    print(error)
                }
                return
            }
            completion(mapItem)
        }
    }
}
