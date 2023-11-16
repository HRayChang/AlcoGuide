//
//  ViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import MapKit

class MapHomeViewController: UIViewController, MKMapViewDelegate {
    
    var mapView = MKMapView()
    let buttonLineView = UIView()
    let assembleButton = UIButton()
    let selectScheduleView = UIView()
    let scheduleView = UIView()
    let newScheduleView = UIView()
    let addScheduleView = UIView()
    let selectLocationView = UIView()
    
    let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        setupAssembleButton()
        setupMapView()
        setupButtonLineView()
        setupSelectScheduleView()
        setupScheduleView()
        setupNewScheduleView()
        setupAddScheduleView()
        setupSelectLocationView()
        setupConstraints()
        
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
    
    func setupNewScheduleView() {
        newScheduleView.backgroundColor = UIColor.black
        newScheduleView.layer.borderColor = UIColor.steelPink.cgColor
        newScheduleView.layer.borderWidth = 5
        newScheduleView.layer.cornerRadius = 20
        newScheduleView.isHidden = true
        
        let newScheduleViewTextField = UITextField()
        let newScheduleViewButton = UIButton()
        
        newScheduleViewTextField.layer.borderColor = UIColor.steelPink.cgColor
        newScheduleViewTextField.layer.borderWidth = 5
        newScheduleViewTextField.layer.cornerRadius = 20
        newScheduleViewTextField.textAlignment = .center
        newScheduleViewTextField.textColor = UIColor.white
        newScheduleViewTextField.attributedPlaceholder = NSAttributedString(
            string: "請輸入行程名稱",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        newScheduleViewButton.backgroundColor = UIColor.black
        newScheduleViewButton.layer.borderColor = UIColor.steelPink.cgColor
        newScheduleViewButton.layer.borderWidth = 5
        newScheduleViewButton.layer.cornerRadius = 20
        newScheduleViewButton.setTitle("新增行程", for: .normal)
        newScheduleViewButton.setTitleColor(UIColor.white, for: .normal)
        newScheduleViewButton.addTarget(self, action: #selector(newScheduleViewButtonTapped), for: .touchUpInside)
        
        newScheduleViewButton.translatesAutoresizingMaskIntoConstraints = false
        newScheduleViewTextField.translatesAutoresizingMaskIntoConstraints = false
        
        newScheduleView.addSubview(newScheduleViewTextField)
        newScheduleView.addSubview(newScheduleViewButton)
        
        NSLayoutConstraint.activate([
            newScheduleViewTextField.leadingAnchor.constraint(equalTo: newScheduleView.leadingAnchor, constant: 50),
            newScheduleViewTextField.trailingAnchor.constraint(equalTo: newScheduleView.trailingAnchor, constant: -50),
            newScheduleViewTextField.centerYAnchor.constraint(equalTo: newScheduleView.centerYAnchor, constant: -30),
            newScheduleViewTextField.heightAnchor.constraint(equalToConstant: 50),
            
            newScheduleViewButton.leadingAnchor.constraint(equalTo: newScheduleView.leadingAnchor, constant: 50),
            newScheduleViewButton.trailingAnchor.constraint(equalTo: newScheduleView.trailingAnchor, constant: -50),
            newScheduleViewButton.centerYAnchor.constraint(equalTo: newScheduleView.centerYAnchor, constant: 30),
            newScheduleViewButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupSelectLocationView() {
        selectLocationView.backgroundColor = UIColor.black
        selectLocationView.layer.borderColor = UIColor.steelPink.cgColor
        selectLocationView.layer.borderWidth = 5
        selectLocationView.layer.cornerRadius = 30
        selectLocationView.isHidden = true
        
        let scheduleLabel = UILabel()
        let scheduleIDLabel = UILabel()
        let searchConvenienceStoreButton = UIButton()
        let searchBarButton = UIButton()
        let searchBothButton = UIButton()
        
        scheduleLabel.text = "1234"
        scheduleLabel.textColor = UIColor.white
        
        scheduleIDLabel.text = "543421"
        scheduleIDLabel.textColor = UIColor.white
        
        searchConvenienceStoreButton.backgroundColor = UIColor.black
        searchConvenienceStoreButton.layer.borderColor = UIColor.steelPink.cgColor
        searchConvenienceStoreButton.layer.borderWidth = 5
        searchConvenienceStoreButton.layer.cornerRadius = 20
        searchConvenienceStoreButton.setTitle("超商", for: .normal)
        searchConvenienceStoreButton.setTitleColor(UIColor.white, for: .normal)
        searchConvenienceStoreButton.addTarget(self, action: #selector(searchConvenienceStoreButtonTapped), for: .touchUpInside)
        
        searchBarButton.backgroundColor = UIColor.black
        searchBarButton.layer.borderColor = UIColor.steelPink.cgColor
        searchBarButton.layer.borderWidth = 5
        searchBarButton.layer.cornerRadius = 20
        searchBarButton.setTitle("酒吧", for: .normal)
        searchBarButton.setTitleColor(UIColor.white, for: .normal)
        searchBarButton.addTarget(self, action: #selector(searchBarButtonTapped), for: .touchUpInside)
        
        searchBothButton.backgroundColor = UIColor.black
        searchBothButton.layer.borderColor = UIColor.steelPink.cgColor
        searchBothButton.layer.borderWidth = 5
        searchBothButton.layer.cornerRadius = 20
        searchBothButton.setTitle("Both", for: .normal)
        searchBothButton.setTitleColor(UIColor.white, for: .normal)
        searchBothButton.addTarget(self, action: #selector(searchBothButtonTapped), for: .touchUpInside)
        
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleIDLabel.translatesAutoresizingMaskIntoConstraints = false
        searchConvenienceStoreButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarButton.translatesAutoresizingMaskIntoConstraints = false
        searchBothButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectLocationView.addSubview(scheduleLabel)
        selectLocationView.addSubview(scheduleIDLabel)
        selectLocationView.addSubview(searchConvenienceStoreButton)
        selectLocationView.addSubview(searchBarButton)
        selectLocationView.addSubview(searchBothButton)
        
        NSLayoutConstraint.activate([
            scheduleLabel.centerXAnchor.constraint(equalTo: selectLocationView.centerXAnchor),
            
            searchConvenienceStoreButton.trailingAnchor.constraint(equalTo: searchBarButton.leadingAnchor, constant: -10),
            searchConvenienceStoreButton.centerYAnchor.constraint(equalTo: selectLocationView.centerYAnchor),
            searchConvenienceStoreButton.widthAnchor.constraint(equalToConstant: 80),
            searchConvenienceStoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            searchBarButton.centerXAnchor.constraint(equalTo: selectLocationView.centerXAnchor),
            searchBarButton.centerYAnchor.constraint(equalTo: selectLocationView.centerYAnchor),
            searchBarButton.widthAnchor.constraint(equalToConstant: 80),
            searchBarButton.heightAnchor.constraint(equalToConstant: 50),
            
            searchBothButton.leadingAnchor.constraint(equalTo: searchBarButton.trailingAnchor, constant: 10),
            searchBothButton.centerYAnchor.constraint(equalTo: selectLocationView.centerYAnchor),
            searchBothButton.widthAnchor.constraint(equalToConstant: 80),
            searchBothButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    func setupAddScheduleView() {
        addScheduleView.backgroundColor = UIColor.black
        addScheduleView.layer.borderColor = UIColor.steelPink.cgColor
        addScheduleView.layer.borderWidth = 5
        addScheduleView.layer.cornerRadius = 20
        addScheduleView.isHidden = true
        
        let addScheduleViewTextField = UITextField()
        let addScheduleViewButton = UIButton()
        
        addScheduleViewTextField.layer.borderColor = UIColor.steelPink.cgColor
        addScheduleViewTextField.layer.borderWidth = 5
        addScheduleViewTextField.layer.cornerRadius = 20
        addScheduleViewTextField.textAlignment = .center
        addScheduleViewTextField.textColor = UIColor.white
        addScheduleViewTextField.attributedPlaceholder = NSAttributedString(
            string: "請輸入行程編號",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        addScheduleViewButton.backgroundColor = UIColor.black
        addScheduleViewButton.layer.borderColor = UIColor.steelPink.cgColor
        addScheduleViewButton.layer.borderWidth = 5
        addScheduleViewButton.layer.cornerRadius = 20
        addScheduleViewButton.setTitle("加入行程", for: .normal)
        addScheduleViewButton.setTitleColor(UIColor.white, for: .normal)
        addScheduleViewButton.addTarget(self, action: #selector(addScheduleViewButtonTapped), for: .touchUpInside)
        
        addScheduleViewButton.translatesAutoresizingMaskIntoConstraints = false
        addScheduleViewTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addScheduleView.addSubview(addScheduleViewTextField)
        addScheduleView.addSubview(addScheduleViewButton)
        
        NSLayoutConstraint.activate([
            addScheduleViewTextField.leadingAnchor.constraint(equalTo: addScheduleView.leadingAnchor, constant: 50),
            addScheduleViewTextField.trailingAnchor.constraint(equalTo: addScheduleView.trailingAnchor, constant: -50),
            addScheduleViewTextField.centerYAnchor.constraint(equalTo: addScheduleView.centerYAnchor, constant: -30),
            addScheduleViewTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addScheduleViewButton.leadingAnchor.constraint(equalTo: addScheduleView.leadingAnchor, constant: 50),
            addScheduleViewButton.trailingAnchor.constraint(equalTo: addScheduleView.trailingAnchor, constant: -50),
            addScheduleViewButton.centerYAnchor.constraint(equalTo: addScheduleView.centerYAnchor, constant: 30),
            addScheduleViewButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupButtonLineView() {
        buttonLineView.backgroundColor = UIColor.steelPink
    }
    
    func setupScheduleView() {
        scheduleView.backgroundColor = UIColor.black
        scheduleView.layer.borderColor = UIColor.steelPink.cgColor
        scheduleView.layer.borderWidth = 5
        scheduleView.layer.cornerRadius = 20
        scheduleView.isHidden = true
    }
    
    func setupSelectScheduleView() {
        selectScheduleView.backgroundColor = UIColor.black
        selectScheduleView.layer.borderColor = UIColor.steelPink.cgColor
        selectScheduleView.layer.borderWidth = 5
        selectScheduleView.layer.cornerRadius = 30
        selectScheduleView.isHidden = true
        
        let newScheduleButton = UIButton()
        let addScheduleButton = UIButton()
        let myScheduleButton = UIButton()
        
        newScheduleButton.backgroundColor = UIColor.black
        newScheduleButton.layer.borderColor = UIColor.steelPink.cgColor
        newScheduleButton.layer.borderWidth = 5
        newScheduleButton.layer.cornerRadius = 20
        newScheduleButton.setTitle("新增行程", for: .normal)
        newScheduleButton.setTitleColor(UIColor.white, for: .normal)
        newScheduleButton.addTarget(self, action: #selector(newScheduleButtonTapped), for: .touchUpInside)
        
        addScheduleButton.backgroundColor = UIColor.black
        addScheduleButton.layer.borderColor = UIColor.steelPink.cgColor
        addScheduleButton.layer.borderWidth = 5
        addScheduleButton.layer.cornerRadius = 20
        addScheduleButton.setTitle("加入行程", for: .normal)
        addScheduleButton.setTitleColor(UIColor.white, for: .normal)
        addScheduleButton.addTarget(self, action: #selector(addScheduleButtonTapped), for: .touchUpInside)
        
        myScheduleButton.backgroundColor = UIColor.black
        myScheduleButton.layer.borderColor = UIColor.steelPink.cgColor
        myScheduleButton.layer.borderWidth = 5
        myScheduleButton.layer.cornerRadius = 20
        myScheduleButton.setTitle("我的行程", for: .normal)
        myScheduleButton.setTitleColor(UIColor.white, for: .normal)
        myScheduleButton.addTarget(self, action: #selector(myScheduleButtonTapped), for: .touchUpInside)
        
        newScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        addScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        myScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectScheduleView.addSubview(newScheduleButton)
        selectScheduleView.addSubview(addScheduleButton)
        selectScheduleView.addSubview(myScheduleButton)
        
        NSLayoutConstraint.activate([
            newScheduleButton.leadingAnchor.constraint(equalTo: selectScheduleView.leadingAnchor, constant: 50),
            newScheduleButton.trailingAnchor.constraint(equalTo: selectScheduleView.trailingAnchor, constant: -50),
            // 這邊之後修改成可計算的
            newScheduleButton.centerYAnchor.constraint(equalTo: selectScheduleView.centerYAnchor, constant: -70),
            newScheduleButton.heightAnchor.constraint(equalTo: selectScheduleView.heightAnchor, multiplier: 1/7),
            
            addScheduleButton.leadingAnchor.constraint(equalTo: selectScheduleView.leadingAnchor, constant: 50),
            addScheduleButton.trailingAnchor.constraint(equalTo: selectScheduleView.trailingAnchor, constant: -50),
            addScheduleButton.centerYAnchor.constraint(equalTo: selectScheduleView.centerYAnchor),
            addScheduleButton.heightAnchor.constraint(equalTo: selectScheduleView.heightAnchor, multiplier: 1/7),
            
            myScheduleButton.leadingAnchor.constraint(equalTo: selectScheduleView.leadingAnchor, constant: 50),
            myScheduleButton.trailingAnchor.constraint(equalTo: selectScheduleView.trailingAnchor, constant: -50),
            // 這邊之後修改成可計算的
            myScheduleButton.centerYAnchor.constraint(equalTo: selectScheduleView.centerYAnchor, constant: 70),
            myScheduleButton.heightAnchor.constraint(equalTo: selectScheduleView.heightAnchor, multiplier: 1/7)
        ])
    }
    
    func setupAssembleButton() {
        
        assembleButton.backgroundColor = UIColor.black
        assembleButton.layer.cornerRadius = 56
        
        let wineglassImageView = UIImageView(image: UIImage(systemName: "wineglass.fill"))
        
        wineglassImageView.tintColor = UIColor.steelPink
        
        wineglassImageView.translatesAutoresizingMaskIntoConstraints = false
        
        assembleButton.addSubview(wineglassImageView)
        
        NSLayoutConstraint.activate([
            wineglassImageView.topAnchor.constraint(equalTo: assembleButton.topAnchor, constant: 10),
            wineglassImageView.widthAnchor.constraint(equalTo: wineglassImageView.heightAnchor),
            wineglassImageView.centerXAnchor.constraint(equalTo: assembleButton.centerXAnchor),
            wineglassImageView.bottomAnchor.constraint(equalTo: assembleButton.centerYAnchor, constant: 5)
        ])
        
        assembleButton.addTarget(self, action: #selector(assembleButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        buttonLineView.translatesAutoresizingMaskIntoConstraints = false
        assembleButton.translatesAutoresizingMaskIntoConstraints = false
        selectScheduleView.translatesAutoresizingMaskIntoConstraints = false
        scheduleView.translatesAutoresizingMaskIntoConstraints = false
        newScheduleView.translatesAutoresizingMaskIntoConstraints = false
        addScheduleView.translatesAutoresizingMaskIntoConstraints = false
        selectLocationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        view.addSubview(buttonLineView)
        view.addSubview(assembleButton)
        view.addSubview(selectScheduleView)
        view.addSubview(scheduleView)
        view.addSubview(newScheduleView)
        view.addSubview(addScheduleView)
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
            
            scheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            scheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            scheduleView.heightAnchor.constraint(equalToConstant: 40),
            scheduleView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20),
            
            newScheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            newScheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            newScheduleView.heightAnchor.constraint(equalTo: newScheduleView.widthAnchor, multiplier: 2/3),
            newScheduleView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            
            addScheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addScheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addScheduleView.heightAnchor.constraint(equalTo: addScheduleView.widthAnchor, multiplier: 2/3),
            addScheduleView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            
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
    
    @objc func newScheduleButtonTapped() {
        selectScheduleView.isHidden = true
        newScheduleView.isHidden = false
        print("Button tapped!")
    }
    
    @objc func addScheduleButtonTapped() {
        selectScheduleView.isHidden = true
        addScheduleView.isHidden = false
        print("Button tapped!")
    }
    
    @objc func myScheduleButtonTapped() {
        selectScheduleView.isHidden = true
        print("Button tapped!")
    }
    
    @objc func newScheduleViewButtonTapped() {
        newScheduleView.isHidden = true
        selectLocationView.isHidden = false
        print("Button tapped!")
    }
    
    @objc func addScheduleViewButtonTapped() {
        addScheduleView.isHidden = true
        print("Button tapped!")
    }
    
    @objc func searchBarButtonTapped() {
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
    
    @objc func searchConvenienceStoreButtonTapped() {
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
    
    @objc func searchBothButtonTapped() {
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
                    print("Coordinate: \(mapItem.placemark.coordinate.latitude), \(mapItem.placemark.coordinate.longitude)")
                }
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
    
}
