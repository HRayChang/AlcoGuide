//
//  SelectLocationView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit

protocol ShareScheduleViewDelegate: AnyObject {
    func shareButtonTapped(scheduleId: String)
}

class ShareScheduleView: UIView {
    
    let scheduleLabel = UILabel()
    let scheduleIDLabel = UILabel()
    let shareButton = UIButton(type: .system)
    
    weak var delegate: ShareScheduleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectLocationView()
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
    // MARK: - Update schedule labels
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateScheduleLabels(_:)), name: Notification.Name("CurrentSchedule"), object: nil)
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
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        layer.shadowColor = UIColor.lightPink.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 10
        isHidden = true

        scheduleLabel.textColor = UIColor.lilac
        scheduleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        scheduleLabel.numberOfLines = 0
        scheduleLabel.textAlignment = .center
        
        scheduleIDLabel.textColor = UIColor.lilac
        scheduleIDLabel.textAlignment = .center
        scheduleIDLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        shareButton.setBackgroundImage(UIImage(named: "Icons_24px_Share"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleIDLabel.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scheduleLabel)
        addSubview(scheduleIDLabel)
        addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            scheduleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            scheduleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            scheduleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            scheduleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            scheduleIDLabel.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 10),
            scheduleIDLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -10),
            scheduleIDLabel.heightAnchor.constraint(equalToConstant: 30),
            
            shareButton.leadingAnchor.constraint(equalTo: scheduleIDLabel.trailingAnchor, constant: 10),
            shareButton.centerYAnchor.constraint(equalTo: scheduleIDLabel.centerYAnchor),
            shareButton.widthAnchor.constraint(equalTo: scheduleIDLabel.heightAnchor),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor)
        ])
    }
    
    @objc func shareButtonTapped() {
        
        delegate?.shareButtonTapped(scheduleId: scheduleIDLabel.text!)
       }
}
