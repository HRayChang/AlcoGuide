//
//  SelectScheduleView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit

protocol SelectScheduleViewDelegate: AnyObject {
    func showAddNewScheduleView()
    func showJoinScheduleView()
    func showMyScheduleView()
}

class SelectScheduleView: UIView {
    
    weak var delegate: SelectScheduleViewDelegate?

    let newScheduleButton = UIButton()
    let addScheduleButton = UIButton()
    let myScheduleButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectScheduleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let newScheduleButtonGradientLayer = CAGradientLayer()
        newScheduleButtonGradientLayer.colors = [UIColor.eminence.cgColor, UIColor.steelPink.cgColor]
        newScheduleButtonGradientLayer.locations = [0.0, 1.0]
        newScheduleButtonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        newScheduleButtonGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        newScheduleButtonGradientLayer.frame = newScheduleButton.bounds
        newScheduleButtonGradientLayer.cornerRadius = 10
        newScheduleButton.layer.insertSublayer(newScheduleButtonGradientLayer, at: 0)
        
        let addScheduleButtonGradientLayer = CAGradientLayer()
        addScheduleButtonGradientLayer.colors = [UIColor.eminence.cgColor, UIColor.steelPink.cgColor]
        addScheduleButtonGradientLayer.locations = [0.0, 1.0]
        addScheduleButtonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        addScheduleButtonGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        addScheduleButtonGradientLayer.frame = addScheduleButton.bounds
        addScheduleButtonGradientLayer.cornerRadius = 10
        addScheduleButton.layer.insertSublayer(addScheduleButtonGradientLayer, at: 0)
        
        let myScheduleButtonGradientLayer = CAGradientLayer()
        myScheduleButtonGradientLayer.colors = [UIColor.eminence.cgColor, UIColor.steelPink.cgColor]
        myScheduleButtonGradientLayer.locations = [0.0, 1.0]
        myScheduleButtonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        myScheduleButtonGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        myScheduleButtonGradientLayer.frame = myScheduleButton.bounds
        myScheduleButtonGradientLayer.cornerRadius = 10
        myScheduleButton.layer.insertSublayer(myScheduleButtonGradientLayer, at: 0)
    }

    private func setupSelectScheduleView() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        layer.shadowColor = UIColor.lightPink.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 10
        isHidden = true
        
        newScheduleButton.layer.cornerRadius = 20
        newScheduleButton.setTitle("New Schedule", for: .normal)
        newScheduleButton.setTitleColor(.lilac, for: .normal)
        newScheduleButton.addTarget(self, action: #selector(showAddNewScheduleView), for: .touchUpInside)
        newScheduleButton.layer.shadowColor = UIColor.steelPink.cgColor
        newScheduleButton.layer.shadowOpacity = 1
        newScheduleButton.layer.shadowRadius = 5.0
        newScheduleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
      
        addScheduleButton.layer.cornerRadius = 20
        addScheduleButton.setTitle("Join Schedule", for: .normal)
        addScheduleButton.setTitleColor(.lilac, for: .normal)
        addScheduleButton.addTarget(self, action: #selector(showJoinScheduleView), for: .touchUpInside)
        addScheduleButton.layer.shadowColor = UIColor.steelPink.cgColor
        addScheduleButton.layer.shadowOpacity = 1
        addScheduleButton.layer.shadowRadius = 5.0
        addScheduleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        myScheduleButton.layer.cornerRadius = 20
        myScheduleButton.setTitle("My Schedule", for: .normal)
        myScheduleButton.setTitleColor(.lilac, for: .normal)
        myScheduleButton.addTarget(self, action: #selector(showMyScheduleView), for: .touchUpInside)
        myScheduleButton.layer.shadowColor = UIColor.steelPink.cgColor
        myScheduleButton.layer.shadowOpacity = 1
        myScheduleButton.layer.shadowRadius = 5.0
        myScheduleButton.layer.shadowOffset = CGSize(width: 0, height: 0)

        newScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        addScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        myScheduleButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(newScheduleButton)
        addSubview(addScheduleButton)
        addSubview(myScheduleButton)

        NSLayoutConstraint.activate([
            newScheduleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            newScheduleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            newScheduleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -70),
            newScheduleButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/7),
            
            addScheduleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            addScheduleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            addScheduleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addScheduleButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/7),
            
            myScheduleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            myScheduleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            myScheduleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 70),
            myScheduleButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/7)
        ])
    }

    @objc private func showAddNewScheduleView() {
        delegate?.showAddNewScheduleView()
    }

    @objc private func showJoinScheduleView() {
        delegate?.showJoinScheduleView()
    }

    @objc private func showMyScheduleView() {
        delegate?.showMyScheduleView()
    }
}
