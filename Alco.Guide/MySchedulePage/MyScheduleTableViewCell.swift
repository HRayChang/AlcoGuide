//
//  MyScheduleTableViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import UIKit

class MyScheduleTableViewCell: UITableViewCell {
    
//    let idLabel = UILabel()
    let nameLabel = UILabel()
    let frameView = UIView()
    let cellBackgroundImageView = UIImageView()
  

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMyScheduleTableViewCellUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMyScheduleTableViewCellUI() {
        
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = .clear
        
        nameLabel.textColor = UIColor.lilac
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)

//        idLabel.textColor = UIColor.eminence
//        idLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        frameView.layer.borderColor = UIColor.steelPink.cgColor
        frameView.layer.cornerRadius = 10
        frameView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        frameView.layer.shadowColor = UIColor.steelPink.cgColor
        frameView.layer.shadowOpacity = 1
        frameView.layer.shadowRadius = 10.0
        frameView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        var imageNames = ["1", "2", "3", "4", "5", "6", "7"]
        let randomIndex = Int.random(in: 0..<imageNames.count)
        cellBackgroundImageView.image = UIImage(named: imageNames[randomIndex])
        cellBackgroundImageView.contentMode = .scaleAspectFit
        cellBackgroundImageView.clipsToBounds = true
        cellBackgroundImageView.layer.cornerRadius = 10
        
        contentView.addSubview(frameView)
        contentView.addSubview(cellBackgroundImageView)
//        contentView.addSubview(idLabel)
        contentView.addSubview(nameLabel)

//        idLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        frameView.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 20),
//            
//            idLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5),
//            idLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 20),
            
            frameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            frameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            frameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            frameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            frameView.heightAnchor.constraint(equalToConstant: 100),
            
            cellBackgroundImageView.topAnchor.constraint(equalTo: frameView.topAnchor),
            cellBackgroundImageView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor),
            cellBackgroundImageView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
            cellBackgroundImageView.widthAnchor.constraint(equalTo: frameView.widthAnchor, multiplier: 1/3)
        ])
    }

    func configureCell(with scheduleData: [Schedule], at index: Int) {
        let scheduleID = scheduleData[index].scheduleID
        let scheduleName = scheduleData[index].scheduleName
//        idLabel.text = "ID: \(scheduleID)"
        nameLabel.text = scheduleName
        
    }
    
    
}
