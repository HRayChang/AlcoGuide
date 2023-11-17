//
//  ViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import MapKit

class MapHomeViewController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    let buttonLineView = UIView()
    let assembleButton = UIButton()
    let returnToCurrentLocationButton = UIButton()
    
    let selectLocationView = SelectLocationView()
    let selectScheduleView = SelectScheduleView()
    let joinScheduleView = JoinScheduleView()
    let addNewScheduleView = AddNewScheduleView()
    
    let locationManager = LocationManager.shared
    let mapManager = MapManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        selectScheduleView.delegate = self
        joinScheduleView.delegate = self
        selectLocationView.delegate = self
        addNewScheduleView.delegate = self
        
        setupMapHomeViewUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        returnToCurrentLocation()
    }
    
    // MARK: - Setup UI
    func setupMapHomeViewUI() {
        
        view.backgroundColor = UIColor.black
        
        // MARK: Setup MapView
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        let mapConfiguration = MKStandardMapConfiguration()
        mapConfiguration.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory.nightlife])
        mapView.preferredConfiguration = mapConfiguration
        
        if #available(iOS 13.0, *) {
            mapView.overrideUserInterfaceStyle = .dark
        }
        
        // MARK: Setup ButtonLineView
        buttonLineView.backgroundColor = UIColor.steelPink
        
        // MARK: Setup AssembleButton
        assembleButton.backgroundColor = UIColor.black
        assembleButton.layer.cornerRadius = 56
        assembleButton.addTarget(self, action: #selector(assembleButtonTapped), for: .touchUpInside)
        
        let wineGlassImageView = UIImageView(image: UIImage(systemName: "wineglass.fill"))
        wineGlassImageView.tintColor = UIColor.steelPink
        wineGlassImageView.translatesAutoresizingMaskIntoConstraints = false
        assembleButton.addSubview(wineGlassImageView)
        NSLayoutConstraint.activate([
            wineGlassImageView.topAnchor.constraint(equalTo: assembleButton.topAnchor, constant: 10),
            wineGlassImageView.widthAnchor.constraint(equalTo: wineGlassImageView.heightAnchor),
            wineGlassImageView.centerXAnchor.constraint(equalTo: assembleButton.centerXAnchor),
            wineGlassImageView.bottomAnchor.constraint(equalTo: assembleButton.centerYAnchor, constant: 5)
        ])
        
        // MARK: Setup ReturnToCurrentLocationButton
        returnToCurrentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        returnToCurrentLocationButton.tintColor = .white
        returnToCurrentLocationButton.addTarget(self, action: #selector(returnToCurrentLocation), for: .touchUpInside)
    }
    
    func setupConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        buttonLineView.translatesAutoresizingMaskIntoConstraints = false
        assembleButton.translatesAutoresizingMaskIntoConstraints = false
        selectScheduleView.translatesAutoresizingMaskIntoConstraints = false
        addNewScheduleView.translatesAutoresizingMaskIntoConstraints = false
        joinScheduleView.translatesAutoresizingMaskIntoConstraints = false
        selectLocationView.translatesAutoresizingMaskIntoConstraints = false
        returnToCurrentLocationButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mapView)
        view.addSubview(buttonLineView)
        view.addSubview(assembleButton)
        view.addSubview(selectScheduleView)
        view.addSubview(addNewScheduleView)
        view.addSubview(joinScheduleView)
        view.addSubview(selectLocationView)
        view.addSubview(returnToCurrentLocationButton)
        
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
            
            buttonLineView.heightAnchor.constraint(equalToConstant: 12),
            buttonLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonLineView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            
            assembleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3.5),
            assembleButton.heightAnchor.constraint(equalTo: assembleButton.widthAnchor),
            assembleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            assembleButton.centerYAnchor.constraint(equalTo: buttonLineView.centerYAnchor),
            
            selectScheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            selectScheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            selectScheduleView.heightAnchor.constraint(equalTo: selectScheduleView.widthAnchor),
            selectScheduleView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            
            addNewScheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addNewScheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addNewScheduleView.heightAnchor.constraint(equalTo: addNewScheduleView.widthAnchor, multiplier: 2/3),
            addNewScheduleView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            
            joinScheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            joinScheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            joinScheduleView.heightAnchor.constraint(equalTo: joinScheduleView.widthAnchor, multiplier: 2/3),
            joinScheduleView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            
            selectLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            selectLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            selectLocationView.heightAnchor.constraint(equalTo: selectLocationView.widthAnchor),
            selectLocationView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            
            returnToCurrentLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -5),
            returnToCurrentLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -5),
            returnToCurrentLocationButton.widthAnchor.constraint(equalToConstant: 40),
            returnToCurrentLocationButton.heightAnchor.constraint(equalTo: returnToCurrentLocationButton.widthAnchor)
        ])
    }
    // MARK: Setup UI -
    
    @objc func assembleButtonTapped() {
        selectScheduleView.isHidden = false
    }
    
    @objc func returnToCurrentLocation() {
          if let location = locationManager.currentLocation {
              let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, 
                                                      longitude: location.coordinate.longitude)
              let span = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
              let region = MKCoordinateRegion(center: coordinate, span: span)
              mapView.setRegion(region, animated: true)
          }
      }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
        
        if let title = annotation.title {
            print("Selected annotation with title: \(title ?? "No title")")
            
            getMapItem(for: annotation) { mapItem in
                if let mapItem = mapItem {
                    var region = mapView.region
                    region.center = mapItem.placemark.coordinate
                    
                    print("Map Item Details:")
                    print("Name: \(mapItem.name ?? "No name")")
                    print("Phone: \(mapItem.phoneNumber ?? "No phone number")")
                    print("Address: \(mapItem.placemark.title ?? "")")
                    print("Coordinate: \(String(describing: mapItem.placemark.coordinate))")
                    
                    self.presentDetailViewController(with: mapItem)
                }
            }
        }
        
    }
    
    func presentDetailViewController(with mapItem: MKMapItem) {
        let viewController = DetailViewController(
            name: mapItem.name,
            phoneNumber: mapItem.phoneNumber,
            address: mapItem.placemark.title,
            coordinate: mapItem.placemark.coordinate
        )
        
        if let sheetPresentationController = viewController.sheetPresentationController {
            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
            sheetPresentationController.detents = [
                .custom(resolver: { context in
                    context.maximumDetentValue * 0.3
                }), .large()
            ]
        }
        
        present(viewController, animated: true)
    }
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
//        mapManager.searchForPlaces(query: "酒吧", region: mapView.region) { result in
//                switch result {
//                case .success(let annotations):
//                    self.mapView.removeAnnotations(self.mapView.annotations)
//                    self.mapView.addAnnotations(annotations)
//                case .failure(let error):
//                    print("Error searching for nearby places: \(error.localizedDescription)")
//                }
//            }
//        }

    private func getMapItem(for annotation: MKAnnotation, completion: @escaping (MKMapItem?) -> Void) {
        mapManager.getMapItem(for: annotation, completion: completion)
    }
}

// MARK: - Delegate
extension MapHomeViewController: SelectScheduleViewDelegate,
                                 JoinScheduleViewDelegate,
                                 SelectLocationViewDelegate,
                                 AddNewScheduleViewDelegate {
    
    func showAddNewScheduleView() {
        selectScheduleView.isHidden = true
        addNewScheduleView.isHidden = false
    }
    
    func showJoinScheduleView() {
        selectScheduleView.isHidden = true
        joinScheduleView.isHidden = false
    }
    
    func showMyScheduleView() {
        selectScheduleView.isHidden = true
        self.navigationController?.pushViewController(ScheduleViewController(), animated: true)
    }
    
    func joinScheduleButtonTapped() {
        joinScheduleView.isHidden = true
        self.navigationController?.pushViewController(ScheduleViewController(), animated: true)
    }
    
    func addNewScheduleButtonTapped(scheduleName: String) {
        addNewScheduleView.isHidden = true
        selectLocationView.isHidden = false
        
    }
    
    // MARK: - Search location
    func locationButtonTapped(type: LocationType) {
        selectLocationView.isHidden = true
        
        switch type {
        case .convenienceStore:
            searchForAndDisplayPlaces(queries: ["超商"])
            
        case .bar:
            searchForAndDisplayPlaces(queries: ["酒吧"])
            
        case .both:
            searchForAndDisplayPlaces(queries: ["超商", "酒吧"])
        }
    }

    private func searchForAndDisplayPlaces(queries: [String]) {
        let dispatchGroup = DispatchGroup()
        var annotations: [MKPointAnnotation] = []

        for query in queries {
            dispatchGroup.enter()
            mapManager.searchForPlaces(query: query, region: mapView.region) { result in
                defer {
                    dispatchGroup.leave()
                }
                switch result {
                case .success(let resultAnnotations):
                    annotations += resultAnnotations
                case .failure(let error):
                    print("Error searching for \(query): \(error.localizedDescription)")
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.displayAnnotations(annotations)
        }
    }

    private func displayAnnotations(_ annotations: [MKPointAnnotation]) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    // MARK: Search location -
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
// MARK: Delegate -
