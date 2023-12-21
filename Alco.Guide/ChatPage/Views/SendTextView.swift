//
//  SendTextView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/8.
//

import Foundation
import UIKit

protocol SendTextViewDelegate: AnyObject {
    func didTapSendButton(withText text: String)
}

class SendTextView: UIView {
    
    weak var delegate: SendTextViewDelegate?

    let sendButton = UIButton()
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSendTextView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSendTextView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.eminence.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = self.bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupSendTextView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.shadowColor = UIColor.steelPink.withAlphaComponent(0.45).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 40.0
        layer.shadowOffset = CGSize(width: 0, height: -40)
        addBreathingAnimation(to: self)
        
        textField.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.steelPink.cgColor
        textField.layer.cornerRadius = 10
        textField.textColor = .lilac
        textField.attributedPlaceholder = NSAttributedString(
            string: "Aa",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lilac]
        )
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        sendButton.setBackgroundImage(UIImage(systemName: "paperplane.circle.fill"), for: .normal)
        sendButton.tintColor = UIColor.steelPink
        sendButton.layer.shadowColor = UIColor.steelPink.cgColor
        sendButton.layer.shadowOpacity = 1
        sendButton.layer.shadowRadius = 5
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 0)

        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField)
        addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            sendButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            
            ])
    }
    
    func addBreathingAnimation(to view: UIView) {
        let breathingAnimation = CABasicAnimation(keyPath: "shadowRadius")
        breathingAnimation.fromValue = 5
        breathingAnimation.toValue = 20
        breathingAnimation.autoreverses = true
        breathingAnimation.duration = 1
        breathingAnimation.repeatCount = .infinity
        view.layer.add(breathingAnimation, forKey: "breathingAnimation")
    }
    
    @objc func sendButtonTapped() {
           guard let messageText = textField.text, !messageText.isEmpty else {
               return
           }

           delegate?.didTapSendButton(withText: messageText)

           textField.text = ""
       }
    
}

