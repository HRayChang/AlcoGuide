//
//  JoinScheduleView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit

protocol JoinScheduleViewDelegate: AnyObject {
    func joinScheduleButtonTapped(scheduleId: String)
    func showAlert(message: String)
}

class JoinScheduleView: UIView {
    
    let joinScheduleViewTextField = UITextField()
    let joinScheduleViewButton = UIButton()

    weak var delegate: JoinScheduleViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.eminence.cgColor, UIColor.steelPink.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = joinScheduleViewButton.bounds
        gradientLayer.cornerRadius = 20
        joinScheduleViewButton.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        layer.shadowColor = UIColor.lightPink.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 20
        isHidden = true

        joinScheduleViewTextField.layer.borderWidth = 2
        joinScheduleViewTextField.layer.borderColor = UIColor.steelPink.cgColor
        joinScheduleViewTextField.layer.cornerRadius = 10
        joinScheduleViewTextField.textAlignment = .center
        joinScheduleViewTextField.textColor = .lilac
        joinScheduleViewTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Schedule Id",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lilac]
        )

        joinScheduleViewButton.layer.cornerRadius = 20
        joinScheduleViewButton.setTitle("Join", for: .normal)
        joinScheduleViewButton.setTitleColor(.lilac, for: .normal)
        joinScheduleViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        joinScheduleViewButton.addTarget(self, action: #selector(joinScheduleButtonTapped), for: .touchUpInside)

        joinScheduleViewButton.translatesAutoresizingMaskIntoConstraints = false
        joinScheduleViewTextField.translatesAutoresizingMaskIntoConstraints = false

        addSubview(joinScheduleViewTextField)
        addSubview(joinScheduleViewButton)

        NSLayoutConstraint.activate([
            joinScheduleViewTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            joinScheduleViewTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            joinScheduleViewTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30),
            joinScheduleViewTextField.heightAnchor.constraint(equalToConstant: 50),

            joinScheduleViewButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            joinScheduleViewButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30),
            joinScheduleViewButton.heightAnchor.constraint(equalToConstant: 40),
            joinScheduleViewButton.widthAnchor.constraint(equalToConstant: 100),
        ])

    }

    @objc private func joinScheduleButtonTapped() {
        
        if let scheduleId = joinScheduleViewTextField.text, !scheduleId.isEmpty {
            joinScheduleViewTextField.text = ""
            delegate?.joinScheduleButtonTapped(scheduleId: scheduleId)
        } else {
            delegate?.showAlert(message: "請輸入行程名稱")
        }
    }
}
