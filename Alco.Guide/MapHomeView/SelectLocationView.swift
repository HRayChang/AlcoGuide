//
//  SelectLocationView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit

protocol SelectLocationViewDelegate: AnyObject {
    func locationButtonTapped(type: LocationType)
}

enum LocationType {
    case convenienceStore
    case bar
    case both
}

class SelectLocationView: UIView {
    
    let scheduleLabel = UILabel()
    let scheduleIDLabel = UILabel()
    let searchConvenienceStoreButton = UIButton()
    let searchBarButton = UIButton()
    let searchBothButton = UIButton()
    
    weak var delegate: SelectLocationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectLocationView()
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSelectLocationView()
        setupObservers()
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
    // MARK: - Update schedule labels
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateScheduleLabels(_:)), name: Notification.Name("ScheduleChange"), object: nil)
    }
    
    @objc private func updateScheduleLabels(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let scheduleID = userInfo["scheduleID"] as? String,
           let scheduleName = userInfo["scheduleName"] as? String {
            scheduleLabel.text = scheduleName
            scheduleIDLabel.text = scheduleID
        }
    }
    // MARK: Update schedule labels -
    
    private func setupSelectLocationView() {
        backgroundColor = UIColor.black
        layer.borderColor = UIColor.steelPink.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 30
        isHidden = true
        
//        scheduleLabel.text = ScheduleInfo.scheduleID
        scheduleLabel.textColor = UIColor.white
        
//        scheduleIDLabel.text = ScheduleInfo.scheduleName
        scheduleIDLabel.textColor = UIColor.white
        
        setupButton(searchConvenienceStoreButton, title: "超商", action: #selector(locationButtonTapped))
        setupButton(searchBarButton, title: "酒吧", action: #selector(locationButtonTapped))
        setupButton(searchBothButton, title: "Both", action: #selector(locationButtonTapped))
        
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleIDLabel.translatesAutoresizingMaskIntoConstraints = false
        searchConvenienceStoreButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarButton.translatesAutoresizingMaskIntoConstraints = false
        searchBothButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scheduleLabel)
        addSubview(scheduleIDLabel)
        addSubview(searchConvenienceStoreButton)
        addSubview(searchBarButton)
        addSubview(searchBothButton)
        
        NSLayoutConstraint.activate([
            scheduleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scheduleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            scheduleLabel.widthAnchor.constraint(equalToConstant: 80),
            scheduleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            scheduleIDLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scheduleIDLabel.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 10),
            scheduleIDLabel.widthAnchor.constraint(equalToConstant: 80),
            scheduleIDLabel.heightAnchor.constraint(equalToConstant: 30),
            
            searchConvenienceStoreButton.trailingAnchor.constraint(equalTo: searchBarButton.leadingAnchor, constant: -10),
            searchConvenienceStoreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchConvenienceStoreButton.widthAnchor.constraint(equalToConstant: 80),
            searchConvenienceStoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            searchBarButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchBarButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBarButton.widthAnchor.constraint(equalToConstant: 80),
            searchBarButton.heightAnchor.constraint(equalToConstant: 50),
            
            searchBothButton.leadingAnchor.constraint(equalTo: searchBarButton.trailingAnchor, constant: 10),
            searchBothButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBothButton.widthAnchor.constraint(equalToConstant: 80),
            searchBothButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupButton(_ button: UIButton, title: String, action: Selector) {
        button.backgroundColor = UIColor.black
        button.layer.borderColor = UIColor.steelPink.cgColor
        button.layer.borderWidth = 5
        button.layer.cornerRadius = 20
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc private func locationButtonTapped(_ sender: UIButton) {
        var locationType: LocationType
        
        switch sender {
        case searchConvenienceStoreButton:
            locationType = .convenienceStore
        case searchBarButton:
            locationType = .bar
        case searchBothButton:
            locationType = .both
        default:
            return
        }
        
        delegate?.locationButtonTapped(type: locationType)
    }
    
 
}
