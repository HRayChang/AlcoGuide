//
//  MyScheduleDetailButtonTableViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/20.
//

import UIKit

class MyScheduleDetailButtonTableViewCell: UITableViewCell {
    
    var locationName: String?
    
    weak var delegate: MyScheduleDetailButtonCellDelegate?
    
    let addActivityButton = UIButton()
    let addActivityTextField = UITextField()
    let sendButton = UIButton()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMyScheduleDetailButtonTableViewCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMyScheduleDetailButtonTableViewCellUI()
    }
    
    private func setupMyScheduleDetailButtonTableViewCellUI() {
        
        contentView.backgroundColor = UIColor.black
        
        addActivityButton.setTitle("Add Activity", for: .normal)
        addActivityButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        addActivityButton.setTitleColor(.lilac, for: .normal)
//        addActivityButton.layer.shadowColor = UIColor.steelPink.cgColor
//        addActivityButton.layer.shadowOpacity = 1
//        addActivityButton.layer.shadowRadius = 5.0
//        addActivityButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        addActivityButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addActivityButton.layer.shadowColor = UIColor.steelPink.cgColor
        addActivityButton.layer.shadowOpacity = 1
        addActivityButton.layer.shadowRadius = 10.0
        addActivityButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        addActivityButton.layer.cornerRadius = 10
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: addActivityTextField.frame.height))
        addActivityTextField.leftView = leftPaddingView
        addActivityTextField.leftViewMode = .always
        
        addActivityTextField.placeholder = "Enter text"
        addActivityTextField.textColor = UIColor.lilac
        addActivityTextField.layer.borderColor = UIColor.steelPink.cgColor
        addActivityTextField.layer.borderWidth = 1
        addActivityTextField.layer.cornerRadius = 10
        addActivityTextField.isHidden = true
        
        sendButton.setTitle("Add", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sendButton.setTitleColor(.lilac, for: .normal)
//        sendButton.layer.shadowColor = UIColor.steelPink.cgColor
//        sendButton.layer.shadowOpacity = 1
//        sendButton.layer.shadowRadius = 5
//        sendButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        sendButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        sendButton.layer.shadowColor = UIColor.steelPink.cgColor
        sendButton.layer.shadowOpacity = 1
        sendButton.layer.shadowRadius = 10.0
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        sendButton.layer.cornerRadius = 10
        sendButton.isHidden = true
        
        contentView.addSubview(addActivityButton)
        contentView.addSubview(addActivityTextField)
        contentView.addSubview(sendButton)
        
        addActivityButton.translatesAutoresizingMaskIntoConstraints = false
        addActivityTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addActivityButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            addActivityButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addActivityButton.widthAnchor.constraint(equalToConstant: 120),
            
            addActivityTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            addActivityTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            addActivityTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addActivityTextField.heightAnchor.constraint(equalTo: sendButton.heightAnchor),
            
            sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            sendButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        addActivityButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let addActivityButtonGradientLayer = CAGradientLayer()
//        addActivityButtonGradientLayer.colors = [UIColor.eminence.cgColor, UIColor.steelPink.cgColor]
//        addActivityButtonGradientLayer.locations = [0.0, 1.0]
//        addActivityButtonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        addActivityButtonGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        addActivityButtonGradientLayer.frame = addActivityButton.bounds
//        addActivityButtonGradientLayer.cornerRadius = 10
//            addActivityButton.layer.insertSublayer(addActivityButtonGradientLayer, at: 0)
//        
//        let sendButtonGradientLayer = CAGradientLayer()
//        sendButtonGradientLayer.colors = [UIColor.steelPink.cgColor, UIColor.eminence.cgColor]
//        sendButtonGradientLayer.locations = [0.0, 1.0]
//        sendButtonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        sendButtonGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        sendButtonGradientLayer.frame = sendButton.bounds
//        sendButtonGradientLayer.cornerRadius = 10
//            sendButton.layer.insertSublayer(sendButtonGradientLayer, at: 0)
//    }
    
    @objc private func buttonTapped() {
        
        delegate?.addButtonTapped(in: self)
        
    }
    
    @objc private func sendButtonTapped() {
        
        guard let text = addActivityTextField.text, !text.isEmpty else {
            // Handle the case when the textField is empty
            return
            
        }
        
        delegate?.sendButtonTapped(in: self, text: text)
        
    }
}
