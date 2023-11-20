//
//  MyScheduleTableViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import UIKit

class MyScheduleTableViewCell: UITableViewCell {
    
    let idLabel = UILabel()
    let nameLabel = UILabel()
    let frameView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMyScheduleTableViewCellUI()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMyScheduleTableViewCellUI()
    }
    
    private func setupMyScheduleTableViewCellUI() {
        
        contentView.backgroundColor = UIColor.black
        
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        idLabel.textColor = UIColor.white
        idLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        frameView.layer.borderColor = UIColor.steelPink.cgColor
        frameView.layer.borderWidth = 5
        frameView.layer.cornerRadius = 10
        
        contentView.addSubview(idLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(frameView)

        idLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        frameView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 20),
            
            idLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5),
            idLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 20),
            
            frameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            frameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            frameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            frameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            frameView.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }

    func configureCell(with scheduleData: [ScheduleInfo], at index: Int) {
        if let scheduleID = scheduleData[index].scheduleID, let scheduleName = scheduleData[index].scheduleName {
            idLabel.text = "ID: \(scheduleID)"
            nameLabel.text = "Name: \(scheduleName)"
        }
    }
}
