//
//  DetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    let mapManager = MapManager.shared
    
    var locationName: String?
    var locationPhoneNumber: String?
    var locationAddress: String?
    var locationCoordinate: CLLocationCoordinate2D?
    
    let nameLabel = UILabel()
    let phoneLabel = UILabel()
    let addressLabel = UILabel()
    let addToScheduleButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailViewUI()
        setupConstraints()
    }
    
    func setupDetailViewUI() {
        view.backgroundColor = UIColor.black
        
        nameLabel.text = locationName
        nameLabel.textColor = .white
        
        phoneLabel.text = locationPhoneNumber
        phoneLabel.textColor = .white
        
        addressLabel.text = locationAddress
        addressLabel.textColor = .white
        
        addToScheduleButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addToScheduleButton.layer.borderWidth = 3
        addToScheduleButton.layer.borderColor = UIColor.steelPink.cgColor
        addToScheduleButton.tintColor = UIColor.steelPink
        addToScheduleButton.layer.cornerRadius = 20
    }
    
    func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addToScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        view.addSubview(phoneLabel)
        view.addSubview(addressLabel)
        view.addSubview(addToScheduleButton)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            
            addToScheduleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            addToScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addToScheduleButton.heightAnchor.constraint(equalToConstant: 40),
            addToScheduleButton.widthAnchor.constraint(equalTo: addToScheduleButton.heightAnchor)
        ])
    }

    func updateUI(with annotation: MKAnnotation) {
        getMapItem(for: annotation) { [weak self] mapItem in
            guard let self = self else { return }
            
            self.locationName = mapItem?.name
            self.locationPhoneNumber = mapItem?.phoneNumber
            self.locationAddress = mapItem?.placemark.title
            self.locationCoordinate = mapItem?.placemark.coordinate
            
            // Update the UI with the new data
            self.nameLabel.text = self.locationName
            self.phoneLabel.text = self.locationPhoneNumber
            self.addressLabel.text = self.locationAddress
        }
    }
    
    private func getMapItem(for annotation: MKAnnotation, completion: @escaping (MKMapItem?) -> Void) {
         mapManager.getMapItem(for: annotation, completion: completion)
     }
}
