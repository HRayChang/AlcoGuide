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
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.black
        layer.borderColor = UIColor.steelPink.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 20
        isHidden = true

        joinScheduleViewTextField.layer.borderColor = UIColor.steelPink.cgColor
        joinScheduleViewTextField.layer.borderWidth = 5
        joinScheduleViewTextField.layer.cornerRadius = 20
        joinScheduleViewTextField.textAlignment = .center
        joinScheduleViewTextField.textColor = UIColor.white
        joinScheduleViewTextField.attributedPlaceholder = NSAttributedString(
            string: "請輸入行程編號",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )

        joinScheduleViewButton.backgroundColor = UIColor.black
        joinScheduleViewButton.layer.borderColor = UIColor.steelPink.cgColor
        joinScheduleViewButton.layer.borderWidth = 5
        joinScheduleViewButton.layer.cornerRadius = 20
        joinScheduleViewButton.setTitle("加入行程", for: .normal)
        joinScheduleViewButton.setTitleColor(UIColor.white, for: .normal)
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

            joinScheduleViewButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            joinScheduleViewButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            joinScheduleViewButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30),
            joinScheduleViewButton.heightAnchor.constraint(equalToConstant: 50)
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
