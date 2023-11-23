//
//  DetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit
import MapKit
import FirebaseFirestore

class LocationDetailViewController: UIViewController {
    
    let dataBase = Firestore.firestore()
    
    let mapManager = MapManager.shared
    let dataManager = DataManager.shared
    
    var scheduleID = CurrentSchedule.currentScheduleID
    
    var locationId: String?
    var locationName: String?
    var locationPhoneNumber: String?
    var locationAddress: String?
    var locationOpeningHours: [String]?
    var locationCoordinate: LocationGeometry?
    
    var nameLabel = UILabel()
    var phoneLabel = UILabel()
    var addressLabel = UILabel()
    var openingHoursLabel = UILabel()
    var addToScheduleButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailViewUI()
        setupConstraints()
    }
    
    func setupDetailViewUI() {
        view.backgroundColor = UIColor.black
        
        nameLabel.textColor = .white
        
        phoneLabel.textColor = .white
        
        addressLabel.textColor = .white
        
        openingHoursLabel.textColor = .white
        openingHoursLabel.numberOfLines = 0
        
        addToScheduleButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addToScheduleButton.backgroundColor = UIColor.black
        addToScheduleButton.layer.borderWidth = 3
        addToScheduleButton.layer.borderColor = UIColor.steelPink.cgColor
        addToScheduleButton.tintColor = UIColor.steelPink
        addToScheduleButton.layer.cornerRadius = 20
        addToScheduleButton.addTarget(self, action: #selector(addToScheduleButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addToScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        openingHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        view.addSubview(phoneLabel)
        view.addSubview(addressLabel)
        view.addSubview(addToScheduleButton)
        view.addSubview(openingHoursLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            
            openingHoursLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            openingHoursLabel.heightAnchor.constraint(equalToConstant: 500),
            openingHoursLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            openingHoursLabel.widthAnchor.constraint(equalToConstant: 500),
            
            addToScheduleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            addToScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addToScheduleButton.heightAnchor.constraint(equalToConstant: 40),
            addToScheduleButton.widthAnchor.constraint(equalTo: addToScheduleButton.heightAnchor)
        ])
    }
    
    func fetchLocationInfo(with annotation: MKAnnotation) {
        mapManager.fetchLocationInfo(for: annotation) { [self] location in
            
            locationId = location.result.placeID
            locationName = location.result.name
            locationPhoneNumber = location.result.internationalPhoneNumber
            locationAddress = location.result.formattedAddress
            locationOpeningHours = location.result.openingHours.weekdayText
            locationCoordinate = location.result.geometry.location
            
            nameLabel.text = locationName
            phoneLabel.text = locationPhoneNumber
            addressLabel.text = locationAddress
            openingHoursLabel.text = locationOpeningHours?.joined(separator: "\n")
            
        }
    }
    
    @objc func addToScheduleButtonTapped() {

        guard let scheduleID = scheduleID, let locationName = locationName, let locationId = locationId, let locationCoordinate = locationCoordinate else { return }

        dataManager.addLocationToSchedule(locationName: locationName, locationId: locationId, locationCoordinate: locationCoordinate, scheduleID: scheduleID) { error in
             if let error = error {
                 print("Error adding document: \(error)")
             } else {
                 print("Location: \(String(describing: self.locationName)) added successfully")
             }
         }
     }
}
