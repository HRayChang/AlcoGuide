//
//  MapManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import MapKit
import Alamofire
import CoreLocation

class MapManager: NSObject, MKMapViewDelegate {
    
    let coreLocationManager = CoreLocationManager.shared
    
    static let shared = MapManager()
    
    func searchNearbylocations(keyword: String, region: MKCoordinateRegion, completion: @escaping (Result<[MKPointAnnotation], Error>) -> Void) {
        do {
            let body: [String: Any] = [
                "languageCode": "zh-TW",
                "includedTypes": ["\(keyword)"],
                "maxResultCount": 10,
                "rankPreference": "DISTANCE",
                "locationRestriction": [
                    "circle": [
                        "center": ["latitude": region.center.latitude,
                                   "longitude": region.center.longitude],
                        "radius": 1000.0
                    ]
                ]
            ]
            
            let headers: [Alamofire.HTTPHeader] = [
                .contentType("application/json"),
                HTTPHeader(name: "X-Goog-FieldMask", value: "*"),
                HTTPHeader(name: "X-Goog-Api-Key", value: "AIzaSyAn8r-hayr7_mAPIquepdG6Se7dfBDDL_0")
            ]
            let request =
            AF.request("https://places.googleapis.com/v1/places:searchNearby",
                       method: .post,
                       parameters: body,
                       encoding: JSONEncoding(options: .prettyPrinted),
                       headers: HTTPHeaders(headers)
            )
            request.responseDecodable(of: Location.self) { response in
                switch response.result {
                case .success(let locaitons):
                    
                    var annotations: [CustomAnnotation] = []
                    
                    for item in locaitons.places {
                        let annotation = CustomAnnotation()
                        annotation.coordinate.latitude = item.location.latitude
                        annotation.coordinate.longitude = item.location.longitude
                        annotation.title = item.displayName.text
                        annotation.subtitle = item.id
                        annotation.pinTintColor = UIColor.eminence
                        annotations.append(annotation)
                        
                    }
                    completion(.success(annotations))
                    
                    
                case .failure(let error):
                    
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchLocationInfo(for annotation: MKAnnotation, completion: @escaping (SelectedLocation) -> Void) {
        
        let apiKey = "AIzaSyAn8r-hayr7_mAPIquepdG6Se7dfBDDL_0"
        
        let placeID = annotation.subtitle! ?? ""
        
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeID)&key=\(apiKey)&language=zh-TW"
        
        print(urlString)
        
        AF.request(urlString).responseDecodable(of: SelectedLocation.self) { response in
            switch response.result {
            case .success(let location):
                print(response)
                completion(location)

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
            
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = annotation.id ?? ""
////
//        let search = MKLocalSearch(request: request)
//        search.start { response, error in
//            guard let mapItem = response?.mapItems.first, error == nil else {
//                if let error = error {
//                    print(error)
//                }
//                return
//            }
//            completion(mapItem)
//        }
    }
}
