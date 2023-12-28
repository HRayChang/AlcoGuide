//
//  MapView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/22.
//

//import UIKit
//import MapKit
//import SnapKit
//
//class MapView: UIView, MKMapViewDelegate {
//    
//    let mapView = MKMapView()
//    let buttonLineView = UIView()
//    let assembleButton = UIButton()
//    let returnToCurrentLocationButton = UIButton()
//    let currentScheduleView = UIView()
//    let currentScheduleLabel = UILabel()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupMapViewUI()
//        setupConstraints()
//        
//        mapView.delegate = self
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupMapViewUI() {
//        addSubview(mapView)
//        addSubview(buttonLineView)
//        addSubview(assembleButton)
//        addSubview(returnToCurrentLocationButton)
//        addSubview(currentScheduleView)
//        
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .follow
//        
//        let mapConfiguration = MKStandardMapConfiguration()
//        mapConfiguration.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory.nightlife])
//        mapView.preferredConfiguration = mapConfiguration
//        
//        if #available(iOS 13.0, *) {
//            mapView.overrideUserInterfaceStyle = .dark
//        }
//        
//        currentScheduleView.isHidden = true
//        currentScheduleView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        currentScheduleView.layer.shadowColor = UIColor.steelPink.cgColor
//        currentScheduleView.layer.shadowOpacity = 1
//        currentScheduleView.layer.shadowRadius = 10.0
//        
//        currentScheduleView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        
//        currentScheduleView.layer.cornerRadius = 10
//        currentScheduleView.layer.borderColor = UIColor.steelPink.cgColor
//        currentScheduleView.layer.borderWidth = 1
//        currentScheduleLabel.textColor = UIColor.lilac
//        currentScheduleLabel.font = UIFont.boldSystemFont(ofSize: 22)
//        currentScheduleLabel.textAlignment = .center
//        currentScheduleLabel.translatesAutoresizingMaskIntoConstraints = false
//        currentScheduleView.addSubview(currentScheduleLabel)
//        NSLayoutConstraint.activate([
//            currentScheduleLabel.topAnchor.constraint(equalTo: currentScheduleView.topAnchor),
//            currentScheduleLabel.bottomAnchor.constraint(equalTo: currentScheduleView.bottomAnchor),
//            currentScheduleLabel.leadingAnchor.constraint(equalTo: currentScheduleView.leadingAnchor),
//            currentScheduleLabel.trailingAnchor.constraint(equalTo: currentScheduleView.trailingAnchor)
//        ])
//        
//        // Setup ButtonLineView
//        buttonLineView.backgroundColor = UIColor.steelPink
//        buttonLineView.layer.shadowColor = UIColor.steelPink.cgColor
//        buttonLineView.layer.shadowOpacity = 1
//        buttonLineView.layer.shadowRadius = 5
//        buttonLineView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        
//        // Setup AssembleButton
//        assembleButton.backgroundColor = UIColor.black
//        assembleButton.setBackgroundImage(UIImage(named: "Button"), for: .normal)
//        assembleButton.addTarget(self, action: #selector(assembleButtonTapped), for: .touchUpInside)
//        assembleButton.layer.cornerRadius = self.frame.size.width/8
//        assembleButton.layer.borderWidth = 2
//        assembleButton.layer.borderColor = UIColor.steelPink.cgColor
//        assembleButton.layer.shadowColor = UIColor.steelPink.cgColor
//        assembleButton.layer.shadowOpacity = 1
//        assembleButton.layer.shadowRadius = 10.0
//        assembleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
//        
//        // Setup ReturnToCurrentLocationButton
//        returnToCurrentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
//        returnToCurrentLocationButton.tintColor = .lilac
//        //        returnToCurrentLocationButton.addTarget(self, action: #selector(returnToCurrentLocation), for: .touchUpInside)
//    }
//}
