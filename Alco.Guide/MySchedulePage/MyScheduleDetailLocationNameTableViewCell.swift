//
//  MyScheduleDetailLocationNameTableViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/20.
//

import UIKit

class MyScheduleDetailLocationNameTableViewCell: UITableViewCell {
    
    let locationNameLabel = UILabel()
    let frameView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMyScheduleDetailLocationNameTableViewCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMyScheduleDetailLocationNameTableViewCellUI() {
        
        contentView.backgroundColor = UIColor.black
        
        locationNameLabel.textColor = UIColor.lilac
        locationNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        frameView.layer.cornerRadius = 10
        //        frameView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        frameView.layer.shadowColor = UIColor.steelPink.cgColor
        frameView.layer.shadowOpacity = 1
        frameView.layer.shadowRadius = 10.0
        frameView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        frameView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(frameView)
        contentView.addSubview(locationNameLabel)
        
        NSLayoutConstraint.activate([
            locationNameLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 20),
            locationNameLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -20),
            locationNameLabel.centerYAnchor.constraint(equalTo: frameView.centerYAnchor),
            
            frameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            frameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            frameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            frameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            frameView.heightAnchor.constraint(equalToConstant: 50)
        ])
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.eminence.cgColor, UIColor.steelPink.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = frameView.bounds
        gradientLayer.cornerRadius = 10
        frameView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
