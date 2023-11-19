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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(idLabel)
        contentView.addSubview(nameLabel)

        idLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            idLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(with scheduleData: [ScheduleInfo], at index: Int) {
        if let scheduleID = scheduleData[index].scheduleID, let scheduleName = scheduleData[index].scheduleName {
            idLabel.text = "ID: \(scheduleID)"
            nameLabel.text = "Name: \(scheduleName)"
        }
    }
}
