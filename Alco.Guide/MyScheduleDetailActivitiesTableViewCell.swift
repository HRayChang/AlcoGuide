//
//  MyScheduleDetailTableViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/19.
//

import UIKit

class MyScheduleDetailActivitiesTableViewCell: UITableViewCell {
    
    let activityLabel = UILabel()
    let frameView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMyScheduleDetailActivitiesTableViewCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMyScheduleDetailActivitiesTableViewCellUI()
    }
    
    private func setupMyScheduleDetailActivitiesTableViewCellUI() {
        
        activityLabel.font = UIFont.systemFont(ofSize: 20)
        
        frameView.layer.borderColor = UIColor.red.cgColor
        frameView.layer.borderWidth = 4
        frameView.layer.cornerRadius = 10
        
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        frameView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(activityLabel)
        contentView.addSubview(frameView)
        
        NSLayoutConstraint.activate([
            activityLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 20),
            activityLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -20),
            activityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            frameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            frameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            frameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            frameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            frameView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
