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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMyScheduleDetailLocationNameTableViewCellUI()
    }
    
    private func setupMyScheduleDetailLocationNameTableViewCellUI() {
        
        contentView.backgroundColor = UIColor.black
        
        locationNameLabel.textColor = UIColor.white
        locationNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        frameView.layer.borderColor = UIColor.steelPink.cgColor
        frameView.layer.borderWidth = 5
        frameView.layer.cornerRadius = 10
        
        locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        frameView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(locationNameLabel)
        contentView.addSubview(frameView)
        
        NSLayoutConstraint.activate([
            locationNameLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 20),
            locationNameLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -20),
            locationNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            frameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            frameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            frameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            frameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            frameView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
