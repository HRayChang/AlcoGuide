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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.eminence.cgColor, UIColor.steelPink.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = addNewScheduleViewButton.bounds
        gradientLayer.cornerRadius = 20
        addNewScheduleViewButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        layer.shadowColor = UIColor.lightPink.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 10
        isHidden = true
        
        addNewScheduleViewTextField.layer.borderWidth = 2
        addNewScheduleViewTextField.layer.borderColor = UIColor.steelPink.cgColor
        addNewScheduleViewTextField.layer.cornerRadius = 10
        addNewScheduleViewTextField.textAlignment = .center
        addNewScheduleViewTextField.textColor = .lilac
        addNewScheduleViewTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Schedule Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lilac]
        )
        
        addNewScheduleViewButton.layer.cornerRadius = 20
        addNewScheduleViewButton.setTitle("Add Schedule", for: .normal)
        addNewScheduleViewButton.setTitleColor(.lilac, for: .normal)
        addNewScheduleViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
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
            
            addNewScheduleViewButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addNewScheduleViewButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30),
            addNewScheduleViewButton.heightAnchor.constraint(equalToConstant: 40),
            addNewScheduleViewButton.widthAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    @objc private func addNewScheduleButtonTapped() {
        
        if let scheduleName = addNewScheduleViewTextField.text, !scheduleName.isEmpty {
            delegate?.addNewScheduleButtonTapped(scheduleName: scheduleName)
            addNewScheduleViewTextField.text = ""
            addNewScheduleViewTextField.resignFirstResponder()
        } else {
            delegate?.showAlert(message: "請輸入行程名稱")
        }
    }
}
