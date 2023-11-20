//
//  MyScheduleDetailLocationNameTableViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/20.
//

import UIKit
import MapKit
import FirebaseFirestore

class MyScheduleDetailLocationNameTableViewCell: UITableViewCell {
    
    let locationNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(locationNameLabel)
      
        NSLayoutConstraint.activate([
            locationNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            locationNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ])
    }

}
