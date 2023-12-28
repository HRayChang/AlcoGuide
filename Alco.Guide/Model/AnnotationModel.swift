//
//  AnnotationModel.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/25.
//

import MapKit
import FirebaseFirestore

class CustomAnnotation: MKPointAnnotation {
    var pinTintColor: UIColor?
}

struct LocationAnnotationInfo {
    let locationId: String
    let locationName: String
    let locationCoordinate: GeoPoint
}
