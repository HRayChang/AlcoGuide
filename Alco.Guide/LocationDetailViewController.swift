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
    
    var scheduleID = DataManager.CurrentSchedule.currentScheduleID
    
    var locationId: String?
    var locationName: String?
    var locationPhoneNumber: String?
    var locationAddress: String?
    var locationOpeningHours: [String]?
    var locationCoordinate: LocationGeometry?
    
    let maxRating = 5.0
    let starCount = 5
    var locationRating: Double?
    
    var nameLabel = UILabel()
    var phoneLabel = UILabel()
    var addressLabel = UILabel()
    var openingHoursLabel = UILabel()
    var ratingLabel = UILabel()
    var addToScheduleButton = UIButton()
    let ratingStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailViewUI()
        setupConstraints()
    }
    
    func setupDetailViewUI() {
        view.backgroundColor = UIColor.black
        
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        
        phoneLabel.textColor = .white
        
        addressLabel.textColor = .white
        addressLabel.numberOfLines = 0
        
        openingHoursLabel.textColor = .white
        openingHoursLabel.numberOfLines = 0
        
        ratingLabel.textColor = .white
        
        ratingStackView.distribution = .fillEqually
        ratingStackView.spacing = 5.0
        
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
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        view.addSubview(phoneLabel)
        view.addSubview(addressLabel)
        view.addSubview(addToScheduleButton)
        view.addSubview(openingHoursLabel)
        view.addSubview(ratingStackView)
        view.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            
            ratingStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),

            ratingLabel.centerYAnchor.constraint(equalTo: ratingStackView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingStackView.trailingAnchor, constant: 8),
            
            openingHoursLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 8),
            openingHoursLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            openingHoursLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
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
            locationRating = location.result.rating
            
            let numberOfFilledStars: Int = Int(round(locationRating ?? 0))
                    
            for subview in ratingStackView.subviews {
                subview.removeFromSuperview()
            }
            
            for star in 0..<starCount {
                if star < numberOfFilledStars {
                    if star == numberOfFilledStars - 1 && locationRating?.truncatingRemainder(dividingBy: 1) != 0 {
                        // Partially filled star
                        let fraction = locationRating?.truncatingRemainder(dividingBy: 1)
                        let partialImage = UIImage(systemName: "star.leadinghalf.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
                        let partialImageView = UIImageView(image: partialImage)
                        partialImageView.contentMode = .scaleAspectFit
                        ratingStackView.addArrangedSubview(partialImageView)
                    } else {
                        // Fully filled star
                        let filledImage = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
                        let filledImageView = UIImageView(image: filledImage)
                        filledImageView.contentMode = .scaleAspectFit
                        ratingStackView.addArrangedSubview(filledImageView)
                    }
                } else {
                    // Empty star
                    let emptyImage = UIImage(systemName: "star")
                    let emptyImageView = UIImageView(image: emptyImage)
                    emptyImageView.contentMode = .scaleAspectFit
                    ratingStackView.addArrangedSubview(emptyImageView)
                }
            }
            
            nameLabel.text = locationName
            phoneLabel.text = locationPhoneNumber
            addressLabel.text = locationAddress
            openingHoursLabel.text = locationOpeningHours?.joined(separator: "\n")
            ratingLabel.text = String(locationRating ?? 0)
            
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
