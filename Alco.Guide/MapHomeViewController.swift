//
//  ViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import MapKit

class MapHomeViewController: UIViewController, MKMapViewDelegate {
    
    var didSelectLocationClosure: ((String?, String?, String?, CLLocationCoordinate2D?) -> Void)?
    
    var locationName: String?
    var locationPhoneNumber: String?
    var locationAddress: String?
    var locationCoordinate: CLLocationCoordinate2D?
    
    var mapView = MKMapView()
    let buttonLineView = UIView()
    let assembleButton = UIButton()
    let returnToCurrentLocationButton = UIButton()
    
    
    let selectLocationView = SelectLocationView()
    let selectScheduleView = SelectScheduleView()
    let joinScheduleView = JoinScheduleView()
    let addNewScheduleView = AddNewScheduleView()
    
    let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        setupAssembleButton()
        setupMapView()
        setupConstraints()
        setupReturnToCurrentLocationButton()
        
        selectScheduleView.delegate = self
        joinScheduleView.delegate = self
        selectLocationView.delegate = self
        addNewScheduleView.delegate = self
        
        buttonLineView.backgroundColor = UIColor.steelPink
        
        //        renderCurrentLocation()
    }
    
    //    func renderCurrentLocation() {
    //        if let location = locationManager.currentLocation {
    //            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
    //                                                    longitude: location.coordinate.longitude)
    //            let span = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
    //            let region = MKCoordinateRegion(center: coordinate, span: span)
    //            mapView.setRegion(region, animated: true)
    //        }
    //    }
    
    // MARK: - Setup UI
    func setupMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        if #available(iOS 13.0, *) {
            mapView.overrideUserInterfaceStyle = .dark
        }
        
        mapView.selectableMapFeatures = [.pointsOfInterest]

        let mapConfiguration = MKStandardMapConfiguration()
        mapConfiguration.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory.nightlife])

        mapView.preferredConfiguration = mapConfiguration
    }
    
    func setupAssembleButton() {
        
        assembleButton.backgroundColor = UIColor.black
        assembleButton.layer.cornerRadius = 56
        
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
        
        assembleButton.addTarget(self, action: #selector(assembleButtonTapped), for: .touchUpInside)
    }
    
    func setupReturnToCurrentLocationButton() {
           returnToCurrentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
           returnToCurrentLocationButton.tintColor = .white
           returnToCurrentLocationButton.translatesAutoresizingMaskIntoConstraints = false
           returnToCurrentLocationButton.addTarget(self, action: #selector(returnToCurrentLocation), for: .touchUpInside)

           view.addSubview(returnToCurrentLocationButton)

           NSLayoutConstraint.activate([
               returnToCurrentLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               returnToCurrentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
               returnToCurrentLocationButton.widthAnchor.constraint(equalToConstant: 40),
               returnToCurrentLocationButton.heightAnchor.constraint(equalToConstant: 40)
           ])
       }
    
    func setupConstraints() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        buttonLineView.translatesAutoresizingMaskIntoConstraints = false
        assembleButton.translatesAutoresizingMaskIntoConstraints = false
        selectScheduleView.translatesAutoresizingMaskIntoConstraints = false
        addNewScheduleView.translatesAutoresizingMaskIntoConstraints = false
        joinScheduleView.translatesAutoresizingMaskIntoConstraints = false
        selectLocationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        view.addSubview(buttonLineView)
        view.addSubview(assembleButton)
        view.addSubview(selectScheduleView)
        view.addSubview(addNewScheduleView)
        view.addSubview(joinScheduleView)
        view.addSubview(selectLocationView)
        
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
            selectLocationView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor)
        ])
    }
    // MARK: Setup UI -
    
    @objc func assembleButtonTapped() {
        selectScheduleView.isHidden = false
    }
    
    @objc func returnToCurrentLocation() {
          if let location = locationManager.currentLocation {
              let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
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
            
            getMapItem(for: annotation) { [self] mapItem in
                if let mapItem = mapItem {
                    var region = mapView.region
                    region.center = mapItem.placemark.coordinate
                    
                    locationName = mapItem.name
                    locationPhoneNumber = mapItem.phoneNumber
                    locationAddress = mapItem.placemark.title
                    locationCoordinate = mapItem.placemark.coordinate
                    
                    print("Map Item Details:")
                    print("Name: \(locationName ?? "No name")")
                    print("Phone: \(locationPhoneNumber ?? "No phone number")")
                    print("Address: \(locationAddress ?? "")")
                    print("Coordinate: \(String(describing: locationCoordinate))")
                }
            }
        }

        let viewController = DetailViewController()
        if let sheetPresentationController = viewController.sheetPresentationController {
            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
            sheetPresentationController.detents = [
                .medium(),
                .custom(resolver: { context in
                    context.maximumDetentValue * 0.3
                }), .large()
            ]
        }
        present(viewController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

            MapManager.shared.searchForPlaces(query: "酒吧", region: mapView.region) { result in
                switch result {
                case .success(let annotations):
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(annotations)
                case .failure(let error):
                    print("Error searching for nearby places: \(error.localizedDescription)")
                }
            }
        }


    private func getMapItem(for annotation: MKAnnotation, completion: @escaping (MKMapItem?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = annotation.title ?? ""

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let mapItem = response?.mapItems.first else {
                completion(nil)
                return
            }
            completion(mapItem)
        }
    }
    
    func didSelectLocation() {
        // 当某个地点被选择时，调用闭包传递数据
        didSelectLocationClosure?(locationName, locationPhoneNumber, locationAddress, locationCoordinate)
    }
    
}

extension MapHomeViewController: SelectScheduleViewDelegate, JoinScheduleViewDelegate, SelectLocationViewDelegate, AddNewScheduleViewDelegate {
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
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
    
    func convenienceStoreButtonTapped() {
        selectLocationView.isHidden = true
        
        MapManager.shared.searchForPlaces(query: "超商", region: mapView.region) { result in
            switch result {
            case .success(let annotations):
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            case .failure(let error):
                print("Error searching for nearby places: \(error.localizedDescription)")
            }
        }
    }

    func barButtonTapped() {
        selectLocationView.isHidden = true
        
        MapManager.shared.searchForPlaces(query: "酒吧", region: mapView.region) { result in
            switch result {
            case .success(let annotations):
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            case .failure(let error):
                print("Error searching for nearby places: \(error.localizedDescription)")
            }
        }
    }

    func bothButtonTapped() {
        selectLocationView.isHidden = true
        
        let dispatchGroup = DispatchGroup()
        
        var barAnnotations: [MKPointAnnotation] = []
        var convenienceStoreAnnotations: [MKPointAnnotation] = []
        
        dispatchGroup.enter()
        MapManager.shared.searchForPlaces(query: "酒吧", region: mapView.region) { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let annotations):
                barAnnotations = annotations
            case .failure(let error):
                print("Error searching for bars: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.enter()
        MapManager.shared.searchForPlaces(query: "超商", region: mapView.region) { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let annotations):
                convenienceStoreAnnotations = annotations
            case .failure(let error):
                print("Error searching for convenience stores: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let allAnnotations = barAnnotations + convenienceStoreAnnotations
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(allAnnotations)
        }
    }
}
