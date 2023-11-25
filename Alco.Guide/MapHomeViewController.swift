//
//  ViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import MapKit
import FirebaseFirestore

class MapHomeViewController: UIViewController, MKMapViewDelegate {
    
    var scheduleReference: DocumentReference?
    
    var currentLocationType: LocationType?
    
    let mapView = MKMapView()
    let buttonLineView = UIView()
    let assembleButton = UIButton()
    let returnToCurrentLocationButton = UIButton()
    let currentScheduleLabel = UILabel()
    
    let selectLocationView = SelectLocationView()
    let selectScheduleView = SelectScheduleView()
    let joinScheduleView = JoinScheduleView()
    let addNewScheduleView = AddNewScheduleView()
    
    let coreLocationManager = CoreLocationManager.shared
    let mapManager = MapManager.shared
    let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        selectScheduleView.delegate = self
        joinScheduleView.delegate = self
        selectLocationView.delegate = self
        addNewScheduleView.delegate = self
        
        setupMapHomeViewUI()
        setupConstraints()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        returnToCurrentLocation()
    }
    
    // MARK: - Setup UI
    func setupMapHomeViewUI() {
        
        view.backgroundColor = UIColor.black
        
        // Setup MapView
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        let mapConfiguration = MKStandardMapConfiguration()
        mapConfiguration.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory.nightlife])
        mapView.preferredConfiguration = mapConfiguration
        
        if #available(iOS 13.0, *) {
            mapView.overrideUserInterfaceStyle = .dark
        }
        
        // Setup CurrentScheduleLabel
       
            currentScheduleLabel.isHidden = true
        
        currentScheduleLabel.backgroundColor = UIColor.black
        currentScheduleLabel.textColor = UIColor.white
        currentScheduleLabel.textAlignment = .center
//        currentScheduleLabel.layer.cornerRadius = 10
        currentScheduleLabel.layer.borderColor = UIColor.steelPink.cgColor
        currentScheduleLabel.layer.borderWidth = 3
        
        // Setup ButtonLineView
        buttonLineView.backgroundColor = UIColor.steelPink
        
        // Setup AssembleButton
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
        
        // Setup ReturnToCurrentLocationButton
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
        currentScheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        view.addSubview(buttonLineView)
        view.addSubview(assembleButton)
        view.addSubview(selectScheduleView)
        view.addSubview(addNewScheduleView)
        view.addSubview(joinScheduleView)
        view.addSubview(selectLocationView)
        view.addSubview(returnToCurrentLocationButton)
        view.addSubview(currentScheduleLabel)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
            
            currentScheduleLabel.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20),
            currentScheduleLabel.heightAnchor.constraint(equalToConstant: 30),
            currentScheduleLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 50),
            currentScheduleLabel.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -50),
            
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
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentScheduleLabel), name: Notification.Name("CurrentSchedule"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentLocationsCoordinate), name: Notification.Name("CurrentLocationsCoordinate"), object: nil)
    }
    
    @objc private func updateCurrentScheduleLabel(_ notification: Notification) {
        currentScheduleLabel.text = CurrentSchedule.currentScheduleName
        currentScheduleLabel.isHidden = false
    }
    
    @objc func assembleButtonTapped() {
        selectScheduleView.isHidden = false
        assembleButton.isUserInteractionEnabled = false
    }
    
    @objc func returnToCurrentLocation() {
        if let location = coreLocationManager.currentLocation {
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                    longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let detailViewController = presentedViewController as? LocationDetailViewController {
            detailViewController.fetchLocationInfo(with: annotation)
        } else {
            let detailViewController = LocationDetailViewController()
            detailViewController.fetchLocationInfo(with: annotation)
            if let sheetPresentationController = detailViewController.sheetPresentationController {
                sheetPresentationController.largestUndimmedDetentIdentifier = .medium
                sheetPresentationController.detents = [
                    .custom(resolver: { context in
                        context.maximumDetentValue * 0.3
                    }), .medium()
                ]
            }
            present(detailViewController, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard let currentLocationType = currentLocationType else { return }
        
        var queries: [String] = []
        
        switch currentLocationType {
        case .convenienceStore:
            queries = ["convenience_store"]
            
        case .bar:
            queries = ["bar"]
            
        case .both:
            queries = ["bar", "convenience_store"]
        }
        
        searchForAndDisplayPlaces(queries: queries)
    }
    
    // MARK: - Search location
    private func searchForAndDisplayPlaces(queries: [String]) {
        let dispatchGroup = DispatchGroup()
        var annotations: [MKPointAnnotation] = []
        
        for query in queries {
            dispatchGroup.enter()
            mapManager.searchNearbylocations(keyword: query, region: mapView.region) { result in
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
    
    @objc private func updateCurrentLocationsCoordinate() {
        let dispatchGroup = DispatchGroup()
        var annotations: [MKPointAnnotation] = []
        let queries = ["convenience_store", "bar"]
        
        mapView.removeAnnotations(mapView.annotations)
        
        for query in queries {
            dispatchGroup.enter()
            mapManager.searchNearbylocations(keyword: query, region: mapView.region) { result in
                defer {
                    dispatchGroup.leave()
                }
                switch result {
                case .success(let resultAnnotations):
                    annotations += resultAnnotations
                    self.mapView.addAnnotations(annotations)
                case .failure(let error):
                    print("Error searching for \(query): \(error.localizedDescription)")
                }
            }
        }
        
        // Wait for all async tasks to finish
        dispatchGroup.notify(queue: .main) {
            // Add annotations to the map
            
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKMarkerAnnotationView

        if let pointAnnotation = annotation as? MKPointAnnotation,
           CurrentSchedule.currentLocationCooredinate?.contains(where: { $0.latitude == pointAnnotation.coordinate.latitude && $0.longitude == pointAnnotation.coordinate.longitude }) == true {
            
            annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: "specialLocations") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: pointAnnotation, reuseIdentifier: "specialLocations")
            annotationView.markerTintColor = UIColor.steelPink
        } else {
            annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: "defaultLocations") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "defaultLocations")
        }

        return annotationView
    }
    // MARK: Search location -
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
        assembleButton.isUserInteractionEnabled = true
        self.navigationController?.pushViewController(MyScheduleViewController(), animated: true)
    }
    
    func joinScheduleButtonTapped() {
        joinScheduleView.isHidden = true
        assembleButton.isUserInteractionEnabled = true
        
        self.navigationController?.pushViewController(MyScheduleViewController(), animated: true)

    }
    
    func addNewScheduleButtonTapped(scheduleName: String) {
        addNewScheduleView.isHidden = true
        selectLocationView.isHidden = false
        
        dataManager.addNewSchedule(scheduleName: scheduleName) { documentID in
            if let documentID = documentID {
                print("Document added successfully with ID: \(documentID)")
            } else {
                print("Error adding document")
            }
        }
    }
    
    func locationButtonTapped(type: LocationType) {
        selectLocationView.isHidden = true
        currentLocationType = type
        assembleButton.isUserInteractionEnabled = true
        
        switch type {
        case .convenienceStore:
            searchForAndDisplayPlaces(queries: ["convenience_store"])
            
        case .bar:
            searchForAndDisplayPlaces(queries: ["bar"])
            
        case .both:
            searchForAndDisplayPlaces(queries: ["convenience_store", "bar"])
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
// MARK: Delegate -
