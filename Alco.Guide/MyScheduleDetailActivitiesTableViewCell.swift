//
//  MyScheduleDetailTableViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/19.
//

import UIKit
import MapKit
import FirebaseFirestore

class MyScheduleDetailActivitiesTableViewCell: UITableViewCell {
    
    let activityLabel: UILabel = {
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
        contentView.addSubview(activityLabel)
      
        NSLayoutConstraint.activate([
            activityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            activityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            activityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ])
    }

}
