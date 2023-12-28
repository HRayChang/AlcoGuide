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
    let phoneImage = UIImageView()
    let addressImage = UIImageView()
    let openingHoursImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailViewUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addBreathingAnimation(to: addToScheduleButton)
    }
    
    func setupDetailViewUI() {
        view.backgroundColor = UIColor.black
        
        let gradientLayer = CAGradientLayer()
           gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.steelPink.cgColor] // 使用你想要的顏色
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
           view.layer.insertSublayer(gradientLayer, at: 0)
        
        nameLabel.textColor = .lilac
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        phoneLabel.textColor = .lilac
        phoneLabel.font = UIFont.systemFont(ofSize: 19)
        
        addressLabel.textColor = .lilac
        addressLabel.numberOfLines = 0
        addressLabel.font = UIFont.systemFont(ofSize: 18)
        
        openingHoursLabel.textColor = .lilac
        openingHoursLabel.numberOfLines = 0
        openingHoursLabel.font = UIFont.systemFont(ofSize: 18)
        let attributedString = NSMutableAttributedString(string: "Your Text Here")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        openingHoursLabel.attributedText = attributedString
        
        openingHoursImage.image = UIImage(systemName: "storefront")
        openingHoursImage.tintColor = UIColor.lilac
        
        ratingLabel.textColor = .lilac
        ratingLabel.font = UIFont.systemFont(ofSize: 17)
        
        ratingStackView.distribution = .fillEqually
        ratingStackView.spacing = 5.0
        
        phoneImage.image = UIImage(systemName: "phone.fill")
        phoneImage.tintColor = UIColor.lilac
        
        addressImage.image = UIImage(systemName: "mappin.and.ellipse")
        addressImage.tintColor = UIColor.lilac
        
        addToScheduleButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addToScheduleButton.backgroundColor = UIColor.black
        addToScheduleButton.layer.borderWidth = 2
        addToScheduleButton.layer.borderColor = UIColor.steelPink.cgColor
        addToScheduleButton.tintColor = UIColor.steelPink
        addToScheduleButton.layer.cornerRadius = 20
        addToScheduleButton.addTarget(self, action: #selector(addToScheduleButtonTapped), for: .touchUpInside)
        
        addToScheduleButton.layer.shadowColor = UIColor.steelPink.cgColor
        addToScheduleButton.layer.shadowOpacity = 1
        addToScheduleButton.layer.shadowRadius = 5.0
        addToScheduleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addToScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        openingHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneImage.translatesAutoresizingMaskIntoConstraints = false
        addressImage.translatesAutoresizingMaskIntoConstraints = false
        openingHoursImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        view.addSubview(phoneLabel)
        view.addSubview(addressLabel)
        view.addSubview(addToScheduleButton)
        view.addSubview(openingHoursLabel)
        view.addSubview(ratingStackView)
        view.addSubview(ratingLabel)
        view.addSubview(phoneImage)
        view.addSubview(addressImage)
        view.addSubview(openingHoursImage)
        
        NSLayoutConstraint.activate([
            addToScheduleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            addToScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addToScheduleButton.heightAnchor.constraint(equalToConstant: 40),
            addToScheduleButton.widthAnchor.constraint(equalTo: addToScheduleButton.heightAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: addToScheduleButton.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: addToScheduleButton.leadingAnchor, constant: -20),
            
            
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            phoneImage.centerYAnchor.constraint(equalTo: phoneLabel.centerYAnchor),
            phoneImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            phoneImage.heightAnchor.constraint(equalTo: phoneLabel.heightAnchor),
            
            phoneLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 18),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneImage.trailingAnchor, constant: 8),
            
            addressImage.centerYAnchor.constraint(equalTo: addressLabel.centerYAnchor),
            addressImage.centerXAnchor.constraint(equalTo: phoneImage.centerXAnchor),
            addressImage.heightAnchor.constraint(equalTo: addressLabel.heightAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            addressLabel.leadingAnchor.constraint(equalTo: addressImage.trailingAnchor, constant: 8),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingStackView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingStackView.trailingAnchor, constant: 8),
            
            openingHoursLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            openingHoursLabel.leadingAnchor.constraint(equalTo: openingHoursImage.trailingAnchor, constant: 8),
            openingHoursLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            openingHoursImage.topAnchor.constraint(equalTo: openingHoursLabel.topAnchor),
            openingHoursImage.centerXAnchor.constraint(equalTo: phoneImage.centerXAnchor),
            openingHoursImage.heightAnchor.constraint(equalTo: addressImage.heightAnchor),
        ])
    }
    
    func addBreathingAnimation(to view: UIView) {
        let breathingAnimation = CABasicAnimation(keyPath: "shadowRadius")
        breathingAnimation.fromValue = 5
        breathingAnimation.toValue = 20
        breathingAnimation.autoreverses = true
        breathingAnimation.duration = 1
        breathingAnimation.repeatCount = .infinity
        view.layer.add(breathingAnimation, forKey: "breathingAnimation")
    }
    
    func fetchLocationInfo(with annotation: MKAnnotation) {
        mapManager.fetchLocationInfo(for: annotation) { [self] location in
            
            locationId = location.result.placeID
            locationName = location.result.name
            locationPhoneNumber = location.result.internationalPhoneNumber
            locationAddress = String(location.result.formattedAddress.dropFirst(5))
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
                        let partialImage = UIImage(systemName: "star.leadinghalf.fill")?.withTintColor(.steelPink, renderingMode: .alwaysOriginal)
                        let partialImageView = UIImageView(image: partialImage)
                        partialImageView.contentMode = .scaleAspectFit
                        partialImageView.layer.shadowColor = UIColor.steelPink.cgColor
                        partialImageView.layer.shadowOpacity = 1
                        partialImageView.layer.shadowRadius = 2.0
                        partialImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
                        ratingStackView.addArrangedSubview(partialImageView)
                    } else {
                        // Fully filled star
                        let filledImage = UIImage(systemName: "star.fill")?.withTintColor(.steelPink, renderingMode: .alwaysOriginal)
                        let filledImageView = UIImageView(image: filledImage)
                        filledImageView.contentMode = .scaleAspectFit
                        filledImageView.layer.shadowColor = UIColor.steelPink.cgColor
                        filledImageView.layer.shadowOpacity = 1
                        filledImageView.layer.shadowRadius = 2.0
                        filledImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
                        ratingStackView.addArrangedSubview(filledImageView)
                    }
                } else {
                    // Empty star
                    let emptyImage = UIImage(systemName: "star")?.withTintColor(.steelPink, renderingMode: .alwaysOriginal)
                    let emptyImageView = UIImageView(image: emptyImage)
                    emptyImageView.contentMode = .scaleAspectFit
                    emptyImageView.layer.shadowColor = UIColor.steelPink.cgColor
                    emptyImageView.layer.shadowOpacity = 1
                    emptyImageView.layer.shadowRadius = 2.0
                    emptyImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
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
