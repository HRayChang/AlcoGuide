//
//  DetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var locationName: String?
    var locationPhoneNumber: String?
    var locationAddress: String?
    var locationCoordinate: CLLocationCoordinate2D?

    
    let nameLabel = UILabel()
    let phoneLabel = UILabel()
    let addressLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        nameLabel.text = locationName
        nameLabel.textColor = .white
        phoneLabel.text = locationPhoneNumber
        phoneLabel.textColor = .white
        addressLabel.text = locationAddress
        addressLabel.textColor = .white
        
        setupConstraints()
    }
    
    init(name: String?, phoneNumber: String?, address: String?, coordinate: CLLocationCoordinate2D?) {
         super.init(nibName: nil, bundle: nil)
         self.locationName = name
         self.locationPhoneNumber = phoneNumber
         self.locationAddress = address
         self.locationCoordinate = coordinate
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
     }
    
    func setupConstraints() {
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(nameLabel)
        view.addSubview(phoneLabel)
        view.addSubview(addressLabel)
  
        
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            
        ])
    }
}
