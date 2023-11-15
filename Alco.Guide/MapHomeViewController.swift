//
//  ViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import MapKit

class MapHomeViewController: UIViewController {

    var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black

        // Initialize the map view
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        // Set up constraints for the map view
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        if #available(iOS 13.0, *) {
            mapView.overrideUserInterfaceStyle = .dark
        }
        
        // Request location authorization
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()

        // Show user's location on the map
        mapView.showsUserLocation = true
    }
}
