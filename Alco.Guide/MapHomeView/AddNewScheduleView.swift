//
//  NewScheduleView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit

protocol AddNewScheduleViewDelegate: AnyObject {
    func addNewScheduleButtonTapped(scheduleName: String)
    func showAlert(message: String)
}

class AddNewScheduleView: UIView {
    
    let addNewScheduleViewTextField = UITextField()
    let addNewScheduleViewButton = UIButton()
    
    weak var delegate: AddNewScheduleViewDelegate?
    
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
        
        addNewScheduleViewTextField.layer.borderColor = UIColor.steelPink.cgColor
        addNewScheduleViewTextField.layer.borderWidth = 5
        addNewScheduleViewTextField.layer.cornerRadius = 20
        addNewScheduleViewTextField.textAlignment = .center
        addNewScheduleViewTextField.textColor = UIColor.white
        addNewScheduleViewTextField.attributedPlaceholder = NSAttributedString(
            string: "請輸入行程名稱",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        addNewScheduleViewButton.backgroundColor = UIColor.black
        addNewScheduleViewButton.layer.borderColor = UIColor.steelPink.cgColor
        addNewScheduleViewButton.layer.borderWidth = 5
        addNewScheduleViewButton.layer.cornerRadius = 20
        addNewScheduleViewButton.setTitle("新增行程", for: .normal)
        addNewScheduleViewButton.setTitleColor(UIColor.white, for: .normal)
        addNewScheduleViewButton.addTarget(self, action: #selector(addNewScheduleButtonTapped), for: .touchUpInside)
        
        addNewScheduleViewButton.translatesAutoresizingMaskIntoConstraints = false
        addNewScheduleViewTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(addNewScheduleViewTextField)
        addSubview(addNewScheduleViewButton)
        
        NSLayoutConstraint.activate([
            addNewScheduleViewTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            addNewScheduleViewTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            addNewScheduleViewTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30),
            addNewScheduleViewTextField.heightAnchor.constraint(equalToConstant: 50),
            addNewScheduleViewButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            addNewScheduleViewButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            addNewScheduleViewButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30),
            addNewScheduleViewButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func addNewScheduleButtonTapped() {
        
        if let scheduleName = addNewScheduleViewTextField.text, !scheduleName.isEmpty {
            delegate?.addNewScheduleButtonTapped(scheduleName: scheduleName)
        } else {
            delegate?.showAlert(message: "請輸入行程名稱")
        }
    }
}
