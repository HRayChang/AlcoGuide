//
//  ViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class MapHomeViewController: UIViewController, MKMapViewDelegate {
    
    var scheduleReference: DocumentReference?
    
    var currentLocationType: LocationType?
    
    let mapView = MKMapView()
    let buttonLineView = UIView()
    let assembleButton = UIButton()
    let returnToCurrentLocationButton = UIButton()
    let currentScheduleView = UIView()
    let currentScheduleLabel = UILabel()
//    let shadowView = UIView()
    
    let shareScheduleView = ShareScheduleView()
    let selectLocationView = SelectLocationView()
    let selectScheduleView = SelectScheduleView()
    let joinScheduleView = JoinScheduleView()
    let addNewScheduleView = AddNewScheduleView()
    
    let coreLocationManager = CoreLocationManager.shared
    let mapManager = MapManager.shared
    let dataManager = DataManager.shared
    
    var isRouteCalculated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        selectScheduleView.delegate = self
        joinScheduleView.delegate = self
        selectLocationView.delegate = self
        addNewScheduleView.delegate = self
        shareScheduleView.delegate = self
        
        setupMapHomeViewUI()
        setupConstraints()
        setupObservers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        returnToCurrentLocation()
        addBreathingAnimation(to: assembleButton)
        
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
        
        selectLocationView.layer.shadowOffset = CGSize(width: 0, height: 0)
        selectLocationView.layer.shadowColor = UIColor.steelPink.cgColor
        selectLocationView.layer.shadowOpacity = 1
        selectLocationView.layer.shadowRadius = 10.0
        // Setup CurrentScheduleLabel
       
        currentScheduleView.isHidden = true
        currentScheduleView.layer.shadowOffset = CGSize(width: 0, height: 0)
        currentScheduleView.layer.shadowColor = UIColor.steelPink.cgColor
        currentScheduleView.layer.shadowOpacity = 1
        currentScheduleView.layer.shadowRadius = 10.0
        
        currentScheduleView.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        currentScheduleView.layer.cornerRadius = 10
        currentScheduleView.layer.borderColor = UIColor.steelPink.cgColor
        currentScheduleView.layer.borderWidth = 1
        
        currentScheduleLabel.textColor = UIColor.lilac
        currentScheduleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        currentScheduleLabel.textAlignment = .center
        currentScheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        currentScheduleView.addSubview(currentScheduleLabel)
        NSLayoutConstraint.activate([
            currentScheduleLabel.topAnchor.constraint(equalTo: currentScheduleView.topAnchor),
            currentScheduleLabel.bottomAnchor.constraint(equalTo: currentScheduleView.bottomAnchor),
            currentScheduleLabel.leadingAnchor.constraint(equalTo: currentScheduleView.leadingAnchor),
            currentScheduleLabel.trailingAnchor.constraint(equalTo: currentScheduleView.trailingAnchor)
        ])
        
        // Setup ButtonLineView
        buttonLineView.backgroundColor = UIColor.steelPink
        buttonLineView.layer.shadowColor = UIColor.steelPink.cgColor
        buttonLineView.layer.shadowOpacity = 1
        buttonLineView.layer.shadowRadius = 5
        buttonLineView.layer.shadowOffset = CGSize(width: 0, height: 0)

        
        
        // Setup AssembleButton
        assembleButton.backgroundColor = UIColor.black
        assembleButton.setBackgroundImage(UIImage(named: "Button"), for: .normal)
        assembleButton.addTarget(self, action: #selector(assembleButtonTapped), for: .touchUpInside)
        assembleButton.layer.cornerRadius = view.frame.size.width/8
        assembleButton.layer.borderWidth = 2
        assembleButton.layer.borderColor = UIColor.steelPink.cgColor
        assembleButton.layer.shadowColor = UIColor.steelPink.cgColor
        assembleButton.layer.shadowOpacity = 1
        assembleButton.layer.shadowRadius = 10.0
        assembleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
//        shadowView.layer.cornerRadius = view.frame.size.width/8
//        shadowView.layer.bounds = assembleButton.bounds
//        shadowView.layer.shadowColor = UIColor.green.cgColor
//        shadowView.layer.shadowOpacity = 1
//        shadowView.layer.shadowRadius = 10.0
//        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        // Setup ReturnToCurrentLocationButton
        returnToCurrentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        returnToCurrentLocationButton.tintColor = .lilac
        returnToCurrentLocationButton.addTarget(self, action: #selector(returnToCurrentLocation), for: .touchUpInside)
    }
    
    func addBreathingAnimation(to view: UIView) {
        let breathingAnimation = CABasicAnimation(keyPath: "shadowRadius")
        breathingAnimation.fromValue = 10
        breathingAnimation.toValue = 50
        breathingAnimation.autoreverses = true
        breathingAnimation.duration = 1
        breathingAnimation.repeatCount = .infinity
        view.layer.add(breathingAnimation, forKey: "breathingAnimation")
    }
    
    func setupConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        buttonLineView.translatesAutoresizingMaskIntoConstraints = false
        assembleButton.translatesAutoresizingMaskIntoConstraints = false
        selectScheduleView.translatesAutoresizingMaskIntoConstraints = false
        addNewScheduleView.translatesAutoresizingMaskIntoConstraints = false
        joinScheduleView.translatesAutoresizingMaskIntoConstraints = false
        shareScheduleView.translatesAutoresizingMaskIntoConstraints = false
        selectLocationView.translatesAutoresizingMaskIntoConstraints = false
        returnToCurrentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        currentScheduleView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mapView)
        view.addSubview(buttonLineView)
        view.addSubview(assembleButton)
        view.addSubview(selectScheduleView)
        view.addSubview(addNewScheduleView)
        view.addSubview(joinScheduleView)
        view.addSubview(shareScheduleView)
        view.addSubview(selectLocationView)
        view.addSubview(returnToCurrentLocationButton)
        view.addSubview(currentScheduleView)
//        view.addSubview(shadowView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
            
            currentScheduleView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 5),
            currentScheduleView.heightAnchor.constraint(equalToConstant: 50),
            currentScheduleView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 60),
            currentScheduleView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -60),
            
            buttonLineView.heightAnchor.constraint(equalToConstant: 2),
            buttonLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonLineView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            
            assembleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
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
            
            shareScheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            shareScheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            shareScheduleView.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: 1/5),
            shareScheduleView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            
            selectLocationView.widthAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 1/9),
            selectLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            selectLocationView.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: 1/5),
            selectLocationView.topAnchor.constraint(equalTo: currentScheduleView.bottomAnchor),
            
            returnToCurrentLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -5),
            returnToCurrentLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -5),
            returnToCurrentLocationButton.widthAnchor.constraint(equalToConstant: 40),
            returnToCurrentLocationButton.heightAnchor.constraint(equalTo: returnToCurrentLocationButton.widthAnchor),
  
        ])
    }
    // MARK: Setup UI -
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentScheduleLabel), name: Notification.Name("CurrentSchedule"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLocaitons), name: Notification.Name("CurrentLocationsCoordinate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewLocationAnnotation), name: Notification.Name("UpdateLocation"), object: nil)
    }
    
    @objc private func updateCurrentScheduleLabel(_ notification: Notification) {
        currentScheduleLabel.text = DataManager.CurrentSchedule.currentScheduleName
        currentScheduleView.isHidden = false
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
        case .none:
            queries = [""]
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
        
        if DataManager.CurrentSchedule.currentLocations == nil {
            
            self.mapView.removeAnnotations(mapView.annotations)
        
        } else {
            
            let annotationsToRemove = mapView.annotations.filter { annotation in
                guard let title = annotation.title else {
                    return false
                }
                
                return !(DataManager.CurrentSchedule.currentLocations!.contains(title!))
            }
            
            self.mapView.removeAnnotations(annotationsToRemove)
            
        }
        
        self.mapView.addAnnotations(annotations)
        //
        //            self.addLocationAnnotation()
        
    }
    
    @objc private func showLocaitons() {
//        searchForAndDisplayPlaces(queries: ["bar", "convenience_store"])
//        currentLocationType = .both
        
        addLocationAnnotation()
    }

    func addLocationAnnotation() {
        var annotations: [CustomAnnotation] = []
        
        mapView.removeAnnotations(annotations)
        
        let currentLocationsId = DataManager.CurrentSchedule.currentLocationsId!
        dataManager.fetchLocationCoordinate(locationsId: currentLocationsId) { locationInfoArray in
            for location in locationInfoArray {
                let annotation = CustomAnnotation()
                annotation.coordinate.latitude = location.locationCoordinate.latitude
                annotation.coordinate.longitude = location.locationCoordinate.longitude
                annotation.title = location.locationName
                annotation.subtitle = location.locationId
                annotation.pinTintColor = UIColor.steelPink
                annotations.append(annotation)
            }
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
            
            if !self.isRouteCalculated {
                self.calculateAndDisplayRoute(annotations: annotations)
                self.isRouteCalculated = true
            }
        }
    }

    func calculateAndDisplayRoute(annotations: [CustomAnnotation]) {
        
        mapView.removeOverlays(mapView.overlays)
        guard annotations.count >= 2 else {
            // 至少需要兩個點才能計算路線
            return
        }
        
        for location in 0..<annotations.count - 1 {
            let sourceCoordinate = annotations[location].coordinate
            let destinationCoordinate = annotations[location + 1].coordinate

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))

            request.transportType = .walking

            // 创建MKDirections对象
            let directions = MKDirections(request: request)

            // 计算路线
            directions.calculate { [weak self] (response, error) in
                guard let self = self else { return }

                if let error = error {
                    print("計算路線錯誤：\(error.localizedDescription)")
                } else if let response = response {
                    for route in response.routes {
                        // 在地圖上顯示路線
                        self.mapView.addOverlay(route.polyline, level: .aboveRoads)

                        // 設定地圖顯示範圍，讓整條路線都可見
                        let visibleMapRect = route.polyline.boundingMapRect
                        self.mapView.setRegion(MKCoordinateRegion(visibleMapRect), animated: true)
                    }
                }
            }
        }
    }
    
    @objc func addNewLocationAnnotation() {
        isRouteCalculated = false
        addLocationAnnotation()
        
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.steelPink
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        let identifier = "CustomAnnotationView"
        var annotationView: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView = dequeuedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        
        annotationView.markerTintColor = customAnnotation.pinTintColor
        
        return annotationView
    }
    
    
    // MARK: Search location -
}


// MARK: - Delegate
extension MapHomeViewController: SelectScheduleViewDelegate,
                                 JoinScheduleViewDelegate,
                                 SelectLocationViewDelegate,
                                 AddNewScheduleViewDelegate,
                                 ShareScheduleViewDelegate {
    
    func shareButtonTapped(scheduleId: String) {
        assembleButton.isUserInteractionEnabled = true
        shareScheduleView.isHidden = true
        
        let sharingItems: [String] = [scheduleId]
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
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
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    func joinScheduleButtonTapped(scheduleId: String) {
        joinScheduleView.isHidden = true
        assembleButton.isUserInteractionEnabled = true
        dataManager.checkScheduleExit(scheduleId: scheduleId)
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    func addNewScheduleButtonTapped(scheduleName: String) {
        addNewScheduleView.isHidden = true
        shareScheduleView.isHidden = false
        
        dataManager.addNewSchedule(scheduleName: scheduleName) { documentID in
            if let documentID = documentID {
                print("Document added successfully with ID: \(documentID)")
            } else {
                print("Error adding document")
            }
        }
    }
    
    func locationButtonTapped(type: LocationType) {
        currentLocationType = type
        
        switch type {
        case .convenienceStore:
            searchForAndDisplayPlaces(queries: ["convenience_store"])
            
        case .bar:
            searchForAndDisplayPlaces(queries: ["bar"])
            
        case .both:
            searchForAndDisplayPlaces(queries: ["convenience_store", "bar"])
        case .none:
            searchForAndDisplayPlaces(queries: [""])
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


