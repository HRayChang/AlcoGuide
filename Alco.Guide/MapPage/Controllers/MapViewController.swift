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
import SnapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var scheduleReference: DocumentReference?
    
    var currentLocationType: LocationType?
    
    let mapView = MKMapView()
    let buttonLineView = UIView()
    let assembleButton = UIButton()
    let returnToCurrentLocationButton = UIButton()
    let currentScheduleView = UIView()
    let currentScheduleLabel = UILabel()
    
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
//        returnToCurrentLocation()
        addBreathingAnimation(to: assembleButton)
        
        
        tabBarController?.tabBar.backgroundColor = .clear
    }
    
    // MARK: - Setup UI
    func setupMapHomeViewUI() {
        
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
        
        view.backgroundColor = UIColor.black
        
        self.title = "Alco.Guide"
        
        if let navigationController = self.navigationController {
                    let font = UIFont.systemFont(ofSize: 35.0) // 设置字体大小，这里是 20
                    let color = UIColor.steelPink // 设置字体颜色，这里是红色
                    let shadow = NSShadow()
                    shadow.shadowColor = UIColor.steelPink // 阴影颜色
                    shadow.shadowOffset = CGSize(width: 0, height: 0) // 阴影偏移量
            shadow.shadowBlurRadius = 8.0

                    navigationController.navigationBar.titleTextAttributes = [
                        NSAttributedString.Key.font: font,
                        NSAttributedString.Key.foregroundColor: color,
                        NSAttributedString.Key.shadow: shadow
                    ]
                }
        
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
        
        // Setup ReturnToCurrentLocationButton
        returnToCurrentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        returnToCurrentLocationButton.tintColor = .lilac
//        returnToCurrentLocationButton.addTarget(self, action: #selector(returnToCurrentLocation), for: .touchUpInside)
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
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-22)
        }
        
        currentScheduleView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top).offset(5)
            make.height.equalTo(50)
            make.leading.equalTo(mapView.snp.leading).offset(60)
            make.trailing.equalTo(mapView.snp.trailing).offset(-60)
        }

        buttonLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(mapView.snp.bottom)
        }

        assembleButton.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).multipliedBy(1.0 / 4.0)
            make.height.equalTo(assembleButton.snp.width)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(buttonLineView.snp.centerY)
        }

        selectScheduleView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(50)
            make.trailing.equalTo(view.snp.trailing).offset(-50)
            make.height.equalTo(selectScheduleView.snp.width)
            make.centerY.equalTo(mapView.snp.centerY)
        }

        addNewScheduleView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(50)
            make.trailing.equalTo(view.snp.trailing).offset(-50)
            make.height.equalTo(addNewScheduleView.snp.width).multipliedBy(2.0 / 3.0)
            make.centerY.equalTo(mapView.snp.centerY)
        }

        joinScheduleView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(50)
            make.trailing.equalTo(view.snp.trailing).offset(-50)
            make.height.equalTo(joinScheduleView.snp.width).multipliedBy(2.0 / 3.0)
            make.centerY.equalTo(mapView.snp.centerY)
        }

        shareScheduleView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(50)
            make.trailing.equalTo(view.snp.trailing).offset(-50)
            make.height.equalTo(mapView.snp.height).multipliedBy(1.0 / 5.0)
            make.centerY.equalTo(mapView.snp.centerY)
        }

        selectLocationView.snp.makeConstraints { make in
            make.width.equalTo(mapView.snp.width).multipliedBy(1.0 / 9.0)
            make.trailing.equalTo(view.snp.trailing).offset(-5)
            make.height.equalTo(mapView.snp.height).multipliedBy(1.0 / 5.0)
            make.top.equalTo(currentScheduleView.snp.bottom)
        }

        returnToCurrentLocationButton.snp.makeConstraints { make in
            make.trailing.equalTo(mapView.snp.trailing).offset(-5)
            make.bottom.equalTo(mapView.snp.bottom).offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(returnToCurrentLocationButton.snp.width)
        }
    }
    
    // MARK: Setup UI -
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentScheduleLabel), name: Notification.Name("CurrentSchedule"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addLocationAnnotation), name: Notification.Name("CurrentLocationsCoordinate"), object: nil)
        
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
    
//    @objc func returnToCurrentLocation() {
//        if let location = coreLocationManager.currentLocation {
//            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
//                                                    longitude: location.coordinate.longitude)
//            let span = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
//            let region = MKCoordinateRegion(center: coordinate, span: span)
//            mapView.setRegion(region, animated: true)
//        }
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
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
    
//    @objc private func showLocaitons() {
////        searchForAndDisplayPlaces(queries: ["bar", "convenience_store"])
////        currentLocationType = .both
//        
//        addLocationAnnotation()
//    }

    @objc func addLocationAnnotation() {
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
extension MapViewController: SelectScheduleViewDelegate,
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


