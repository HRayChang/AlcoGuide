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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMyScheduleDetailActivitiesTableViewCellUI() {
        
        contentView.backgroundColor = UIColor.black
        
        activityLabel.textColor = UIColor.lilac.withAlphaComponent(0.8
        )
        activityLabel.font = UIFont.systemFont(ofSize: 20)
   
        frameView.layer.cornerRadius = 10
        frameView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        frameView.layer.shadowColor = UIColor.eminence.cgColor
        frameView.layer.shadowOpacity = 1
        frameView.layer.shadowRadius = 5
        frameView.layer.shadowOffset = CGSize(width: 0, height: 0)
        frameView.layer.borderColor = UIColor.eminence.withAlphaComponent(0.5).cgColor
        frameView.layer.borderWidth = 0.8
        
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        frameView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(frameView)
        contentView.addSubview(activityLabel)
        
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
