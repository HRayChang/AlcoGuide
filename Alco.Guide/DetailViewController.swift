//
//  DetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit

class DetailViewController: UIViewController {
    
    var placeName: String?
    var phoneNumber: String?
    var address: String?
    var businessHours: String?
    var rating: Double?
    
    let nameLabel = UILabel()
    let phoneLabel = UILabel()
    let addressLabel = UILabel()
    let hoursLabel = UILabel()
    let ratingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = placeName
        phoneLabel.text = phoneNumber
        addressLabel.text = address
        hoursLabel.text = businessHours
        ratingLabel.text = rating != nil ? String(rating!) : "N/A"
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        view.addSubview(phoneLabel)
        view.addSubview(addressLabel)
        view.addSubview(hoursLabel)
        view.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            
            hoursLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            
            ratingLabel.topAnchor.constraint(equalTo: hoursLabel.bottomAnchor, constant: 8),
        ])
    }
}
